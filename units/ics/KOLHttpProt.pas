unit KOLHttpProt;

interface

{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$X+}           { Enable extended syntax              }
{$IFNDEF VER80} { Not for Delphi 1                    }
    {$H+}       { Use long strings                    }
    {$J+}       { Allow typed constant to be modified }
{$ENDIF}
{$IFDEF VER110} { C++ Builder V3.0                    }
    {$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125} { C++ Builder V4.0                    }
    {$ObjExportAll On}
{$ENDIF}

{$DEFINE NOFORMS}

uses KOL,
    Windows{WinProcs, WinTypes}, Messages, err,KOLSysUtils { , Classes } ,
    {$IFNDEF NOFORMS}
   { Forms, Controls,}
    {$ENDIF}
    KOLWSocket;

const
    HttpCliVersion     = 147;
    CopyRight : String = ' THttpCli (c) 1997-2002 F. Piette V1.47 ';
    DefaultProxyPort   = '80';
{$IFDEF VER80}
    { Delphi 1 has a 255 characters string limitation }
    HTTP_RCV_BUF_SIZE = 255;
    HTTP_SND_BUF_SIZE = 8193;
{$ELSE}
    HTTP_RCV_BUF_SIZE = 8193;
    HTTP_SND_BUF_SIZE = 8193;
{$ENDIF}
    WM_HTTP_REQUEST_DONE = WM_USER + 1;
    WM_HTTP_SET_READY    = WM_USER + 2;
    WM_HTTP_LOGIN        = WM_USER + 3;
    httperrNoError  = 0;
    httperrBusy     = 1;
    httperrNoData   = 2;
    httperrAborted  = 3;
    httperrOverflow = 4;

type
(*    EHttpException = object(Exception)
        ErrorCode : Word;
         { constructor Create(const Msg : String; ErrCode : Word);
     } end;
PHttpException=^EHttpException;
function NewHttpException(const Msg : String; ErrCode : Word):PHttpException; type  MyStupid0=DWord;
                               *)
    THttpEncoding    = (encUUEncode, encBase64, encMime);
    THttpRequest     = (httpAbort, httpGET, httpPOST, httpHEAD);
    THttpState       = (httpReady,         httpNotConnected, httpConnected,
                        httpDnsLookup,     httpDnsLookupDone,
                        httpWaitingHeader, httpWaitingBody,  httpAborting);

    TOnCommand       = procedure (Sender : PObj;
                                  var S: String) of object;
    TDocDataEvent    = procedure (Sender : PObj;
                                  Buffer : Pointer;
                                  Len    : Integer) of object;
    TCookieRcvdEvent = procedure (Sender       : PObj;
                                  const Data   : String;
                                  var   Accept : Boolean) of object;
    THttpRequestDone = procedure (Sender : PObj;
                                  RqType : THttpRequest;
                                  Error  : Word) of object;
    TBeforeHeaderSendEvent = procedure (Sender       : PObj;
                                        const Method : String;
                                        Headers      : PStrList{TStrings}) of object;
    PHttpCli=^THttpCli;
    THttpCli = object(TObj)//TComponent)
    protected
        FCtrlSocket           : PWSocket;
        FWindowHandle         : HWND;
        FMultiThreaded        : Boolean;
        FState                : THttpState;
        FLocalAddr            : string; {bb}
        FHostName             : String;
        FTargetHost           : String;
        FPort                 : String;
        FProxy                : String;
        FProxyPort            : String;
        FUsername             : String;
        FPassword             : String;
        FProxyUsername        : String;
        FProxyPassword        : String;
        FLocation             : String;
        FConnected            : Boolean;
        FDnsResult            : String;
        FSendBuffer           : array [0..HTTP_SND_BUF_SIZE - 1] of char;
        FRequestType          : THttpRequest;
        FReceiveBuffer        : array [0..HTTP_RCV_BUF_SIZE - 1] of char;
        FReceiveLen           : Integer;
        FLastResponse         : String;
        FHeaderLineCount      : Integer;
        FBodyLineCount        : Integer;
        FAllowedToSend        : Boolean;
        FURL                  : String;
        FPath                 : String;
        FDocName              : String;
        FSender               : String;
        FReference            : String;
        FAgent                : String;
        FAccept               : String;
        FAcceptLanguage       : String;
        FModifiedSince        : TDateTime;       { Warning ! Use GMT date/Time }
        FNoCache              : Boolean;
        FStatusCode           : Integer;
        FReasonPhrase         : String;
        FContentLength        : LongInt;
        FContentType          : String;
        FDoAuthor             : PStrList;
        FContentPost          : String;
        FContentRangeBegin    : String;   {JMR!! Added this line!!!}
        FContentRangeEnd      : String;   {JMR!! Added this line!!!}
        FAcceptRanges         : String;
        FCookie               : String;
        FLocationFlag         : Boolean;
        FHeaderEndFlag        : Boolean;
        FRcvdHeader           : PStrList{TStrings};
        FRcvdStream           : PStream;//PStream; { If assigned, will recv the answer }
        FRcvdCount            : LongInt; { Number of rcvd bytes for the body }
        FSentCount            : LongInt;
        FSendStream           : PStream;//PStream; { Contains the data to send         }
        FReqStream            : PStream;//TMemoryStream;
        FRequestDoneError     : Integer;
        FNext                 : procedure of object;
        FOnStateChange        : TOnEvent;
        FOnSessionConnected   : TOnEvent;
        FOnRequestHeaderBegin : TOnEvent;
        FOnRequestHeaderEnd   : TOnEvent;
        FOnHeaderBegin        : TOnEvent;
        FOnHeaderEnd          : TOnEvent;
        FOnHeaderData         : TOnEvent;
        FOnDocBegin           : TOnEvent;
        FOnDocEnd             : TOnEvent;
        FOnDocData            : TDocDataEvent;
        FOnSendBegin          : TOnEvent;
        FOnSendEnd            : TOnEvent;
        FOnSendData           : TDocDataEvent;
        FOnTrace              : TOnEvent;
        FOnCommand            : TOnCommand;
        FOnCookie             : TCookieRcvdEvent;
        FOnDataAvailable      : TDataAvailable;
        FOnRequestDone        : THttpRequestDone;
        FOnLocationChange     : TOnEvent;
        { Added by Eugene Mayevski }
        FOnSocksConnected     : TSessionConnected;
        FOnSocksAuthState     : TSocksAuthStateEvent;
        FOnSocksError         : TSocksErrorEvent;
        FOnSocketError        : TOnEvent;
        FOnBeforeHeaderSend   : TBeforeHeaderSendEvent;     { Wilfried 9 sep 02}
        procedure DoSocksConnected(ASender: PObj; Error: word);
        procedure DoSocksAuthState(ASender : PObj; AuthState : TSocksAuthState);
        procedure DoSocksError(ASender : PObj; Error : Integer; Msg : String);
        procedure SocketErrorTransfer(ASender : PObj);
        procedure SetSocksServer(value : String);
        procedure SetSocksLevel(value : String);
        procedure SetSocksPort(value : String);
        procedure SetSocksUsercode(value : String);
        procedure SetSocksPassword(value : String);
        procedure SetSocksAuthentication(value : TSocksAuthentication);
        function  GetSocksServer : String;
        function  GetSocksLevel : String;
        function  GetSocksPort : String;
        function  GetSocksUsercode : String;
        function  GetSocksPassword : String;
        function  GetSocksAuthentication : TSocksAuthentication;
        { Mayevski additions end }
        procedure SendRequest(const method,Version: String);
        procedure GetHeaderLineNext; virtual;
        procedure GetBodyLineNext; virtual;
        procedure SendCommand(const Cmd : String); virtual;
        procedure Login; virtual;
        procedure Logout; virtual;
        procedure InternalClear; virtual;
        procedure SocketDNSLookupDone(ASender: PObj; Error: Word); virtual;
        procedure SocketSessionClosed(ASender: PObj; Error: Word); virtual;
        procedure SocketSessionConnected(ASender : PObj; Error : Word); virtual;
        procedure SocketDataSent(ASender : PObj; Error : Word); virtual;
        procedure SocketDataAvailable(ASender: PObj; Error: Word); virtual;
        procedure LocationSessionClosed(ASender: PObj; Error: Word); virtual;
        procedure DoRequestAsync(Rq : THttpRequest); virtual;
        procedure DoRequestSync(Rq : THttpRequest); virtual;
        procedure SetMultiThreaded(newValue : Boolean); virtual;
        procedure StateChange(NewState : THttpState); virtual;
        procedure TriggerStateChange; virtual;
        procedure TriggerCookie(const Data : String;
                                var   bAccept : Boolean); virtual;
        procedure TriggerSessionConnected; virtual;
        procedure TriggerBeforeHeaderSend(const Method : String;
                                          Headers : PStrList{TStrings}); virtual;
        procedure TriggerRequestHeaderBegin; virtual;
        procedure TriggerRequestHeaderEnd; virtual;
        procedure TriggerHeaderBegin; virtual;
        procedure TriggerHeaderEnd; virtual;
        procedure TriggerDocBegin; virtual;
        procedure TriggerDocData(Data : Pointer; Len : Integer); virtual;
        procedure TriggerDocEnd; virtual;
        procedure TriggerSendBegin; virtual;
        procedure TriggerSendData(Data : Pointer; Len : Integer); virtual;
        procedure TriggerSendEnd; virtual;
        procedure TriggerRequestDone; virtual;
        procedure WndProc(var MsgRec: TMessage); virtual;
        procedure SetReady; virtual;
        procedure AdjustDocName; virtual;
    	function  HTTPCliAllocateHWnd(Method: TWndMethod): HWND; virtual;
    	procedure HTTPCliDeallocateHWnd(WHandle: HWND); virtual;
        procedure WMHttpRequestDone(var msg: TMessage);
                 // message WM_HTTP_REQUEST_DONE;
        procedure WMHttpSetReady(var msg: TMessage);
               //   message WM_HTTP_SET_READY;
        procedure WMHttpLogin(var msg: TMessage);
               //   message WM_HTTP_LOGIN;
    public
//        constructor Create(Aowner:TComponent); override;
        destructor  Destroy; virtual;//override;
        procedure   Get;       { Synchronous blocking Get        }
        procedure   Post;      { Synchronous blocking Post       }
        procedure   Head;      { Synchronous blocking Head       }
        procedure   GetASync;  { Asynchronous, non-blocking Get  }
        procedure   PostASync; { Asynchronous, non-blocking Post }
        procedure   HeadASync; { Asynchronous, non-blocking Head }
        procedure   Abort;

        property CtrlSocket      : PWSocket          read  FCtrlSocket;
        property Handle          : HWND              read  FWindowHandle;
        property State           : THttpState        read  FState;
        property LastResponse    : String            read  FLastResponse;
        property ContentLength   : LongInt           read  FContentLength;
        property ContentType     : String            read  FContentType;
        property RcvdCount       : LongInt           read  FRcvdCount;
        property SentCount       : LongInt           read  FSentCount;
        property StatusCode      : Integer           read  FStatusCode;
        property ReasonPhrase    : String            read  FReasonPhrase;
        property DnsResult       : String            read  FDnsResult;
        property AuthorizationRequest : PStrList  read  FDoAuthor;
        property DocName              : String       read  FDocName;
        property Location             : String       read  FLocation
                                                     write FLocation;
        property RcvdStream           : PStream      read  FRcvdStream
                                                     write FRcvdStream;
        property SendStream           : PStream      read  FSendStream
                                                     write FSendStream;
        property RcvdHeader           : PStrList{TStrings}     read  FRcvdHeader;
        property Hostname             : String       read  FHostname;
        public
//    published
        property URL             : String            read  FURL
                                                     write FURL;
        property LocalAddr       : String            read  FLocalAddr   {bb}
                                                     write FLocalAddr;  {bb}
        property Proxy           : String            read  FProxy
                                                     write FProxy;
        property ProxyPort       : String            read  FProxyPort
                                                     write FProxyPort;
        property Sender          : String            read  FSender
                                                     write FSender;
        property Agent           : String            read  FAgent
                                                     write FAgent;
        property Accept          : String            read  FAccept
                                                     write FAccept;
        property AcceptLanguage  : String            read  FAcceptLanguage
                                                     write FAcceptLanguage;
        property Reference       : String            read  FReference
                                                     write FReference;
        property Username        : String            read  FUsername
                                                     write FUsername;
        property Password        : String            read  FPassword
                                                     write FPassword;
        property ProxyUsername   : String            read  FProxyUsername
                                                     write FProxyUsername;
        property ProxyPassword   : String            read  FProxyPassword
                                                     write FProxyPassword;
        property NoCache         : Boolean           read  FNoCache
                                                     write FNoCache;
        property ModifiedSince   : TDateTime         read  FModifiedSince
                                                     write FModifiedSince;
        property Cookie          : String            read  FCookie
                                                     write FCookie;
        property ContentTypePost : String            read  FContentPost
                                                     write FContentPost;
        property ContentRangeBegin: String           read  FContentRangeBegin  {JMR!! Added this line!!!}
                                                     write FContentRangeBegin; {JMR!! Added this line!!!}
        property ContentRangeEnd  : String           read  FContentRangeEnd    {JMR!! Added this line!!!}
                                                     write FContentRangeEnd;   {JMR!! Added this line!!!}
        property AcceptRanges     : String           read  FAcceptRanges;
        property MultiThreaded   : Boolean           read  FMultiThreaded
                                                     write SetMultiThreaded;
        property OnTrace         : TOnEvent      read  FOnTrace
                                                     write FOnTrace;
        property OnSessionConnected : TOnEvent   read  FOnSessionConnected
                                                     write FOnSessionConnected;
        property OnHeaderData    : TOnEvent      read  FOnHeaderData
                                                     write FOnHeaderData;
        property OnCommand       : TOnCommand        read  FOnCommand
                                                     write FOnCommand;
        property OnHeaderBegin   : TOnEvent      read  FOnHeaderBegin
                                                     write FOnHeaderBegin;
        property OnHeaderEnd     : TOnEvent      read  FOnHeaderEnd
                                                     write FOnHeaderEnd;
        property OnRequestHeaderBegin : TOnEvent read  FOnRequestHeaderBegin
                                                     write FOnRequestHeaderBegin;
        property OnRequestHeaderEnd   : TOnEvent read  FOnRequestHeaderEnd
                                                     write FOnRequestHeaderEnd;
        property OnDocBegin      : TOnEvent      read  FOnDocBegin
                                                     write FOnDocBegin;
        property OnDocData       : TDocDataEvent     read  FOnDocData
                                                     write FOnDocData;
        property OnDocEnd        : TOnEvent      read  FOnDocEnd
                                                     write FOnDocEnd;
        property OnSendBegin     : TOnEvent      read  FOnSendBegin
                                                     write FOnSendBegin;
        property OnSendData      : TDocDataEvent     read  FOnSendData
                                                     write FOnSendData;
        property OnSendEnd       : TOnEvent      read  FOnSendEnd
                                                     write FOnSendEnd;
        property OnStateChange   : TOnEvent      read  FOnStateChange
                                                     write FOnStateChange;
        property OnRequestDone   : THttpRequestDone  read  FOnRequestDone
                                                     write FOnRequestDone;
        property OnLocationChange : TOnEvent     read  FOnLocationChange
                                                     write FOnLocationChange;
        property OnCookie         : TCookieRcvdEvent read  FOnCookie
                                                     write FOnCookie;
        property SocksServer     : String            read  GetSocksServer
                                                     write SetSocksServer;
        property SocksLevel      : String            read  GetSocksLevel
                                                     write SetSocksLevel;
        property SocksPort       : String            read  GetSocksPort
                                                     write SetSocksPort;
        property SocksUsercode   : String            read  GetSocksUsercode
                                                     write SetSocksUsercode;
        property SocksPassword   : String            read  GetSocksPassword
                                                     write SetSocksPassword;
        property SocksAuthentication : TSocksAuthentication read GetSocksAuthentication
                                                            write SetSocksAuthentication;
        property OnSocksConnected    : TSessionConnected    read FOnSocksConnected
                                                            write FOnSocksConnected;
        property OnSocksAuthState    : TSocksAuthStateEvent read FOnSocksAuthState
                                                            write FOnSocksAuthState;
        property OnSocksError        : TSocksErrorEvent     read FOnSocksError
                                                            write FOnSocksError;
        property OnSocketError       : TOnEvent         read FOnSocketError
                                                            write FOnSocketError;
        property OnBeforeHeaderSend  : TBeforeHeaderSendEvent read  FOnBeforeHeaderSend
                                                              write FOnBeforeHeaderSend;
    end;

function NewHttpCli (Aowner:PObj{TComponent}):PHttpCli;    

//procedure Register;
{ Syntax of an URL: protocol://[user[:password]@]server[:port]/path }
procedure ParseURL(const URL : String;
                   var Proto, User, Pass, Host, Port, Path : String);
function  Posn(const s, t : String; count : Integer) : Integer;
procedure ReplaceExt(var FName : String; const newExt : String);
function  EncodeLine(Encoding : THttpEncoding;
                     SrcData : PChar; Size : Integer):String;
function EncodeStr(Encoding : THttpEncoding; const Value : String) : String;
function RFC1123_Date(aDate : TDateTime) : String;
function UrlEncode(S : String) : String;
function UrlDecode(S : String) : String;
function IsDigit(Ch : Char) : Boolean;
function IsXDigit(Ch : char) : Boolean;
function XDigit(Ch : char) : Integer;
function htoin(value : PChar; len : Integer) : Integer;
function htoi2(value : PChar) : Integer;


implementation

const
    bin2uue  : String = '`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
    bin2b64  : String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    uue2bin  : String = ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_ ';
    b642bin  : String = '~~~~~~~~~~~^~~~_TUVWXYZ[\]~~~|~~~ !"#$%&''()*+,-./0123456789~~~~~~:;<=>?@ABCDEFGHIJKLMNOPQRS';
    linesize = 45;
type
    TCharSet = set of Char;
const
    UriProtocolSchemeAllowedChars : TCharSet = ['a'..'z','0'..'9','+','-','.'];

function GetBaseUrl(const Url : String) : String; forward;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{procedure Register;
begin
//    RegisterComponents('FPiette', [THttpCli]);
end;
 }

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF VER80}
function TrimRight(Str : String) : String;
var
    i : Integer;
begin
    i := Length(Str);
    while (i > 0) and (Str[i] in [' ', #9]) do
        i := i - 1;
    Result := Copy(Str, 1, i);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TrimLeft(Str : String) : String;
var
    i : Integer;
begin
    if Str[1] <> ' ' then
        Result := Str
    else begin
        i := 1;
        while (i <= Length(Str)) and (Str[i] = ' ') do
            i := i + 1;
        Result := Copy(Str, i, Length(Str) - i + 1);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Trim(Str : String) : String;
begin
    Result := TrimLeft(TrimRight(Str));
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
 { constructor EHttpException.Create(const Msg : String; ErrCode : Word);
 } 
{function NewHttpException (const Msg : String; ErrCode : Word):PHttpException;
begin
    Inherited Create(Msg);
    ErrorCode := ErrCode;
end;
 }

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF VER80}
procedure SetLength(var S: string; NewLength: Integer);
begin
    S[0] := chr(NewLength);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ We cannot use Delphi own function because the date must be specified in   }
{ english and Delphi use the current language.                              }
function RFC1123_Date(aDate : TDateTime) : String;
const
   StrWeekDay : String = 'MonTueWedThuFriSatSun';
   StrMonth   : String = 'JanFebMarAprMayJunJulAugSepOctNovDec';
var
   Year, Month, Day       : Word;
   Hour, Min,   Sec, MSec : Word;
   DayOfWeek              : Word;
begin
   DecodeDate(aDate, Year, Month, Day);
   DecodeTime(aDate, Hour, Min,   Sec, MSec);
   DayOfWeek := ((Trunc(aDate) - 2) mod 7);
   Result := Copy(StrWeekDay, 1 + DayOfWeek * 3, 3) + ', ' +
             Format('%2.2d %s %4.4d %2.2d:%2.2d:%2.2d',
                    [Day, Copy(StrMonth, 1 + 3 * (Month - 1), 3),
                     Year, Hour, Min, Sec]);
end;

{$IFDEF NOFORMS}
{ This function is a callback function. It means that it is called by       }
{ windows. This is the very low level message handler procedure setup to    }
{ handle the message sent by windows (winsock) to handle messages.          }
function HTTPCliWindowProc(
    ahWnd   : HWND;
    auMsg   : Integer;
    awParam : WPARAM;
    alParam : LPARAM): Integer; stdcall;
var
    Obj    : PObj;
    MsgRec : TMessage;
begin
    { At window creation asked windows to store a pointer to our object     }
    Obj := PObj(GetWindowLong(ahWnd, 0));
    if Obj=nil then
      Exit;

    { If the pointer doesn't represent a TCustomFtpCli, just call the default procedure}
    if Obj.Tag=0 then//not (Obj is THTTPCli) then
        Result := DefWindowProc(ahWnd, auMsg, awParam, alParam)
    else begin
        { Delphi use a TMessage type to pass parameter to his own kind of   }
        { windows procedure. So we are doing the same...                    }
        MsgRec.Msg    := auMsg;
        MsgRec.wParam := awParam;
        MsgRec.lParam := alParam;
        { May be a try/except around next line is needed. Not sure ! }
        PHTTPCli(Obj).WndProc(MsgRec);
        Result := MsgRec.Result;
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.HTTPCliAllocateHWnd(Method: TWndMethod) : HWND;
begin
{$IFDEF NOFORMS}
    Result := XSocketAllocateHWnd(@Self);
    SetWindowLong(Result, GWL_WNDPROC, LongInt(@HTTPCliWindowProc));
{$ELSE}
     Result := KOLWSocket.AllocateHWnd(Method);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.HTTPCliDeallocateHWnd(WHandle : HWND);
begin
{$IFDEF NOFORMS}
    XSocketDeallocateHWnd(WHandle);
{$ELSE}
    KOLWSocket.DeallocateHWnd(WHandle);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
 { constructor THttpCli.Create(Aowner:TComponent);
 } 
function NewHttpCli (Aowner:PObj{TComponent}):PHttpCli;
begin
New( Result, Create );
with Result^ do
begin
  Tag:=2;
//    inherited create(AOwner);
    FWindowHandle                  := HTTPCliAllocateHWnd(WndProc);
    FCtrlSocket                    := NewWSocket(Result);//TWSocket.Create(Self);
    FProxyPort                     := DefaultProxyPort;
    FContentPost                   := 'application/x-www-form-urlencoded';
    FAccept                        := 'image/gif, image/x-xbitmap, ' +
                                      'image/jpeg, image/pjpeg, */*';
    FAgent                         := 'Mozilla/3.0 (compatible)';
    FDoAuthor                      :=NewStrList;// PStrList.Create;
    FCtrlSocket.OnSessionClosed    := SocketSessionClosed;
    FCtrlSocket.OnDataAvailable    := SocketDataAvailable;
    FCtrlSocket.OnSessionConnected := SocketSessionConnected;
    FCtrlSocket.OnDataSent         := SocketDataSent;
    FCtrlSocket.OnDnsLookupDone    := SocketDNSLookupDone;
    { Added by Eugene Mayevski }
    FCtrlSocket.OnSocksError       := DoSocksError;
    FCtrlSocket.OnSocksConnected   := DoSocksConnected;
    FCtrlSocket.OnError            := SocketErrorTransfer;
    { Mayevski additions end }
    FRcvdHeader                    := NewStrList;////PStrList.Create;
    FReqStream                     := NewMemoryStream;//TMemoryStream.Create;
    FState                         := httpReady;
    FLocalAddr                     := '0.0.0.0'; {bb}
end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor THttpCli.Destroy;
// virtual;
 begin
    FDoAuthor.Free;
    FCtrlSocket.Free;
    FRcvdHeader.Free;
    FReqStream.Free;
    HTTPCliDeAllocateHWnd(FWindowHandle);
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WndProc(var MsgRec: TMessage);
begin
     with MsgRec do begin
         case Msg of
         WM_HTTP_REQUEST_DONE : WMHttpRequestDone(MsgRec);
         WM_HTTP_SET_READY    : WMHttpSetReady(MsgRec);
         WM_HTTP_LOGIN        : WMHttpLogin(MsgRec);
         else
             Result := DefWindowProc(Handle, Msg, wParam, lParam);
         end;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THTTPCli.DoSocksConnected(ASender: PObj; Error: word);
begin
  if Assigned(FOnSocksConnected) then FOnSocksConnected(ASender, Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THTTPCli.SocketErrorTransfer(ASender : PObj);
begin
  if (assigned(FOnSocketError)) then
    FOnSocketError(@Self);  { Substitute Self for subcomponent's Sender. }
end;  { SocketErrorTransfer }


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THTTPCli.DoSocksAuthState(ASender : PObj; AuthState : TSocksAuthState);
begin
  if Assigned(FOnSocksAuthState) then FOnSocksAuthState(ASender, AuthState);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THTTPCli.DoSocksError(ASender : PObj; Error : Integer; Msg : String);
begin
  if Assigned(FOnSocksError) then FOnSocksError(ASender, Error, Msg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetMultiThreaded(newValue : Boolean);
begin
    FMultiThreaded            := newValue;
    FCtrlSocket.MultiThreaded := newValue;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetReady;
begin
    PostMessage(Handle, WM_HTTP_SET_READY, 0, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.StateChange(NewState : THttpState);
begin
    if FState <> NewState then begin
        FState := NewState;
        TriggerStateChange;
        if NewState = httpReady then
            TriggerRequestDone;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerStateChange;
begin
    if Assigned(FOnStateChange) then
        FOnStateChange(@Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerCookie(const Data : String; var bAccept : Boolean);
begin
    if Assigned(FOnCookie) then
        FOnCookie(@Self, Data, bAccept);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSessionConnected;
begin
    if Assigned(FOnSessionConnected) then
        FOnSessionConnected(@Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerDocBegin;
begin
    if Assigned(FOnDocBegin) then
        FOnDocBegin(@Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerDocEnd;
begin
    if Assigned(FOnDocEnd) then
        FOnDocEnd(@Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerDocData(Data : Pointer; Len : Integer);
begin
    if Assigned(FOnDocData) then
        FOnDocData(@Self, Data, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSendBegin;
begin
    if Assigned(FOnSendBegin) then
        FOnSendBegin(@Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSendEnd;
begin
    if Assigned(FOnSendEnd) then
        FOnSendEnd(@Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSendData(Data : Pointer; Len : Integer);
begin
    if Assigned(FOnSendData) then
        FOnSendData(@Self, Data, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerHeaderBegin;
begin
    FHeaderEndFlag := TRUE;
    if Assigned(FOnHeaderBegin) then
        FOnHeaderBegin(@Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerHeaderEnd;
begin
    FHeaderEndFlag := FALSE;
    if Assigned(FOnHeaderEnd) then
        FOnHeaderEnd(@Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerBeforeHeaderSend(
    const Method : String;
    Headers      : PStrList{TStrings});
begin
    if Assigned(FOnBeforeHeaderSend) then
        FOnBeforeHeaderSend(@Self, Method, Headers);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerRequestHeaderBegin;
begin
    if Assigned(FOnRequestHeaderBegin) then
        FOnRequestHeaderBegin(@Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerRequestHeaderEnd;
begin
    if Assigned(FOnRequestHeaderEnd) then
        FOnRequestHeaderEnd(@Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerRequestDone;
begin
    PostMessage(Handle, WM_HTTP_REQUEST_DONE, 0, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WMHttpRequestDone(var msg: TMessage);
begin
    if Assigned(FOnRequestDone) then
        FOnRequestDone(@Self, FRequestType, FRequestDoneError);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WMHttpSetReady(var msg: TMessage);
begin
    StateChange(httpReady);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure ReplaceExt(var FName : String; const newExt : String);
var
    I : Integer;
begin
    I := Posn('.', FName, -1);
    if I <= 0 then
        FName := FName + '.' + newExt
    else
        FName := Copy(FName, 1, I) + newExt;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.Abort;
var
    bFlag : Boolean;
begin
    if FState = httpReady then begin
        if FCtrlSocket.State <> wsClosed then
            FCtrlSocket.Close; { This should never occurs ! }
        Exit;
    end;

    bFlag := (FState = httpDnsLookup);
    StateChange(httpAborting);

    if bFlag then begin
        try
            FCtrlSocket.CancelDnsLookup;
        except
            { Ignore any exception }
        end;
    end;

    FStatusCode       := 404;
    FReasonPhrase     := 'Connection aborted on request';
    FRequestDoneError := httperrAborted;

    if bFlag then
        SocketSessionClosed(@Self, 0)
    else
        FCtrlSocket.Close;
    StateChange(httpReady);  { 13/02/99 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.Login;
begin
    FDnsResult := '';
    StateChange(httpDnsLookup);
    FCtrlSocket.LocalAddr := FLocalAddr; {bb}
    try
        FCtrlSocket.DnsLookup(FHostName);
    except
        on E: Exception do begin
            FStatusCode   := 404;
            FReasonPhrase := E.Message;
            FConnected    := FALSE;
            StateChange(httpReady);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketDNSLookupDone(ASender: PObj; Error: Word);
begin
    if Error <> 0 then begin
        if FState = httpAborting then
            Exit;
        FRequestDoneError := Error;
        FStatusCode       := 404;
        FReasonPhrase     := 'can''t resolve hostname to IP address';
        SocketSessionClosed(ASender, Error);
    end
    else begin
        FDnsResult            := FCtrlSocket.DnsResult;
        StateChange(httpDnsLookupDone);  { 19/09/98 }
        FCtrlSocket.Addr      := FDnsResult;
        FCtrlSocket.LocalAddr := FLocalAddr; {bb}
        FCtrlSocket.Port      := FPort;
        FCtrlSocket.Proto     := 'tcp';
        try
            FCtrlSocket.Connect;
        except
            FRequestDoneError := FCtrlSocket.LastError;
            FStatusCode       := 404;
            FReasonPhrase     := 'can''t connect: ' +
                                 WSocketErrorDesc(FCtrlSocket.LastError) +
                                 ' (Error #' + IntToStr(FCtrlSocket.LastError) + ')';
            FCtrlSocket.Close;
            SocketSessionClosed(ASender, FCtrlSocket.LastError);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketSessionConnected(ASender : PObj; Error : Word);
begin
    if Error <> 0 then begin
        FRequestDoneError := Error;
        FStatusCode       := 404;
        FReasonPhrase     := WSocketErrorDesc(Error) +
                             ' (Error #' + IntToStr(Error) + ')';
        SocketSessionClosed(ASender, Error);
        Exit;
    end;

    FConnected := TRUE;
    StateChange(httpConnected);
    TriggerSessionConnected;

    FNext := GetHeaderLineNext;
    StateChange(httpWaitingHeader);

    try
        case FRequestType of
        httpPOST:
            begin
                SendRequest('POST', '1.0');
                TriggerSendBegin;
                FAllowedToSend := TRUE;
                SocketDataSent(FCtrlSocket, 0);
            end;
        httpHEAD:
            begin
                SendRequest('HEAD', '1.0');
            end;
        httpGET:
            begin
                SendRequest('GET', '1.0');
            end;
        end;
    except
        Logout;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.Logout;
begin
    FCtrlSocket.Close;
    FConnected := FALSE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SendCommand(const Cmd : String);
const
    CRLF : String[2] = #13#10;
var
    Buf : String;
begin
    Buf := Cmd;
    if Assigned(FOnCommand) then
        FOnCommand(@Self, Buf);
    if Length(Buf) > 0 then
        FReqStream.Write(Buf[1], Length(Buf));
    FReqStream.Write(CRLF[1], 2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SendRequest(const Method, Version: String); 
var
    Headers : PStrList{TStrings};
    N       : Integer;
begin
    Headers := NewStrList;//PStrList.Create;
    try
//        FReqStream.Clear;
        FReqStream.Size:=0;
        FReqStream.Position:=0;
        TriggerRequestHeaderBegin;
        Headers.Add(method + ' ' + FPath + ' HTTP/' + Version);
        if FSender <> '' then
            Headers.Add('From: ' + FSender);
        if FAccept <> '' then
            Headers.Add('Accept: ' + FAccept);
        if FReference <> '' then
            Headers.Add('Referer: ' + FReference);
        if FAcceptLanguage <> '' then
            Headers.Add('Accept-Language: ' + FAcceptLanguage);
        if (method = 'POST') and (FContentPost <> '') then
            Headers.Add('Content-Type: ' + FContentPost);
        if FAgent <> '' then
            Headers.Add('User-Agent: ' + FAgent);
        Headers.Add('Host: ' + FTargetHost);
        if FNoCache then
            Headers.Add('Pragma: no-cache');
        if method = 'POST' then
            Headers.Add('Content-Length: ' + IntToStr(SendStream.Size));
        if FModifiedSince <> 0 then
            Headers.Add('If-Modified-Since: ' +
                        RFC1123_Date(FModifiedSince) + ' GMT');
        if FUsername <> '' then
            Headers.Add('Authorization: Basic ' +
                        EncodeStr(encBase64, FUsername + ':' + FPassword));
        if (FProxy <> '') and (FProxyUsername <> '') then
            Headers.Add('Proxy-Authorization: Basic ' +
                        EncodeStr(encBase64, FProxyUsername + ':' + FProxyPassword));
        if FCookie <> '' then
            Headers.Add('Cookie: ' + FCookie);
        if (FContentRangeBegin <> '') or (FContentRangeEnd <> '') then begin            {JMR!! Added this line!!!}
            Headers.Add('Range: bytes=' + FContentRangeBegin + '-' + FContentRangeEnd); {JMR!! Added this line!!!}
          FContentRangeBegin := '';                                                     {JMR!! Added this line!!!}
          FContentRangeEnd   := '';                                                     {JMR!! Added this line!!!}
        end;                                                                            {JMR!! Added this line!!!}
        FAcceptRanges := '';

{SendCommand('UA-pixels: 1024x768'); }
{SendCommand('UA-color: color8'); }
{SendCommand('UA-OS: Windows 95'); }
{SendCommand('UA-CPU: x86'); }
{SendCommand('User-Agent: Mozilla/3.0 (compatible)');} {; MSIE 3.01; Update a; Windows 95)');}
{SendCommand('Proxy-Connection: Keep-Alive'); }

        TriggerBeforeHeaderSend(Method, Headers);
        for N := 0 to Headers.Count - 1 do
            SendCommand(Headers.Items[N]);

        TriggerRequestHeaderEnd;
        SendCommand('');
        FCtrlSocket.Send(FReqStream.Memory, FReqStream.Size);
       // FReqStream.Clear;
       FReqStream.Size:=0;
       FReqStream.Position:=0;
    finally
        Headers.Free;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.GetBodyLineNext;
var
    Len  : Integer;
    Data : Pointer;
const
    CRLF : String[2] = #13#10;
begin
    if FBodyLineCount = 0 then
        TriggerDocBegin;
    Inc(FBodyLineCount);

    Len := Length(FLastResponse);
    if Len > 0 then
        Data := @FLastResponse[1]
    else
        Data := @Len;
    FRcvdCount := FRcvdCount + Len;

    if Assigned(FRcvdStream) then
        FRcvdStream.Write(Data^, Len);
    TriggerDocData(Data, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.GetHeaderLineNext;
var
    proto   : String;
    user    : String;
    pass    : String;
    port    : String;
    Host    : String;
    Path    : String;
    Field   : String;
    Data    : String;
    nSep    : Integer;
    tmpInt  : LongInt;
    bAccept : Boolean;
    DocExt  : String;
begin
    if FHeaderLineCount = 0 then
        TriggerHeaderBegin;
    Inc(FHeaderLineCount);

    { Some server send HTML document without header ! I don't know if it is  }
    { legal, but it exists (AltaVista Discovery does that).                  }
    if UpperCase(Copy(FLastResponse, 1, 6)) = '<HTML>' then begin { 15/09/98 }
        if FContentType = '' then
            FContentType := 'text/html';
        StateChange(httpWaitingBody);
        FNext := GetBodyLineNext;
        TriggerHeaderEnd;
        GetBodyLineNext;
        Exit;
    end;

    if FLastResponse = '' then begin
        if FLocationFlag then begin
            TriggerHeaderEnd;
            FReceiveLen       := 0;
            FHeaderLineCount  := 0;
            FBodyLineCount    := 0;
            FCtrlSocket.OnSessionClosed := LocationSessionClosed;
            FCtrlSocket.Close;
            Exit;
        end;
        { FContentLength = -1 when server doesn't send a value }
        if FContentLength = 0 then begin
            TriggerHeaderEnd;
            SetReady;
            Exit;
        end;
        DocExt := lowercase(ExtractFileExt(FDocName));
        if (DocExt = '.exe') or (DocExt = '') then begin
            if FContentType = 'text/html' then
                ReplaceExt(FDocName, 'htm');
        end;

        StateChange(httpWaitingBody);
        FNext := GetBodyLineNext;
        TriggerHeaderEnd;
        if FReceiveLen > 0 then begin
            SetLength(FLastResponse, FReceiveLen);
            Move(FReceiveBuffer, FLastResponse[1], FReceiveLen);
            GetBodyLineNext;
            FReceiveLen := 0;
        end;
        if FStatusCode >= 400 then   { 01/11/01 }
            FCtrlSocket.Close;
        Exit;
    end;

    FRcvdHeader.Add(FLastResponse);

    nSep := pos(':', FLastResponse);
    if (Copy(FLastResponse, 1, 8) = 'HTTP/1.0') or
       (Copy(FLastResponse, 1, 8) = 'HTTP/1.1') then begin
        FStatusCode   := StrToInt(Copy(FLastResponse, 10, 3));
        FReasonPhrase := Copy(FLastResponse, 14, Length(FLastResponse));
    end
    else if nSep > 0 then begin
        Field := LowerCase(Copy(FLastResponse, 1, nSep - 1));
        { Skip spaces }
        Inc(nSep);
        while (nSep < Length(FLastResponse)) and
              (FLastResponse[nSep] = ' ') do
              Inc(nSep);
        Data  := Copy(FLastResponse, nSep, Length(FLastResponse));
        if Field = 'location' then begin { Change the URL ! }
            { URL with relocations:                 }
            { http://www.webcom.com/~wol2wol/       }
            { http://www.purescience.com/delphi/    }
            { http://www.maintron.com/              }
            { http://www.infoseek.com/AddURL/addurl }
            { http://www.micronpc.com/              }
            { http://www.amazon.com/                }
            { http://count.paycounter.com/?fn=0&si=44860&bt=msie&bv=5&    }
            { co=32&js=1.4&sr=1024x768&re=http://www.thesite.com/you.html }
            FLocationFlag := TRUE;
            if Proxy <> '' then begin
                { We are using a proxy }
                if Data[1] = '/' then begin
                    { Absolute location }
                    ParseURL(FPath, proto, user, pass, Host, port, Path);
                    if Proto = '' then
                        Proto := 'http';
                    FLocation := Proto + '://' + Host + Data;
                    FPath     := FLocation;

                    if (user <> '') and (pass <> '') then begin
                        { save user and password given in location @@@}
                        FUsername   := user;
                        FPassword   := pass;
                    end;
                end
                else if Copy(Data, 1, 7) <> 'http://' then begin
                    { Relative location }
                    FPath     := GetBaseUrl(FPath) + Data;
                    if Proto = '' then
                        Proto := 'http';
                    FLocation := Proto + '://' + FHostName + '/' + FPath;
                end
                else begin
                    ParseURL(Data, proto, user, pass, Host, port, Path);
                    if port <> '' then
                        FPort := port
                    else
                        FPort := '80';

                    if (user <> '') and (pass <> '') then begin
                        { save user and password given in location @@@}
                        FUsername   := user;
                        FPassword   := pass;
                    end;

                    if (Proto <> '') and (Host <> '') then begin
                        { We have a full relocation URL }
                        FTargetHost := Host;
                        FLocation   := Proto + '://' + Host + Path;
                        FPath       := FLocation;
                    end
                    else begin
                        if Proto = '' then
                            Proto := 'http';
                        if FPath = '' then
                            FLocation := Proto + '://' + FTargetHost + '/' + Host
                        else if Host = '' then
                            FLocation := Proto + '://' + FTargetHost + FPath
                        else
                            FTargetHost := Host;
                    end;
                end;
            end
            { We are not using a proxy }
            else begin
                if Data[1] = '/' then begin
                    { Absolute location }
                    FPath     := Data;
                    if Proto = '' then
                        Proto := 'http';
                    FLocation := Proto + '://' + FHostName + FPath;
                end
                else if Copy(Data, 1, 7) <> 'http://' then begin
                    { Relative location }
                    FPath     := GetBaseUrl(FPath) + Data;
                    if Proto = '' then
                        Proto := 'http';
                    FLocation := Proto + '://' + FHostName + '/' + FPath;
                end
                else begin
                    ParseURL(Data, proto, user, pass, FHostName, port, FPath);
                    if port <> '' then
                        FPort := port
                    else
                        FPort := '80';

                    if (user <> '') and (pass <> '') then begin
                        { save user and password given in location @@@}
                        FUsername   := user;
                        FPassword   := pass;
                    end;

                    if (Proto <> '') and (FHostName <> '') then begin
                        { We have a full relocation URL }
                        FTargetHost := FHostName;
                        if FPath = '' then begin
                            FPath := '/';
                            FLocation := Proto + '://' + FHostName;
                        end
                        else
                            FLocation := Proto + '://' + FHostName + FPath;
                    end
                    else begin
                        if Proto = '' then
                            Proto := 'http';
                        if FPath = '' then begin
                            FLocation := Proto + '://' + FTargetHost + '/' + FHostName;
                            FHostName := FTargetHost;
                            FPath     := FLocation;          { 26/11/99 }
                        end
                        else if FHostName = '' then begin
                            FLocation := Proto + '://' + FTargetHost + FPath;
                            FHostName := FTargetHost;
                        end
                        else
                            FTargetHost := FHostName;
                    end;
                end;
            end;
        end
        else if Field = 'content-length' then
            FContentLength := StrToInt(Trim(Data))
        else if Field = 'content-range' then begin                             {JMR!! Added this line!!!}
            tmpInt := Pos('-', Data) + 1;                                      {JMR!! Added this line!!!}
            FContentRangeBegin := Copy(Data, 7, tmpInt-8);                     {JMR!! Added this line!!!}
            FContentRangeEnd   := Copy(Data, tmpInt, Pos('/', Data) - tmpInt); {JMR!! Added this line!!!}
        end                                                                    {JMR!! Added this line!!!}
        else if Field = 'accept-ranges' then
            FAcceptRanges := Data
        else if Field = 'content-type' then
            FContentType := LowerCase(Data)
        else if Field = 'www-authenticate' then
            FDoAuthor.add(Data)
        else if Field = 'set-cookie' then begin
            bAccept := TRUE;
            TriggerCookie(Data, bAccept);
        end
    {   else if Field = 'date' then }
    {   else if Field = 'mime-version' then }
    {   else if Field = 'pragma' then }
    {   else if Field = 'allow' then }
    {   else if Field = 'server' then }
    {   else if Field = 'content-encoding' then }
    {   else if Field = 'expires' then }
    {   else if Field = 'last-modified' then }
   end
   else { Ignore  all other responses }
       ;

    if Assigned(FOnHeaderData) then
        FOnHeaderData(@Self);

{    if FStatusCode >= 400 then    Moved above 01/11/01 }
{        FCtrlSocket.Close;                             }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.InternalClear;
begin
    FRcvdHeader.Clear;
    FRequestDoneError := 0;
    FDocName          := '';
    FStatusCode       := 0;
    FRcvdCount        := 0;
    FSentCount        := 0;
    FHeaderLineCount  := 0;
    FBodyLineCount    := 0;
    FContentLength    := -1;
    FContentType      := '';  { 25/09/1999 }
    FAllowedToSend    := FALSE;
    FLocation         := FURL;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DoRequestAsync(Rq : THttpRequest);
var
    Proto, User, Pass, Host, Port, Path: String;
begin
    if FState <> httpReady then
  ;//      raise EHttpException.Create('HTTP component is busy', httperrBusy);

    if (Rq = httpPOST) and (not Assigned(FSendStream)) then
      ;//  raise EHttpException.Create('HTTP component has nothing to post',
              //                      httperrNoData);

    { Now clear all internal state variables }
    FCtrlSocket.OnSessionClosed := SocketSessionClosed;
    StateChange(httpNotConnected);
    FRequestType := Rq;
    InternalClear;

    { parse url and proxy to FHostName, FPath and FPort }
    if FProxy <> '' then begin
        ParseURL(FURL, Proto, User, Pass, Host, Port, Path);
        FTargetHost := Host;
        FPath       := FURL;
        FDocName    := Path;
        if User <> '' then
            FUserName := User;
        if Pass <> '' then
            FPassword := Pass;
        { We need to remove usercode/Password from the URL given to the proxy }
        { but preserve the port                                               }
        if Port <> '' then
            Port := ':' + Port;
        if Proto = '' then
            FPath := 'http://'+ Host + Port + Path
        else
            FPath := Proto + '://' + Host + Port + Path;
        ParseURL(FProxy, Proto, User, Pass, Host, Port, Path);
        if Port = '' then
            Port := ProxyPort;
    end
    else begin
        ParseURL(FURL, Proto, User, Pass, Host, Port, FPath);
        FTargetHost := Host;
        FDocName    := FPath;
        if User <> '' then
            FUserName := User;
        if Pass <> '' then
            FPassword := Pass;
        if Port = '' then
            Port := '80';
    end;
    if Proto = '' then
        Proto := 'http';
    if FPath = '' then
        FPath := '/';

    AdjustDocName;

    FHostName   := host;
    FPort       := Port;

    { Ask to connect. When connected, we go at SocketSeesionConnected. }
    Login;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.AdjustDocName;
var
    I : Integer;
begin
    I := Pos('?', FDocName);
    if I > 0 then
        FDocName := Copy(FDocName, 1, I - 1);

    if (FDocName = '') or (FDocName[Length(FDocName)] = '/') then
        FDocName := 'document.htm'
    else begin
        if FDocName[Length(FDocName)] = '/' then
            SetLength(FDocName, Length(FDocName) - 1);
        FDocName := Copy(FDocName, Posn('/', FDocName, -1) + 1, 255);
        I := Pos('?', FDocName);
        if I > 0 then
            FDocName := Copy(FDocName, 1, I - 1);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DoRequestSync(Rq : THttpRequest);
begin
    DoRequestAsync(Rq);

{$IFDEF VER80}
    { Delphi 1 has no support for multi-threading }
    while FState <> httpReady do
        Application.ProcessMessages;
{$ELSE}
    if FMultiThreaded then begin
        while FState <> httpReady do begin
            FCtrlSocket.ProcessMessages;
            Sleep(0);
        end;
    end
    else begin
        while FState <> httpReady do begin
{$IFNDEF NOFORMS}
            Applet.ProcessMessages; //Application.ProcessMessages;
{$ELSE}
		    FCtrlSocket.ProcessMessages;
{$ENDIF}
            Sleep(0);
        end;
    end;
{$ENDIF}

    if FStatusCode >= 400 then
     ;//   raise EHttpException.Create(FReasonPhrase, FStatusCode);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.LocationSessionClosed(ASender: PObj; Error: Word);
var
    Proto, User, Pass, Host, Port, Path: String;
    RealLocation : String;
    I            : Integer;
begin
    { Remove any bookmark from the URL }
    I := Pos('#', FLocation);
    if I > 0 then
        RealLocation := Copy(FLocation, 1, I - 1)
    else
        RealLocation := FLocation;

    { Parse the URL }
    ParseURL(RealLocation, Proto, User, Pass, Host, Port, Path);
    FDocName := Path;
    AdjustDocName;
    FConnected    := FALSE;
    FLocationFlag := FALSE;
    { When relocation occurs doing a POST, new relocated page has to be GET }
    if FRequestType = httpPOST then
        FRequestType  := httpGET;
    { Restore normal session closed event }
    FCtrlSocket.OnSessionClosed := SocketSessionClosed;
    { Trigger the location changed event }
    if Assigned(FOnLocationChange) then
         FOnLocationChange(@Self);
    { Clear header from previous operation }
    FRcvdHeader.Clear;
    { Clear status variables from previous operation }
    FHeaderLineCount  := 0;
    FBodyLineCount    := 0;
    FContentLength    := -1;
    FContentType      := '';
    FStatusCode       := 0;
    { Adjust for proxy use  (Fixed: Nov 10, 2001) }
    if FProxy <> '' then
        FPort := ProxyPort;
    { Restart at login procedure }
    PostMessage(FWindowHandle, WM_HTTP_LOGIN, 0, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WMHttpLogin(var msg: TMessage);
begin
    Login;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketSessionClosed(ASender: PObj; Error: Word);
begin
    if Error <> 0 then               { WM 15 sep 2002 }
        FRequestDoneError := Error;  { WM 15 sep 2002 }
    FConnected := FALSE;
    if FHeaderEndFlag then begin
        { TriggerHeaderEnd has not been called yet }
        TriggerHeaderEnd;
        if FLocationFlag then            { 28/10/01 }
            LocationSessionClosed(@Self, 0);
        Exit;
    end;
    if FBodyLineCount > 0 then
        TriggerDocEnd;
    SetReady; {StateChange(httpReady);}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketDataAvailable(ASender: PObj; Error: Word);
var
    Len : Integer;
    I   : Integer;
begin
    I := sizeof(FReceiveBuffer) - FReceiveLen - 1;
    if I <= 0 then
;//        raise EHttpException.Create('HTTP line too long', httperrOverflow);

    Len := FCtrlSocket.Receive(@FReceiveBuffer[FReceiveLen], I);

    if FRequestType = httpAbort then
        Exit;

    if Len <= 0 then
        Exit;

    FReceiveBuffer[FReceiveLen + Len] := #0;
    FReceiveLen := FReceiveLen + Len;

    if FState = httpWaitingBody then begin
        if FReceiveLen > 0 then begin
            SetLength(FLastResponse, FReceiveLen);
            Move(FReceiveBuffer, FLastResponse[1], FReceiveLen);
            if Assigned(FNext) then
                FNext
            else
                SetReady; {StateChange(httpReady);}
        end;
        FReceiveLen := 0;
        Exit;
    end;

    while FReceiveLen > 0 do begin
        I := Pos(#10, FReceiveBuffer);
        if I <= 0 then
            break;
        if I > FReceiveLen then
            break;

        if (I > 1) and (FReceiveBuffer[I-2] = #13) then
            FLastResponse := Copy(FReceiveBuffer, 1, I - 2)
        else
            FLastResponse := Copy(FReceiveBuffer, 1, I - 1);

{$IFDEF DUMP}
        FDumpBuf := '>|';
        FDumpStream.WriteBuffer(FDumpBuf[1], Length(FDumpBuf));
        FDumpStream.WriteBuffer(FLastResponse[1], Length(FLastResponse));
        FDumpBuf := '|' + #13#10;
        FDumpStream.WriteBuffer(FDumpBuf[1], Length(FDumpBuf));
{$ENDIF}
{$IFDEF VER80}
        { Add a nul byte at the end of string for Delphi 1 }
        FLastResponse[Length(FLastResponse) + 1] := #0;
{$ENDIF}
        FReceiveLen := FReceiveLen - I;
        if FReceiveLen > 0 then
            Move(FReceiveBuffer[I], FReceiveBuffer[0], FReceiveLen + 1);

        if FState in [httpWaitingHeader, httpWaitingBody] then begin
            if Assigned(FNext) then
                FNext
            else
                SetReady; {StateChange(httpReady);}
        end
        else begin
            if Assigned(FOnDataAvailable) then
                FOnDataAvailable(@Self, Error);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketDataSent(ASender : PObj; Error : Word);
var
    Len : Integer;
begin
    if not FAllowedToSend then
        Exit;

    Len := FSendStream.Read(FSendBuffer, sizeof(FSendBuffer));
    if Len <= 0 then begin
        FAllowedToSend := FALSE;
        TriggerSendEnd;
        Exit;
    end;

    if Len > 0 then begin
        FSentCount := FSentCount + Len;
        TriggerSendData(@FSendBuffer, Len);
        FCtrlSocket.Send(@FSendBuffer, Len);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Get process and wait until terminated (blocking)      }
procedure THttpCli.Get;
begin
    DoRequestSync(httpGet);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Head process and wait until terminated (blocking)     }
procedure THttpCli.Head;
begin
    DoRequestSync(httpHEAD);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Post process and wait until terminated (blocking)     }
procedure THttpCli.Post;
begin
    DoRequestSync(httpPOST);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the get process and returns immediately (non blocking)    }
procedure THttpCli.GetAsync;
begin
    DoRequestASync(httpGet);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the head process and returns immediately (non blocking)   }
procedure THttpCli.HeadAsync;
begin
    DoRequestASync(httpHEAD);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the post process and returns immediately (non blocking)   }
procedure THttpCli.PostAsync;
begin
    DoRequestASync(httpPOST);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetBaseUrl(const Url : String) : String;
var
    I : Integer;
begin
    I := 1;
    while (I <= Length(Url)) and (Url[I] <> '?') do
        Inc(I);
    Dec(I);
    while (I > 0) and (not (Url[I] in ['/', ':'])) do
        Dec(I);
    Result := Copy(Url, 1, I);
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Added by Eugene Mayevski }
procedure THttpCli.SetSocksServer(value : String);
begin
    FCtrlSocket.SocksServer := value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetSocksLevel(value : String);
begin
    FCtrlSocket.SocksLevel := value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetSocksPort(value : String);
begin
    FCtrlSocket.SocksPort := value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetSocksUsercode(value : String);
begin
    FCtrlSocket.SocksUsercode := value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetSocksPassword(value : String);
begin
    FCtrlSocket.SocksPassword := value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetSocksAuthentication(value : TSocksAuthentication);
begin
    FCtrlSocket.SocksAuthentication := value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetSocksServer : String;
begin
    result := FCtrlSocket.SocksServer;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetSocksLevel : String;
begin
    result := FCtrlSocket.SocksLevel;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetSocksPort : String;
begin
    result := FCtrlSocket.SocksPort;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetSocksUsercode : String;
begin
    result := FCtrlSocket.SocksUsercode;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetSocksPassword : String;
begin
    result := FCtrlSocket.SocksPassword;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetSocksAuthentication : TSocksAuthentication;
begin
    result := FCtrlSocket.SocksAuthentication;
end;
{ Mayevski additions end }


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Syntax of an URL: protocol://[user[:password]@]server[:port]/path         }
procedure ParseURL(
    const url : String;
    var Proto, User, Pass, Host, Port, Path : String);
var
    p, q, i : Integer;
    s       : String;
    CurPath : String;
begin
    CurPath := Path;
    proto   := '';
    User    := '';
    Pass    := '';
    Host    := '';
    Port    := '';
    Path    := '';

    if Length(url) < 1 then
        Exit;

    { Handle path beginning with "./" or "../".          }
    { This code handle only simple cases !               }
    { Handle path relative to current document directory }
    if (Copy(url, 1, 2) = './') then begin
        p := Posn('/', CurPath, -1);
        if p > Length(CurPath) then
            p := 0;
        if p = 0 then
            CurPath := '/'
        else
            CurPath := Copy(CurPath, 1, p);
        Path := CurPath + Copy(url, 3, Length(url));
        Exit;
    end
    { Handle path relative to current document parent directory }
    else if (Copy(url, 1, 3) = '../') then begin
        p := Posn('/', CurPath, -1);
        if p > Length(CurPath) then
            p := 0;
        if p = 0 then
            CurPath := '/'
        else
            CurPath := Copy(CurPath, 1, p);

        s := Copy(url, 4, Length(url));
        { We could have several levels }
        while TRUE do begin
            CurPath := Copy(CurPath, 1, p-1);
            p := Posn('/', CurPath, -1);
            if p > Length(CurPath) then
                p := 0;
            if p = 0 then
                CurPath := '/'
            else
                CurPath := Copy(CurPath, 1, p);
            if (Copy(s, 1, 3) <> '../') then
                break;
            s := Copy(s, 4, Length(s));
        end;

        Path := CurPath + Copy(s, 1, Length(s));
        Exit;
    end;

    p := pos('://', url);
    q := p;
    if p <> 0 then begin
        S := Copy(url, 1, p - 1);
        for i := 1 to Length(S) do begin
            if not (S[i] in UriProtocolSchemeAllowedChars) then begin
                q := i;
                Break;
            end;
        end;
        if q < p then begin
            p     := 0;
            proto := 'http';
        end;
    end;
    if p = 0 then begin
        if (url[1] = '/') then begin
            { Relative path without protocol specified }
            proto := 'http';
            p     := 1;
            if (Length(url) > 1) and (url[2] <> '/') then begin
                { Relative path }
                Path := Copy(url, 1, Length(url));
                Exit;
            end;
        end
        else if lowercase(Copy(url, 1, 5)) = 'http:' then begin
            proto := 'http';
            p     := 6;
            if (Length(url) > 6) and (url[7] <> '/') then begin
                { Relative path }
                Path := Copy(url, 6, Length(url));
                Exit;
            end;
        end
        else if lowercase(Copy(url, 1, 7)) = 'mailto:' then begin
            proto := 'mailto';
            p := pos(':', url);
        end;
    end
    else begin
        proto := Copy(url, 1, p - 1);
        inc(p, 2);
    end;
    s := Copy(url, p + 1, Length(url));

    p := pos('/', s);
    q := pos('?', s);
    if (q > 0) and ((q < p) or (p = 0)) then
        p := q;
    if p = 0 then
        p := Length(s) + 1;
    Path := Copy(s, p, Length(s));
    s    := Copy(s, 1, p-1);

    p := Posn(':', s, -1);
    if p > Length(s) then
        p := 0;
    q := Posn('@', s, -1);
    if q > Length(s) then
        q := 0;
    if (p = 0) and (q = 0) then begin   { no user, password or port }
        Host := s;
        Exit;
    end
    else if q < p then begin  { a port given }
        Port := Copy(s, p + 1, Length(s));
        Host := Copy(s, q + 1, p - q - 1);
        if q = 0 then
            Exit; { no user, password }
        s := Copy(s, 1, q - 1);
    end
    else begin
        Host := Copy(s, q + 1, Length(s));
        s := Copy(s, 1, q - 1);
    end;
    p := pos(':', s);
    if p = 0 then
        User := s
    else begin
        User := Copy(s, 1, p - 1);
        Pass := Copy(s, p + 1, Length(s));
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function EncodeStr(Encoding : THttpEncoding; const Value : String) : String;
begin
    Result := EncodeLine(Encoding, @Value[1], Length(Value));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function EncodeLine(
    Encoding : THttpEncoding;
    SrcData  : PChar;
    Size     : Integer) : String;
var
    Offset : Integer;
    Pos1   : Integer;
    Pos2   : Integer;
    I      : Integer;
begin
    SetLength(Result, Size * 4 div 3 + 4);
    FillChar(Result[1], Size * 4 div 3 + 2, #0);

    if Encoding = encUUEncode then begin
        Result[1] := Char(((Size - 1) and $3f) + $21);
        Size      := ((Size + 2) div 3) * 3;
    end;
    Offset := 2;
    Pos1   := 0;
    Pos2   := 0;
    case Encoding of
        encUUEncode:        Pos2 := 2;
        encBase64, encMime: Pos2 := 1;
    end;
    Result[Pos2] := #0;

    while Pos1 < Size do begin
        if Offset > 0 then begin
            Result[Pos2] := Char(ord(Result[Pos2]) or
                                 ((ord(SrcData[Pos1]) and
                                  ($3f shl Offset)) shr Offset));
            Offset := Offset - 6;
            Inc(Pos2);
            Result[Pos2] := #0;
        end
        else if Offset < 0 then begin
            Offset := Abs(Offset);
            Result[Pos2] := Char(ord(Result[Pos2]) or
                                 ((ord(SrcData[Pos1]) and
                                  ($3f shr Offset)) shl Offset));
            Offset := 8 - Offset;
            Inc(Pos1);
        end
        else begin
            Result[Pos2] := Char(ord(Result[Pos2]) or
                                 ((ord(SrcData[Pos1]) and $3f)));
            Inc(Pos2);
            Inc(Pos1);
            Result[Pos2] := #0;
            Offset    := 2;
        end;
    end;

    case Encoding of
    encUUEncode:
        begin
            if Offset = 2 then
                Dec(Pos2);
            for i := 2 to Pos2 do
                Result[i] := bin2uue[ord(Result[i])+1];
        end;
    encBase64, encMime:
        begin
            if Offset = 2 then
                Dec(Pos2);
            for i := 1 to Pos2 do
                Result[i] := bin2b64[ord(Result[i])+1];
            while (Pos2 and 3) <> 0  do begin
                Inc(Pos2);
                Result[Pos2] := '=';
            end;
        end;
    end;
    SetLength(Result, Pos2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Find the count'th occurence of the s string in the t string.              }
{ If count < 0 then look from the back                                      }
function Posn(const s , t : String; Count : Integer) : Integer;
var
    i, h, Last : Integer;
    u          : String;
begin
    u := t;
    if Count > 0 then begin
        Result := Length(t);
        for i := 1 to Count do begin
            h := Pos(s, u);
            if h > 0 then
                u := Copy(u, h + 1, Length(u))
            else begin
                u := '';
                Inc(Result);
            end;
        end;
        Result := Result - Length(u);
    end
    else if Count < 0 then begin
        Last := 0;
        for i := Length(t) downto 1 do begin
            u := Copy(t, i, Length(t));
            h := Pos(s, u);
            if (h <> 0) and ((h + i) <> Last) then begin
                Last := h + i - 1;
                Inc(count);
                if Count = 0 then
                    break;
            end;
        end;
        if Count = 0 then
            Result := Last
        else
            Result := 0;
    end
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsDigit(Ch : Char) : Boolean;
begin
    Result := (ch in ['0'..'9']);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsXDigit(Ch : char) : Boolean;
begin
    Result := (ch in ['0'..'9']) or (ch in ['a'..'f']) or (ch in ['A'..'F']);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function XDigit(Ch : char) : Integer;
begin
    if ch in ['0'..'9'] then
        Result := ord(Ch) - ord('0')
    else
        Result := (ord(Ch) and 15) + 9;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htoin(value : PChar; len : Integer) : Integer;
var
    i : Integer;
begin
    Result := 0;
    i      := 0;
    while (i < len) and (Value[i] = ' ') do
        i := i + 1;
    while (i < len) and (isxDigit(Value[i])) do begin
        Result := Result * 16 + xdigit(Value[i]);
        i := i + 1;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htoi2(value : PChar) : Integer;
begin
    Result := htoin(value, 2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function UrlEncode(S : String) : String;
var
    I : Integer;
begin
    Result := '';
    for I := 1 to Length(S) do begin
        if S[I] in ['0'..'9', 'A'..'Z', 'a'..'z'] then
            Result := Result + S[I]
        else
            Result := Result + '%' + IntToHex(Ord(S[I]), 2);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function UrlDecode(S : String) : String;
var
    I  : Integer;
    Ch : Char;
begin
    Result := '';
    I := 1;
    while (I <= Length(S)) and (S[I] <> '&') do begin
        Ch := S[I];
        if Ch = '%' then begin
            Ch := chr(htoi2(@S[I + 1]));
            Inc(I, 2);
        end
        else if Ch = '+' then
            Ch := ' ';
        Result := Result + Ch;
        Inc(I);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.

