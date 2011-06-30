unit KOLPing;

{$IFDEF VER80}
// This source file is *NOT* compatible with Delphi 1 because it uses
// Win 32 features.
{$ENDIF}

interface

uses KOL,
  Windows, Messages, err,KOLSysUtils { , Classes } , Winsock, KOLIcmp;

const
  PingVersion           = 111;
  CopyRight : String    = ' TPing (c) 1997-2000 F. Piette V1.11 ';
  WM_ASYNCGETHOSTBYNAME = WM_USER + 2;

type
  TDnsLookupDone = procedure (Sender: PObj; Error: Word) of object;
  TPingDisplay   = procedure(Sender: PObj; Icmp: PObj; Msg : String) of object;
  TPingReply     = procedure(Sender: PObj; Icmp: PObj; Status : Integer) of object;
  TPingRequest   = procedure(Sender: PObj; Icmp: PObj) of object;
  TPing = object(TObj)
  private
    FIcmp             : PICMP;
    FWindowHandle     : HWND;
    FDnsLookupBuffer  : array [0..MAXGETHOSTSTRUCT] of char;
    FDnsLookupHandle  : THandle;
    FDnsResult        : String;
    FOnDnsLookupDone  : TDnsLookupDone;
    FOnEchoRequest    : TPingRequest;
    FOnEchoReply      : TPingReply;
    FOnDisplay        : TPingDisplay;
  protected
    procedure   WndProc(var MsgRec: TMessage);
    procedure   WMAsyncGetHostByName(var msg: TMessage);// message WM_ASYNCGETHOSTBYNAME;
    procedure   SetAddress(Value : String);
    function    GetAddress : String;
    procedure   SetSize(Value : Integer);
    function    GetSize : Integer;
    procedure   SetTimeout(Value : Integer);
    function    GetTimeout : Integer;
    function    GetReply : TIcmpEchoReply;
    function    GetErrorCode : Integer;
    function    GetErrorString : String;
    function    GetHostName : String;
    function    GetHostIP : String;
    procedure   SetTTL(Value : Integer);
    function    GetTTL : Integer;
    procedure   Setflags(Value : Integer);
    function    Getflags : Integer;
//    procedure   SetOnDisplay(Value : TICMPDisplay);
//    function    GetOnDisplay : TICMPDisplay;
//    procedure   SetOnEchoRequest(Value : TNotifyEvent);
//    function    GetOnEchoRequest : TNotifyEvent;
//    procedure   SetOnEchoReply(Value : TICMPReply);
//    function    GetOnEchoReply : TICMPReply;
    procedure   IcmpEchoReply(Sender: PObj; Error : Integer);
    procedure   IcmpEchoRequest(Sender: PObj);
    procedure   IcmpDisplay(Sender: PObj; Msg: String);
  public
     { constructor Create(Owner : TComponent); override;
     } destructor  Destroy; 
     virtual; function    Ping : Integer;
    procedure   DnsLookup(AHostName : String); virtual;
    procedure   CancelDnsLookup;

    property    Reply       : TIcmpEchoReply read GetReply;
    property    ErrorCode   : Integer        read GetErrorCode;
    property    ErrorString : String         read GetErrorString;
    property    HostName    : String         read GetHostName;
    property    HostIP      : String         read GetHostIP;
    property    Handle      : HWND           read FWindowHandle;
    property    DnsResult   : String         read FDnsResult;
   { published } 
    property    Address     : String         read  GetAddress
                                             write SetAddress;
    property    Size        : Integer        read  GetSize
                                             write SetSize;
    property    Timeout     : Integer        read  GetTimeout
                                             write SetTimeout;
    property    TTL         : Integer        read  GetTTL
                                             write SetTTL;
    property    Flags       : Integer        read  Getflags
                                             write SetFlags;
    property    OnDisplay   : TPingDisplay   read  FOnDisplay
                                             write FOnDisplay;
    property    OnEchoRequest : TPingRequest read  FOnEchoRequest
                                             write FOnEchoRequest;
    property    OnEchoReply   : TPingReply   read  FOnEchoReply
                                             write FOnEchoReply;
    property    OnDnsLookupDone : TDnsLookupDone
                                             read  FOnDnsLookupDone
                                             write FOnDnsLookupDone;
  end;
PPing=^TPing;
function NewPing(Owner : PObj):PPing;
type  MyStupid0=DWord;

//procedure Register;

implementation


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
//procedure Register;
//begin
//    RegisterComponents('fpiette', [TPing]);
//end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This function is a callback function. It means that it is called by       }
{ windows. This is the very low level message handler procedure setup to    }
{ handle the message sent by windows (winsock) to handle messages.          }
function XSocketWindowProc(
    ahWnd   : HWND;
    auMsg   : Integer;
    awParam : WPARAM;
    alParam : LPARAM): Integer; stdcall;
var
    Obj    : PPing;
    MsgRec : TMessage;
begin
    { At window creation ask windows to store a pointer to our object       }
    Obj := PPing(GetWindowLong(ahWnd, 0));

    { If the pointer is not assigned, just call the default procedure       }
    if not Assigned(Obj) then
        Result := DefWindowProc(ahWnd, auMsg, awParam, alParam)
    else begin
        { Delphi use a TMessage type to pass paramter to his own kind of    }
        { windows procedure. So we are doing the same...                    }
        MsgRec.Msg    := auMsg;
        MsgRec.wParam := awParam;
        MsgRec.lParam := alParam;
        Obj.WndProc(MsgRec);
        Result := MsgRec.Result;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This global variable is used to store the windows class characteristic    }
{ and is needed to register the window class used by TWSocket               }
var
    XSocketWindowClass: TWndClass = (
        style         : 0;
        lpfnWndProc   : @XSocketWindowProc;
        cbClsExtra    : 0;
        cbWndExtra    : SizeOf(Pointer);
        hInstance     : 0;
        hIcon         : 0;
        hCursor       : 0;
        hbrBackground : 0;
        lpszMenuName  : nil;
        lpszClassName : 'ICSPingWindowClass');


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Allocate a window handle. This means registering a window class the first }
{ time we are called, and creating a new window each time we are called.    }
function XSocketAllocateHWnd(Obj : PObj): HWND;
var
    TempClass       : TWndClass;
    ClassRegistered : Boolean;
begin
    { Check if the window class is already registered                       }
    XSocketWindowClass.hInstance := HInstance;
    ClassRegistered := GetClassInfo(HInstance,
                                    XSocketWindowClass.lpszClassName,
                                    TempClass);
    if not ClassRegistered then begin
       { Not yet registered, do it right now                                }
       Result := Windows.RegisterClass(XSocketWindowClass);
       if Result = 0 then
           Exit;
    end;

    { Now create a new window                                               }
    Result := CreateWindowEx(WS_EX_TOOLWINDOW,
                           XSocketWindowClass.lpszClassName,
                           '',        { Window name   }
                           WS_POPUP,  { Window Style  }
                           0, 0,      { X, Y          }
                           0, 0,      { Width, Height }
                           0,         { hWndParent    }
                           0,         { hMenu         }
                           HInstance, { hInstance     }
                           nil);      { CreateParam   }

    { if successfull, the ask windows to store the object reference         }
    { into the reserved byte (see RegisterClass)                            }
    if (Result <> 0) and Assigned(Obj) then
        SetWindowLong(Result, 0, Integer(Obj));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Free the window handle                                                    }
procedure XSocketDeallocateHWnd(Wnd: HWND);
begin
    DestroyWindow(Wnd);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.WndProc(var MsgRec: TMessage);
begin
     with MsgRec do begin
         if Msg = WM_ASYNCGETHOSTBYNAME then
             WMAsyncGetHostByName(MsgRec)
         else
             Result := DefWindowProc(Handle, Msg, wParam, lParam);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.WMAsyncGetHostByName(var msg: TMessage);
var
    Phe     : Phostent;
    IPAddr  : TInAddr;
    Error   : Word;
begin
    if msg.wParam <> LongInt(FDnsLookupHandle) then
        Exit;
    FDnsLookupHandle := 0;
    Error := Msg.LParamHi;
    if Error = 0 then begin
        Phe        := PHostent(@FDnsLookupBuffer);
        IPAddr     := PInAddr(Phe^.h_addr_list^)^;
        FDnsResult := StrPas(inet_ntoa(IPAddr));
    end;
    if Assigned(FOnDnsLookupDone) then
        FOnDnsLookupDone(@Self, Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
//constructor TPing.Create(Owner : TComponent);
function NewPing(Owner : PObj):PPing;
begin
  New( Result, Create );
//    Inherited Create(Owner);
  with Result^ do
  begin
    FIcmp               := NewICMP;//TICMP.Create;
    FIcmp.OnDisplay     := IcmpDisplay;
    FIcmp.OnEchoRequest := IcmpEchoRequest;
    FIcmp.OnEchoReply   := IcmpEchoReply;
    { Delphi 32 bits has threads and VCL is not thread safe.                }
    { We need to do our own way to be thread safe.                          }
    FWindowHandle := XSocketAllocateHWnd(Result);
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TPing.Destroy;
begin
    CancelDnsLookup;                 { Cancel any pending dns lookup      }
    XSocketDeallocateHWnd(FWindowHandle);
    if Assigned(FIcmp) then begin
        FIcmp.Destroy;
        FIcmp := nil;
    end;
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.IcmpDisplay(Sender: PObj; Msg: String);
begin
    if Assigned(FOnDisplay) then
        FOnDisplay(@Self, Sender, Msg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.IcmpEchoReply(Sender: PObj; Error : Integer);
begin
    if Assigned(FOnEchoReply) then
        FOnEchoReply(@Self, Sender, Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.IcmpEchoRequest(Sender: PObj);
begin
    if Assigned(FOnEchoRequest) then
        FOnEchoRequest(@Self, Sender);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.Ping : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.Ping
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.CancelDnsLookup;
begin
    if FDnsLookupHandle = 0 then
        Exit;
    if WSACancelAsyncRequest(FDnsLookupHandle) <> 0 then
;//        raise Exception.CreateFmt('WSACancelAsyncRequest failed, error #%d',
//                               [WSAGetLastError]);
    FDnsLookupHandle := 0;
    if Assigned(FOnDnsLookupDone) then
        FOnDnsLookupDone(@Self, WSAEINTR);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.DnsLookup(AHostName : String);
var
    IPAddr  : TInAddr;
    tmp:array [0..10] of char;
begin
  tmp:='localhost';
    { Cancel any pending lookup }
    if FDnsLookupHandle <> 0 then
        WSACancelAsyncRequest(FDnsLookupHandle);

    FDnsResult := '';

    IPAddr.S_addr := Inet_addr(@AHostName[1]);
    if IPAddr.S_addr <> u_long(INADDR_NONE) then begin
        FDnsResult := StrPas(inet_ntoa(IPAddr));
        if Assigned(FOnDnsLookupDone) then
            FOnDnsLookupDone(@Self, 0);
        Exit;
    end;

    FDnsLookupHandle := WSAAsyncGetHostByName(FWindowHandle,
                                              WM_ASYNCGETHOSTBYNAME,
                                              @AHostName[1],
                                              @FDnsLookupBuffer,
                                              SizeOf(FDnsLookupBuffer));
    if FDnsLookupHandle = 0 then
;//        raise Exception.CreateFmt(
//                  '%s: can''t start DNS lookup, error #%d',
//                  [HostName, WSAGetLastError]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.SetAddress(Value : String);
begin
    if Assigned(FIcmp) then
        FIcmp.Address := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetAddress : String;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.Address
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.SetSize(Value : Integer);
begin
    if Assigned(FIcmp) then
        FIcmp.Size := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetSize : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.Size
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.SetTimeout(Value : Integer);
begin
    if Assigned(FIcmp) then
        FIcmp.Timeout := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetTimeout : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.Timeout
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.SetTTL(Value : Integer);
begin
    if Assigned(FIcmp) then
        FIcmp.TTL := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetTTL : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.TTL
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPing.SetFlags(Value : Integer);
begin
    if Assigned(FIcmp) then
        FIcmp.Flags := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetFlags : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.flags
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetReply : TIcmpEchoReply;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.Reply
    else
        FillChar(Result, SizeOf(Result), 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetErrorCode : Integer;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.ErrorCode
    else
        Result := -1;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetErrorString : String;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.ErrorString
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetHostName : String;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.HostName
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPing.GetHostIP : String;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.HostIP
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{procedure TPing.SetOnDisplay(Value : TICMPDisplay);
begin
    if Assigned(FIcmp) then
        FIcmp.OnDisplay := Value;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{function TPing.GetOnDisplay : TICMPDisplay;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.OnDisplay
    else
        Result := nil;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{procedure TPing.SetOnEchoRequest(Value : TNotifyEvent);
begin
    if Assigned(FIcmp) then
        FIcmp.OnEchoRequest := Value;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{function TPing.GetOnEchoRequest : TNotifyEvent;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.OnEchoRequest
    else
        Result := nil;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{procedure TPing.SetOnEchoReply(Value : TICMPReply);
begin
    if Assigned(FIcmp) then
        FIcmp.OnEchoReply := Value;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{function TPing.GetOnEchoReply : TICMPReply;
begin
    if Assigned(FIcmp) then
        Result := FIcmp.OnEchoReply
    else
        Result := nil;
end;
}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.

