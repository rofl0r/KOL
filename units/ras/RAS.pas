{* Copyright (c) 1992-1996, Microsoft Corporation, all rights reserved
**
** ras.h
** Remote Access external API
** Public header for external API clients
**
*}

{ Note: All functions and structures defaults to Ansi. If you want to use
  Unicode structs and funcs, use the names ending with 'W'
  you must define one of these for specific features: }

{.$DEFINE WINVER31}   // for Windows NT 3.5, Windows NT 3.51
{nothing}             // for Windows 95, Windows NT SUR (default)
{.$DEFINE WINVER41}   // for Windows NT SUR enhancements

unit Ras;

interface

uses Windows, KOL;

const

{ These are from lmcons.h }

  DNLEN = 15;  // Maximum domain name length
  UNLEN = 256; // Maximum user name length
  PWLEN = 256; // Maximum password length
  NETBIOS_NAME_LEN = 16; // NetBIOS net name (bytes)

  RAS_MaxDeviceType  = 16;
  RAS_MaxPhoneNumber = 128;
  RAS_MaxIpAddress   = 15;
  RAS_MaxIpxAddress  = 21;

{$IFDEF WINVER31}
{Version 3.x sizes }
  RAS_MaxEntryName      = 20;
  RAS_MaxDeviceName     = 32;
  RAS_MaxCallbackNumber = 48;
{$ELSE}
{Version 4.x sizes }
  RAS_MaxEntryName      = 256;
  RAS_MaxDeviceName     = 128;
  RAS_MaxCallbackNumber = RAS_MaxPhoneNumber;
{$ENDIF}

  RAS_MaxAreaCode       = 10;
  RAS_MaxPadType        = 32;
  RAS_MaxX25Address     = 200;
  RAS_MaxFacilities     = 200;
  RAS_MaxUserData       = 200;

type

  LPHRasConn = ^THRasConn;
  THRasConn = Longint;


{* Identifies an active RAS connection.  (See RasEnumConnections)
*}
  LPRasConnW = ^TRasConnW;
  TRasConnW = record
    dwSize: Longint;
    hrasconn: THRasConn;
    szEntryName: Array[0..RAS_MaxEntryName] of WideChar;
{$IFNDEF WINVER31}
    szDeviceType: Array[0..RAS_MaxDeviceType] of WideChar;
    szDeviceName: Array[0..RAS_MaxDeviceName] of WideChar;
{$ENDIF}
{$IFDEF WINVER41}
    szPhonebook: Array[0..MAX_PATH - 1] of WideChar;
    dwSubEntry: Longint;
{$ENDIF}
  end;

  LPRasConnA = ^TRasConnA;
  TRasConnA = record
    dwSize: Longint;
    hrasconn: THRasConn;
    szEntryName: Array[0..RAS_MaxEntryName] of AnsiChar;
{$IFNDEF WINVER31}
   szDeviceType: Array[0..RAS_MaxDeviceType] of AnsiChar;
   szDeviceName: Array[0..RAS_MaxDeviceName] of AnsiChar;
{$ENDIF}
{$IFDEF WINVER41}
    szPhonebook: Array[0..MAX_PATH - 1] of AnsiChar;
    dwSubEntry: Longint;
{$ENDIF}
  end;

  LPRasConn = ^TRasConn;
  TRasConn = TRasConnA;


const

{* Enumerates intermediate states to a connection.  (See RasDial)
*}
  RASCS_PAUSED = $1000;
  RASCS_DONE   = $2000;

type

  LPRasConnState = ^TRasConnState;
  TRasConnState = Integer;

const

  RASCS_OpenPort = 0;
  RASCS_PortOpened = 1;
  RASCS_ConnectDevice = 2;
  RASCS_DeviceConnected = 3;
  RASCS_AllDevicesConnected = 4;
  RASCS_Authenticate = 5;
  RASCS_AuthNotify = 6;
  RASCS_AuthRetry = 7;
  RASCS_AuthCallback = 8;
  RASCS_AuthChangePassword = 9;
  RASCS_AuthProject = 10;
  RASCS_AuthLinkSpeed = 11;
  RASCS_AuthAck = 12;
  RASCS_ReAuthenticate = 13;
  RASCS_Authenticated = 14;
  RASCS_PrepareForCallback = 15;
  RASCS_WaitForModemReset = 16;
  RASCS_WaitForCallback = 17;
  RASCS_Projected = 18;
{$IFNDEF WINVER31}
  RASCS_StartAuthentication = 19;
  RASCS_CallbackComplete = 20;
  RASCS_LogonNetwork = 21;
{$ENDIF}

  RASCS_Interactive = RASCS_PAUSED;
  RASCS_RetryAuthentication = RASCS_PAUSED + 1;
  RASCS_CallbackSetByCaller = RASCS_PAUSED + 2;
  RASCS_PasswordExpired = RASCS_PAUSED + 3;

  RASCS_Connected = RASCS_DONE;
  RASCS_Disconnected = RASCS_DONE + 1;

type

{* Describes the status of a RAS connection.  (See RasConnectionStatus)
*}
  LPRasConnStatusW = ^TRasConnStatusW;
  TRasConnStatusW = record
    dwSize: Longint;
    rasconnstate: TRasConnState;
    dwError: LongInt;
    szDeviceType: Array[0..RAS_MaxDeviceType] of WideChar;
    szDeviceName: Array[0..RAS_MaxDeviceName] of WideChar;
{$IFDEF WINVER41}
    swPhoneNumber: Array[0..RAS_MaxPhoneNumber] of WideChar;
{$ENDIF}
  end;

  LPRasConnStatusA = ^TRasConnStatusA;
  TRasConnStatusA = record
    dwSize: Longint;
    rasconnstate: TRasConnState;
    dwError: LongInt;
    szDeviceType: Array[0..RAS_MaxDeviceType] of AnsiChar;
    szDeviceName: Array[0..RAS_MaxDeviceName] of AnsiChar;
{$IFDEF WINVER41}
    swPhoneNumber: Array[0..RAS_MaxPhoneNumber] of AnsiChar;
{$ENDIF}
  end;

  LPRasConnStatus = ^TRasConnStatus;
  TRasConnStatus = TRasConnStatusA;

{* Describes connection establishment parameters.  (See RasDial)
*}
  LPRasDialParamsW = ^TRasDialParamsW;
  TRasDialParamsW = record
    dwSize: LongInt;
    szEntryName: Array[0..RAS_MaxEntryName] of WideChar;
    szPhoneNumber: Array[0..RAS_MaxPhoneNumber] of WideChar;
    szCallbackNumber: Array[0..RAS_MaxCallbackNumber] of WideChar;
    szUserName: Array[0..UNLEN] of WideChar;
    szPassword: Array[0..PWLEN] of WideChar;
    szDomain: Array[0..DNLEN] of WideChar;
{$IFDEF WINVER41}
    dwSubEntry: Longint;
    dwCallbackId: Longint;
{$ENDIF}
  end;

  LPRasDialParamsA = ^TRasDialParamsA;
  TRasDialParamsA = record
    dwSize: LongInt;
    szEntryName: Array[0..RAS_MaxEntryName] of AnsiChar;
    szPhoneNumber: Array[0..RAS_MaxPhoneNumber] of AnsiChar;
    szCallbackNumber: Array[0..RAS_MaxCallbackNumber] of AnsiChar;
    szUserName: Array[0..UNLEN] of AnsiChar;
    szPassword: Array[0..PWLEN] of AnsiChar;
    szDomain: Array[0..DNLEN] of AnsiChar;
{$IFDEF WINVER41}
    dwSubEntry: Longint;
    dwCallbackId: Longint;
{$ENDIF}
  end;

  LPRasDialParams = ^TRasDialParams;
  TRasDialParams = TRasDialParamsA;


{* Describes extended connection establishment options.  (See RasDial)
*}
  LPRasDialExtensions = ^TRasDialExtensions;
  TRasDialExtensions = record
    dwSize: LongInt;
    dwfOptions: LongInt;
    hwndParent: HWND;
    reserved: LongInt;
  end;

const

{* 'dwfOptions' bit flags.
*}
  RDEOPT_UsePrefixSuffix           = $00000001;
  RDEOPT_PausedStates              = $00000002;
  RDEOPT_IgnoreModemSpeaker        = $00000004;
  RDEOPT_SetModemSpeaker           = $00000008;
  RDEOPT_IgnoreSoftwareCompression = $00000010;
  RDEOPT_SetSoftwareCompression    = $00000020;
  RDEOPT_DisableConnectedUI        = $00000040;
  RDEOPT_DisableReconnectUI        = $00000080;
  RDEOPT_DisableReconnect          = $00000100;
  RDEOPT_NoUser                    = $00000200;
  RDEOPT_PauseOnScript             = $00000400;


type

{* Describes an enumerated RAS phone book entry name.  (See RasEntryEnum)
*}
  LPRasEntryNameW = ^TRasEntryNameW;
  TRasEntryNameW = record
    dwSize: Longint;
    szEntryName: Array[0..RAS_MaxEntryName] of WideChar;
  end;

  LPRasEntryNameA = ^TRasEntryNameA;
  TRasEntryNameA = record
    dwSize: Longint;
    szEntryName: Array[0..RAS_MaxEntryName] of AnsiChar;
  end;

  LPRasEntryName = ^TRasEntryName;
  TRasEntryName = TRasEntryNameA;


{* Protocol code to projection data structure mapping.
*}
  LPRasProjection = ^TRasProjection;
  TRasProjection = Integer;

const

  RASP_Amb = $10000;
  RASP_PppNbf = $803F;
  RASP_PppIpx = $802B;
  RASP_PppIp = $8021;
  RASP_PppLcp = $C021;
  RASP_Slip = $20000;


type

{* Describes the result of a RAS AMB (Authentication Message Block)
** projection.  This protocol is used with NT 3.1 and OS/2 1.3 downlevel
** RAS servers.
*}
  LPRasAmbW = ^TRasAmbW;
  TRasAmbW = record
    dwSize: Longint;
    dwError: Longint;
    szNetBiosError: Array[0..NETBIOS_NAME_LEN] of WideChar;
    bLana: Byte;
  end;

  LPRasAmbA = ^TRasAmbA;
  TRasAmbA = record
    dwSize: Longint;
    dwError: Longint;
    szNetBiosError: Array[0..NETBIOS_NAME_LEN] of AnsiChar;
    bLana: Byte;
  end;

  LPRasAmb = ^TRasAmb;
  TRasAmb = TRasAmbA;


{* Describes the result of a PPP NBF (NetBEUI) projection.
*}
  LPRasPppNbfW = ^TRasPppNbfW;
  TRasPppNbfW = record
    dwSize: Longint;
    dwError: Longint;
    dwNetBiosError: Longint;
    szNetBiosError: Array[0..NETBIOS_NAME_LEN] of WideChar;
    szWorkstationName: Array[0..NETBIOS_NAME_LEN] of WideChar;
    bLana: Byte;
  end;

  LPRasPppNbfA = ^TRasPppNbfA;
  TRasPppNbfA = record
    dwSize: Longint;
    dwError: Longint;
    dwNetBiosError: Longint;
    szNetBiosError: Array[0..NETBIOS_NAME_LEN] of AnsiChar;
    szWorkstationName: Array[0..NETBIOS_NAME_LEN] of AnsiChar;
    bLana: Byte;
  end;

  LpRaspppNbf = ^TRasPppNbf;
  TRasPppNbf = TRasPppNbfA;


{* Describes the results of a PPP IPX (Internetwork Packet Exchange)
** projection.
*}
  LPRasPppIpxW = ^TRasPppIpxW;
  TRasPppIpxW = record
    dwSize: Longint;
    dwError: Longint;
    szIpxAddress: Array[0..RAS_MaxIpxAddress] of WideChar;
  end;

  LPRasPppIpxA = ^TRasPppIpxA;
  TRasPppIpxA = record
    dwSize: Longint;
    dwError: Longint;
    szIpxAddress: Array[0..RAS_MaxIpxAddress] of AnsiChar;
  end;

  LPRasPppIpx = ^TRasPppIpx;
  TRasPppIpx = TRasPppIpxA;


{* Describes the results of a PPP IP (Internet) projection.
*}
  LPRasPppIpW = ^TRasPppIpW;
  TRasPppIpW = record
    dwSize: Longint;
    dwError: Longint;
    szIpAddress: Array[0..RAS_MaxIpAddress] of WideChar;

{$IFNDEF WINNT35COMPATIBLE}

    {* This field was added between Windows NT 3.51 beta and Windows NT 3.51
    ** final, and between Windows 95 M8 beta and Windows 95 final.  If you do
    ** not require the server address and wish to retrieve PPP IP information
    ** from Windows NT 3.5 or early Windows NT 3.51 betas, or on early Windows
    ** 95 betas, define WINNT35COMPATIBLE.
    **
    ** The server IP address is not provided by all PPP implementations,
    ** though Windows NT server's do provide it.
    *}
    szServerIpAddress: Array[0..RAS_MaxIpAddress] of WideChar;

{$ENDIF}
  end;

  LPRasPppIpA = ^TRasPppIpA;
  TRasPppIpA = record
    dwSize: Longint;
    dwError: Longint;
    szIpAddress: Array[0..RAS_MaxIpAddress] of AnsiChar;

{$IFNDEF WINNT35COMPATIBLE}

    {* See RASPPPIPW comment.
    *}
    szServerIpAddress: Array[0..RAS_MaxIpAddress] of AnsiChar;

{$ENDIF}
  end;

  LPRasPppIp = ^TRasPppIp;
  TRasPppIp = TRasPppIpA;


{* Describes the results of a PPP LCP/multi-link negotiation.
*}
  LpRasPppLcp = ^TRasPppLcp;
  TRasPppLcp = record
    dwSize: Longint;
    fBundled: LongBool;
  end;


{* Describes the results of a SLIP (Serial Line IP) projection.
*}
  LpRasSlipW = ^TRasSlipW;
  TRasSlipW = record
    dwSize: Longint;
    dwError: Longint;
    szIpAddress: Array[0..RAS_MaxIpAddress] of WideChar;
  end;

  LpRasSlipA = ^TRasSlipA;
  TRasSlipA = record
    dwSize: Longint;
    dwError: Longint;
    szIpAddress: Array[0..RAS_MaxIpAddress] of AnsiChar;
  end;

  LpRasSlip = ^TRasSlip;
  TRasSlip = TRasSlipA;


const

{* If using RasDial message notifications, get the notification message code
** by passing this string to the RegisterWindowMessageA() API.
** WM_RASDIALEVENT is used only if a unique message cannot be registered.
*}
  RASDIALEVENT    = 'RasDialEvent';
  WM_RASDIALEVENT = $CCCD;


{* Prototypes for caller's RasDial callback handler.  Arguments are the
** message ID (currently always WM_RASDIALEVENT), the current RASCONNSTATE and
** the error that has occurred (or 0 if none).  Extended arguments are the
** handle of the RAS connection and an extended error code.
**
** For RASDIALFUNC2, subsequent callback notifications for all
** subentries can be cancelled by returning FALSE.
*}
{
typedef VOID (WINAPI *RASDIALFUNC)( UINT, RASCONNSTATE, DWORD );
typedef VOID (WINAPI *RASDIALFUNC1)( HRASCONN, UINT, RASCONNSTATE, DWORD, DWORD );
typedef DWORD (WINAPI *RASDIALFUNC2)( DWORD, DWORD, HRASCONN, UINT, RASCONNSTATE, DWORD, DWORD );

For Delphi: Just define the callback as:

procedure RASCallback(msg: Integer; state: TRasConnState;
    dwError: Longint); stdcall;

procedure RASCallback1(hConn: THRasConn; msg: Integer;
    state: TRasConnState; dwError: Longint; dwEexterror: Longint); stdcall;

procedure RASCallback2(dwCallbackId, dwSubEntry: Longint; hConn: THRasConn;
    msg: Integer; state: TRasConnState; dwError: Longint;
    dwEexterror: Longint); stdcall;
}

type

{* Information describing a RAS-capable device.
*}
  LPRasDevInfoA = ^TRasDevInfoA;
  TRasDevInfoA = record
    dwSize: Longint;
    szDeviceType: Array[0..RAS_MaxDeviceType] of AnsiChar;
    szDeviceName: Array[0..RAS_MaxDeviceName] of AnsiChar;
  end;

  LPRasDevInfoW = ^TRasDevInfoW;
  TRasDevInfoW = record
    dwSize: Longint;
    szDeviceType: Array[0..RAS_MaxDeviceType] of WideChar;
    szDeviceName: Array[0..RAS_MaxDeviceName] of WideChar;
  end;

  LPRasDevInfo = ^TRasDevInfo;
  TRasDevInfo = TRasDevInfoA;


(* RAS Country Information (currently retreieved from TAPI).
*)
  LPRasCtryInfo = ^TRasCtryInfo;
  TRasCtryInfo = record
    dwSize,
    dwCountryID,
    dwNextCountryID,
    dwCountryCode,
    dwCountryNameOffset: Longint;
  end;

{* There is currently no difference between
** RASCTRYINFOA and RASCTRYINFOW.  This may
** change in the future.
*}

  LPRasCtryInfoW = ^TRasCtryInfoW;
  TRasCtryInfoW = TRasCtryInfo;
  LPRasCtryInfoA = ^TRasCtryInfoA;
  TRasCtryInfoA = TRasCtryInfo;


(* A RAS IP Address.
*)
  LPRasIPAddr = ^TRasIPAddr;
  TRasIPAddr = record
    a, b, c, d: Byte;
  end;


(* A RAS phonebook entry.
*)
  LPRasEntryA = ^TRasEntryA;
  TRasEntryA = record
    dwSize,
    dwfOptions,
    //
    // Location/phone number.
    //
    dwCountryID,
    dwCountryCode: Longint;
    szAreaCode: array[0.. RAS_MaxAreaCode] of AnsiChar;
    szLocalPhoneNumber: array[0..RAS_MaxPhoneNumber] of AnsiChar;
    dwAlternatesOffset: Longint;
    //
    // PPP/Ip
    //
    ipaddr,
    ipaddrDns,
    ipaddrDnsAlt,
    ipaddrWins,
    ipaddrWinsAlt: TRasIPAddr;
    //
    // Framing
    //
    dwFrameSize,
    dwfNetProtocols,
    dwFramingProtocol: Longint;
    //
    // Scripting
    //
    szScript: Array[0..MAX_PATH - 1] of AnsiChar;
    //
    // AutoDial
    //
    szAutodialDll: Array [0..MAX_PATH - 1] of AnsiChar;
    szAutodialFunc: Array [0..MAX_PATH - 1] of AnsiChar;
    //
    // Device
    //
    szDeviceType: Array [0..RAS_MaxDeviceType] of AnsiChar;
    szDeviceName: Array [0..RAS_MaxDeviceName] of AnsiChar;
    //
    // X.25
    //
    szX25PadType: Array [0..RAS_MaxPadType] of AnsiChar;
    szX25Address: Array [0..RAS_MaxX25Address] of AnsiChar;
    szX25Facilities: Array [0..RAS_MaxFacilities] of AnsiChar;
    szX25UserData: Array [0..RAS_MaxUserData] of AnsiChar;
    dwChannels: Longint;
    //
    // Reserved
    //
    dwReserved1,
    dwReserved2: Longint;
{$IFDEF WINVER41}
    //
    // Multilink
    //
    dwSubEntries,
    dwDialMode,
    dwDialExtraPercent,
    dwDialExtraSampleSeconds,
    dwHangUpExtraPercent,
    dwHangUpExtraSampleSeconds: Longint;
    //
    // Idle timeout
    //
    dwIdleDisconnectSeconds: Longint;
{$ENDIF}
  end;

  LPRasEntryW = ^TRasEntryW;
  TRasEntryW = record
    dwSize,
    dwfOptions,
    //
    // Location/phone number.
    //
    dwCountryID,
    dwCountryCode: Longint;
    szAreaCode: array[0.. RAS_MaxAreaCode] of WideChar;
    szLocalPhoneNumber: array[0..RAS_MaxPhoneNumber] of WideChar;
    dwAlternatesOffset: Longint;
    //
    // PPP/Ip
    //
    ipaddr,
    ipaddrDns,
    ipaddrDnsAlt,
    ipaddrWins,
    ipaddrWinsAlt: TRasIPAddr;
    //
    // Framing
    //
    dwFrameSize,
    dwfNetProtocols,
    dwFramingProtocol: Longint;
    //
    // Scripting
    //
    szScript: Array[0..MAX_PATH - 1] of WideChar;
    //
    // AutoDial
    //
    szAutodialDll: Array [0..MAX_PATH - 1] of WideChar;
    szAutodialFunc: Array [0..MAX_PATH - 1] of WideChar;
    //
    // Device
    //
    szDeviceType: Array [0..RAS_MaxDeviceType] of WideChar;
    szDeviceName: Array [0..RAS_MaxDeviceName] of WideChar;
    //
    // X.25
    //
    szX25PadType: Array [0..RAS_MaxPadType] of WideChar;
    szX25Address: Array [0..RAS_MaxX25Address] of WideChar;
    szX25Facilities: Array [0..RAS_MaxFacilities] of WideChar;
    szX25UserData: Array [0..RAS_MaxUserData] of WideChar;
    dwChannels,
    //
    // Reserved
    //
    dwReserved1,
    dwReserved2: Longint;
{$IFDEF WINVER41}
    //
    // Multilink
    //
    dwSubEntries,
    dwDialMode,
    dwDialExtraPercent,
    dwDialExtraSampleSeconds,
    dwHangUpExtraPercent,
    dwHangUpExtraSampleSeconds: Longint;
    //
    // Idle timeout
    //
    dwIdleDisconnectSeconds: Longint;
{$ENDIF}
  end;

  LPRasEntry = ^TRasEntry;
  TRasEntry = TRasEntryA;

const

(* TRasEntry 'dwfOptions' bit flags.
*)
  RASEO_UseCountryAndAreaCodes = $00000001;
  RASEO_SpecificIpAddr         = $00000002;
  RASEO_SpecificNameServers    = $00000004;
  RASEO_IpHeaderCompression    = $00000008;
  RASEO_RemoteDefaultGateway   = $00000010;
  RASEO_DisableLcpExtensions   = $00000020;
  RASEO_TerminalBeforeDial     = $00000040;
  RASEO_TerminalAfterDial      = $00000080;
  RASEO_ModemLights            = $00000100;
  RASEO_SwCompression          = $00000200;
  RASEO_RequireEncryptedPw     = $00000400;
  RASEO_RequireMsEncryptedPw   = $00000800;
  RASEO_RequireDataEncryption  = $00001000;
  RASEO_NetworkLogon           = $00002000;
  RASEO_UseLogonCredentials    = $00004000;
  RASEO_PromoteAlternates      = $00008000;
{$IFDEF WINVER41}
  RASEO_SecureLocalFiles       = $00010000;
{$ENDIF}

(* TRasEntry 'dwfNetProtocols' bit flags. (session negotiated protocols)
*)
  RASNP_Netbeui = $00000001;  // Negotiate NetBEUI
  RASNP_Ipx     = $00000002;  // Negotiate IPX
  RASNP_Ip      = $00000004;  // Negotiate TCP/IP

(* TRasEntry 'dwFramingProtocols' (framing protocols used by the server)
*)
  RASFP_Ppp  = $00000001;  // Point-to-Point Protocol (PPP)
  RASFP_Slip = $00000002;  // Serial Line Internet Protocol (SLIP)
  RASFP_Ras  = $00000004;  // Microsoft proprietary protocol

(* TRasEntry 'szDeviceType' strings
*)
  RASDT_Modem = 'modem';     // Modem
  RASDT_Isdn  = 'isdn';      // ISDN
  RASDT_X25   = 'x25';      // X.25


{* Old AutoDial DLL function prototype.
**
** This prototype is documented for backward-compatibility
** purposes only.  It is superceded by the RASADFUNCA
** and RASADFUNCW definitions below.  DO NOT USE THIS
** PROTOTYPE IN NEW CODE.  SUPPORT FOR IT MAY BE REMOVED
** IN FUTURE VERSIONS OF RAS.
*}
{
typedef BOOL (WINAPI *ORASADFUNC)( HWND, LPSTR, DWORD, LPDWORD );

For Delphi:

function ORasAdFunc(hwndParent: THandle; szEntry: PChar; dwFlags: Longint;
    var lpdwRetCode: Longint): Boolean; stdcall;
}

{$IFDEF WINVER41}
{* Flags for RasConnectionNotification().
*}
  RASCN_Connection       = $00000001;
  RASCN_Disconnection    = $00000002;
  RASCN_BandwidthAdded   = $00000004;
  RASCN_BandwidthRemoved = $00000008;

{* TRasEntry 'dwDialMode' values.
*}
  RASEDM_DialAll      = 1;
  RASEDM_DialAsNeeded = 2;

{* TRasEntry 'dwIdleDisconnectSeconds' constants.
*}
  RASIDS_Disabled       = $ffffffff;
  RASIDS_UseGlobalValue = 0;

type

{* AutoDial DLL function parameter block.
*}
  LpRasADParams = ^TRasADParams;
  TRasADParams = record
    dwSize: Longint;
    hwndOwner: THandle;
    dwFlags: Longint;
    xDlg,
    yDlg: Longint;
  end;

const

{* AutoDial DLL function parameter block 'dwFlags.'
*}
  RASADFLG_PositionDlg = $00000001;

{* Prototype AutoDial DLL function.
*}
{
typedef BOOL (WINAPI *RASADFUNCA)( LPSTR, LPSTR, LPRASADPARAMS, LPDWORD );
typedef BOOL (WINAPI *RASADFUNCW)( LPWSTR, LPWSTR, LPRASADPARAMS, LPDWORD );

For Delphi:

function RasAdFuncA(lpszPhonebook, lpszEntry: PAnsiChar;
    var lpAutoDialParams: TRasADParams;
    var lpdwRetCode: Longint): Boolean; stdcall;

function RasAdFuncW(lpszPhonebook, lpszEntry: PWideChar;
    var lpAutoDialParams: TRasADParams;
    var lpdwRetCode: Longint): Boolean; stdcall;
}

type

{* A RAS phone book multilinked sub-entry.
*}
  LpRasSubEntryA = ^TRasSubEntryA;
  TRasSubEntryA = record
    dwSize,
    dwfFlags: Longint;
    //
    // Device
    //
    szDeviceType: Array[0..RAS_MaxDeviceType] of AnsiChar;
    szDeviceName: Array[0..RAS_MaxDeviceName] of AnsiChar;
    //
    // Phone numbers
    //
    szLocalPhoneNumber: Array[0..RAS_MaxPhoneNumber] of AnsiChar;
    dwAlternateOffset: Longint;
  end;

  LpRasSubEntryW = ^TRasSubEntryW;
  TRasSubEntryW = record
    dwSize,
    dwfFlags: Longint;
    //
    // Device
    //
    szDeviceType: Array[0..RAS_MaxDeviceType] of WideChar;
    szDeviceName: Array[0..RAS_MaxDeviceName] of WideChar;
    //
    // Phone numbers
    //
    szLocalPhoneNumber: Array[0..RAS_MaxPhoneNumber] of WideChar;
    dwAlternateOffset: Longint;
  end;

  LpRasSubEntry = ^TRasSubEntryA;
  TRasSubEntry = TRasSubEntryA;

{* Ras(Get,Set)Credentials structure.  These calls
** supercede Ras(Get,Set)EntryDialParams.
*}
  LpRasCredentialsA = ^TRasCredentialsA;
  TRasCredentialsA = record
    dwSize,
    dwMask: Longint;
    szUserName: Array[0..UNLEN] of AnsiChar;
    zPassword: Array[0..PWLEN ] of AnsiChar;
    szDomain: Array[0..DNLEN] of AnsiChar;
  end;

  LpRasCredentialsW = ^TRasCredentialsW;
  TRasCredentialsW = record
    dwSize,
    dwMask: Longint;
    szUserName: Array[0..UNLEN] of WideChar;
    zPassword: Array[0..PWLEN ] of WideChar;
    szDomain: Array[0..DNLEN] of WideChar;
  end;

  LPRasCredentials = ^TRasCredentials;
  TRasCredentials = TRasCredentialsA;

const

{* TRasCredentials 'dwMask' values.
*}
  RASCM_UserName = $00000001;
  RASCM_Password = $00000002;
  RASCM_Domain   = $00000004;


type

{* AutoDial address properties.
*}
  LPRasAutoDialEntryA = ^TRasAutoDialEntryA;
  TRasAutoDialEntryA = record
    dwSize,
    dwFlags,
    dwDialingLocation: Longint;
    szEntry: Array[0..RAS_MaxEntryName] of AnsiChar;
  end;

  LPRasAutoDialEntryW = ^TRasAutoDialEntryW;
  TRasAutoDialEntryW = record
    dwSize,
    dwFlags,
    dwDialingLocation: Longint;
    szEntry: Array[0..RAS_MaxEntryName] of WideChar;
  end;

  LPRasAutoDialEntry = ^TRasAutoDialEntry;
  TRasAutoDialEntry = TRasAutoDialEntryA;

const

{* AutoDial control parameter values for
** Ras(Get,Set)AutodialParam.
*}
  RASADP_DisableConnectionQuery  = 0;
  RASADP_LoginSessionDisable     = 1;
  RASADP_SavedAddressesLimit     = 2;
  RASADP_FailedConnectionTimeout = 3;
  RASADP_ConnectionQueryTimeout  = 4;
{$ENDIF}  // WINVER41



{* External RAS API function prototypes.
*}
{Note: for Delphi the function without 'A' or 'W' is the Ansi one
  as on the other Delphi headers}

function RasDialA(
    lpRasDialExt: LPRasDialExtensions;
    lpszPhoneBook: PAnsiChar;
    var params: TRasDialParamsA;
    dwNotifierType: Longint;
    lpNotifier: Pointer;
    var rasconn: THRasConn
    ): Longint; stdcall;
function RasDialW(
    lpRasDialExt: LPRasDialExtensions;
    lpszPhoneBook: PWideChar;
    var params: TRasDialParamsW;
    dwNotifierType: Longint;
    lpNotifier: Pointer;
    var rasconn: THRasConn
    ): Longint; stdcall;
function RasDial(
    lpRasDialExt: LPRasDialExtensions;
    lpszPhoneBook: PChar;
    var params: TRasDialParams;
    dwNotifierType: Longint;
    lpNotifier: Pointer;
    var rasconn: THRasConn
    ): Longint; stdcall;

function RasEnumConnectionsA(
    rasconnArray: LPRasConnA;
    var lpcb: Longint;
    var lpcConnections: Longint
    ): Longint; stdcall;
function RasEnumConnectionsW(
    rasconnArray: LPRasConnW;
    var lpcb: Longint;
    var lpcConnections: Longint
    ): Longint; stdcall;
function RasEnumConnections(
    rasconnArray: LPRasConn;
    var lpcb: Longint;
    var lpcConnections: Longint
    ): Longint; stdcall;

function RasEnumEntriesA(
    reserved: PAnsiChar;
    lpszPhoneBook: PAnsiChar;
    entrynamesArray: LPRasEntryNameA;
    var lpcb: Longint;
    var lpcEntries: Longint
    ): Longint; stdcall;
function RasEnumEntriesW(
    reserved: PWideChar;
    lpszPhoneBook: PWideChar;
    entrynamesArray: LPRasEntryNameW;
    var lpcb: Longint;
    var lpcEntries: Longint
    ): Longint; stdcall;
function RasEnumEntries(
    reserved: PChar;
    lpszPhoneBook: PChar;
    entrynamesArray: LPRasEntryName;
    var lpcb: Longint;
    var lpcEntries: Longint
    ): Longint; stdcall;

function RasGetConnectStatusA(
    hConn: THRasConn;
    var lpStatus: TRasConnStatusA
    ): Longint; stdcall;
function RasGetConnectStatusW(
    hConn: THRasConn;
    var lpStatus: TRasConnStatusW
    ): Longint; stdcall;
function RasGetConnectStatus(
    hConn: THRasConn;
    var lpStatus: TRasConnStatus
    ): Longint; stdcall;

function RasGetErrorStringA(
    errorValue: Integer;
    erroString: PAnsiChar;
    cBufSize: Longint
    ): Longint; stdcall;
function RasGetErrorStringW(
    errorValue: Integer;
    erroString: PWideChar;
    cBufSize: Longint
    ): Longint; stdcall;
function RasGetErrorString(
    errorValue: Integer;
    erroString: PChar;
    cBufSize: Longint
    ): Longint; stdcall;

function RasHangUpA(
    hConn: THRasConn
    ): Longint; stdcall;
function RasHangUpW(
    hConn: THRasConn
    ): Longint; stdcall;
function RasHangUp(
    hConn: THRasConn
    ): Longint; stdcall;

function RasGetProjectionInfoA(
    hConn: THRasConn;
    rasproj: TRasProjection;
    lpProjection: Pointer;
    var lpcb: Longint
    ): Longint; stdcall;
function RasGetProjectionInfoW(
    hConn: THRasConn;
    rasproj: TRasProjection;
    lpProjection: Pointer;
    var lpcb: Longint
    ): Longint; stdcall;
function RasGetProjectionInfo(
    hConn: THRasConn;
    rasproj: TRasProjection;
    lpProjection: Pointer;
    var lpcb: Longint
    ): Longint; stdcall;

function RasCreatePhonebookEntryA(
    hwndParentWindow: HWND;
    lpszPhoneBook: PAnsiChar
    ): Longint; stdcall;
function RasCreatePhonebookEntryW(
    hwndParentWindow: HWND;
    lpszPhoneBook: PWideChar
    ): Longint; stdcall;
function RasCreatePhonebookEntry(
    hwndParentWindow: HWND;
    lpszPhoneBook: PChar
    ): Longint; stdcall;

function RasEditPhonebookEntryA(
    hwndParentWindow: HWND;
    lpszPhoneBook: PAnsiChar;
    lpszEntryName: PAnsiChar
    ): Longint; stdcall;
function RasEditPhonebookEntryW(
    hwndParentWindow: HWND;
    lpszPhoneBook: PWideChar;
    lpszEntryName: PWideChar
    ): Longint; stdcall;
function RasEditPhonebookEntry(
    hwndParentWindow: HWND;
    lpszPhoneBook: PChar;
    lpszEntryName: PChar
    ): Longint; stdcall;

function RasSetEntryDialParamsA(
    lpszPhoneBook: PAnsiChar;
    var lpDialParams: TRasDialParamsA;
    fRemovePassword: LongBool
    ): Longint; stdcall;
function RasSetEntryDialParamsW(
    lpszPhoneBook: PWideChar;
    var lpDialParams: TRasDialParamsW;
    fRemovePassword: LongBool
    ): Longint; stdcall;
function RasSetEntryDialParams(
    lpszPhoneBook: PChar;
    var lpDialParams: TRasDialParams;
    fRemovePassword: LongBool
    ): Longint; stdcall;

function RasGetEntryDialParamsA(
    lpszPhoneBook: PAnsiChar;
    var lpDialParams: TRasDialParamsA;
    var lpfPassword: LongBool
    ): Longint; stdcall;
function RasGetEntryDialParamsW(
    lpszPhoneBook: PWideChar;
    var lpDialParams: TRasDialParamsW;
    var lpfPassword: LongBool
    ): Longint; stdcall;
function RasGetEntryDialParams(
    lpszPhoneBook: PChar;
    var lpDialParams: TRasDialParams;
    var lpfPassword: LongBool
    ): Longint; stdcall;

function RasEnumDevicesA(
    lpBuff: LPRasDevInfoA;
    var lpcbSize: Longint;
    var lpcDevices: Longint
    ): Longint; stdcall;
function RasEnumDevicesW(
    lpBuff: LPRasDevInfoW;
    var lpcbSize: Longint;
    var lpcDevices: Longint
    ): Longint; stdcall;
function RasEnumDevices(
    lpBuff: LPRasDevInfo;
    var lpcbSize: Longint;
    var lpcDevices: Longint
    ): Longint; stdcall;

function RasGetCountryInfoA(
    var lpCtryInfo: TRasCtryInfo;
    var lpdwSize: Longint
    ): Longint; stdcall;
function RasGetCountryInfoW(
    var lpCtryInfo: TRasCtryInfo;
    var lpdwSize: Longint
    ): Longint; stdcall;
function RasGetCountryInfo(
    var lpCtryInfo: TRasCtryInfo;
    var lpdwSize: Longint
    ): Longint; stdcall;

function RasGetEntryPropertiesA(
    lpszPhonebook,
    szEntry: PAnsiChar;
	  lpbEntry: Pointer;
    var lpdwEntrySize: Longint;
    lpbDeviceInfo: Pointer;
    var lpdwDeviceInfoSize: Longint
    ): Longint; stdcall;
function RasGetEntryPropertiesW(
    lpszPhonebook,
    szEntry: PWideChar;
	  lpbEntry: Pointer;
    var lpdwEntrySize: Longint;
    lpbDeviceInfo: Pointer;
    var lpdwDeviceInfoSize: Longint
    ): Longint; stdcall;
function RasGetEntryProperties(
    lpszPhonebook,
    szEntry: PChar;
	  lpbEntry: Pointer;
    var lpdwEntrySize: Longint;
    lpbDeviceInfo: Pointer;
    var lpdwDeviceInfoSize: Longint
    ): Longint; stdcall;

function RasSetEntryPropertiesA(
    lpszPhonebook,
    szEntry: PAnsiChar;
	  lpbEntry: Pointer;
    dwEntrySize: Longint;
    lpbDeviceInfo: Pointer;
    dwDeviceInfoSize: Longint
    ): Longint; stdcall;
function RasSetEntryPropertiesW(
    lpszPhonebook,
    szEntry: PWideChar;
	  lpbEntry: Pointer;
    dwEntrySize: Longint;
    lpbDeviceInfo: Pointer;
    dwDeviceInfoSize: Longint
    ): Longint; stdcall;
function RasSetEntryProperties(
    lpszPhonebook,
    szEntry: PChar;
	  lpbEntry: Pointer;
    dwEntrySize: Longint;
    lpbDeviceInfo: Pointer;
    dwDeviceInfoSize: Longint
    ): Longint; stdcall;

function RasRenameEntryA(
    lpszPhonebook,
    szEntryOld,
    szEntryNew: PAnsiChar
    ): Longint; stdcall;
function RasRenameEntryW(
    lpszPhonebook,
    szEntryOld,
    szEntryNew: PWideChar
    ): Longint; stdcall;
function RasRenameEntry(
    lpszPhonebook,
    szEntryOld,
    szEntryNew: PChar
    ): Longint; stdcall;

function RasDeleteEntryA(
    lpszPhonebook,
    szEntry: PAnsiChar
    ): Longint; stdcall;
function RasDeleteEntryW(
    lpszPhonebook,
    szEntry: PWideChar
    ): Longint; stdcall;
function RasDeleteEntry(
    lpszPhonebook,
    szEntry: PChar
    ): Longint; stdcall;

function RasValidateEntryNameA(
    lpszPhonebook,
    szEntry: PAnsiChar
    ): Longint; stdcall;
function RasValidateEntryNameW(
    lpszPhonebook,
    szEntry: PWideChar
    ): Longint; stdcall;
function RasValidateEntryName(
    lpszPhonebook,
    szEntry: PChar
    ): Longint; stdcall;

{$IFDEF WINVER41}
function RasGetSubEntryHandleA(
    hrasconn: THRasConn;
    dwSubEntry: Longint;
    var lphrasconn: THRasConn
    ): Longint; stdcall;
function RasGetSubEntryHandleW(
    hrasconn: THRasConn;
    dwSubEntry: Longint;
    var lphrasconn: THRasConn
    ): Longint; stdcall;
function RasGetSubEntryHandle(
    hrasconn: THRasConn;
    dwSubEntry: Longint;
    var lphrasconn: THRasConn
    ): Longint; stdcall;

function RasGetCredentialsA(
    lpszPhoneBook,
    lpszEntry: PAnsiChar;
    var lpCredentials: TRasCredentialsA
    ): Longint; stdcall;
function RasGetCredentialsW(
    lpszPhoneBook,
    lpszEntry: PWideChar;
    var lpCredentials: TRasCredentialsW
    ): Longint; stdcall;
function RasGetCredentials(
    lpszPhoneBook,
    lpszEntry: PChar;
    var lpCredentials: TRasCredentials
    ): Longint; stdcall;

function RasSetCredentialsA(
    lpszPhoneBook,
    lpszEntry: PAnsiChar;
    var lpCredentials: TRasCredentialsA;
    fRemovePassword: LongBool
    ): Longint; stdcall;
function RasSetCredentialsW(
    lpszPhoneBook,
    lpszEntry: PWideChar;
    var lpCredentials: TRasCredentialsW;
    fRemovePassword: LongBool
    ): Longint; stdcall;
function RasSetCredentials(
    lpszPhoneBook,
    lpszEntry: PChar;
    var lpCredentials: TRasCredentials;
    fRemovePassword: LongBool
    ): Longint; stdcall;

function RasConnectionNotificationA(
  hrasconn: THRasConn;
  hEvent: THandle;
  dwFlags: Longint
  ): Longint; stdcall;
function RasConnectionNotificationW(
  hrasconn: THRasConn;
  hEvent: THandle;
  dwFlags: Longint
  ): Longint; stdcall;
function RasConnectionNotification(
  hrasconn: THRasConn;
  hEvent: THandle;
  dwFlags: Longint
  ): Longint; stdcall;

function RasGetSubEntryPropertiesA(
    lpszPhoneBook,
    lpszEntry: PAnsiChar;
    dwSubEntry: Longint;
    var lpRasSubEntry: TRasSubEntryA;
    var lpdwcb: Longint;
    p: Pointer;
    var lpdw: Longint
    ): Longint; stdcall;
function RasGetSubEntryPropertiesW(
    lpszPhoneBook,
    lpszEntry: PWideChar;
    dwSubEntry: Longint;
    var lpRasSubEntry: TRasSubEntryW;
    var lpdwcb: Longint;
    p: Pointer;
    var lpdw: Longint
    ): Longint; stdcall;
function RasGetSubEntryProperties(
    lpszPhoneBook,
    lpszEntry: PChar;
    dwSubEntry: Longint;
    var lpRasSubEntry: TRasSubEntry;
    var lpdwcb: Longint;
    p: Pointer;
    var lpdw: Longint
    ): Longint; stdcall;

function RasSetSubEntryPropertiesA(
    lpszPhoneBook,
    lpszEntry: PAnsiChar;
    dwSubEntry: Longint;
    var lpRasSubEntry: TRasSubEntryA;
    dwcb: Longint;
    p: Pointer;
    dw: Longint
    ): Longint; stdcall;
function RasSetSubEntryPropertiesW(
    lpszPhoneBook,
    lpszEntry: PWideChar;
    dwSubEntry: Longint;
    var lpRasSubEntry: TRasSubEntryW;
    dwcb: Longint;
    p: Pointer;
    dw: Longint
    ): Longint; stdcall;
function RasSetSubEntryProperties(
    lpszPhoneBook,
    lpszEntry: PChar;
    dwSubEntry: Longint;
    var lpRasSubEntry: TRasSubEntry;
    dwcb: Longint;
    p: Pointer;
    dw: Longint
    ): Longint; stdcall;

function RasGetAutodialAddressA(
    lpszAddress: PAnsiChar;
    lpdwReserved: Pointer;
    lpAutoDialEntries: LPRasAutoDialEntryA;
    var lpdwcbAutoDialEntries: Longint;
    var lpdwcAutoDialEntries: Longint
    ): Longint; stdcall;
function RasGetAutodialAddressW(
    lpszAddress: PWideChar;
    lpdwReserved: Pointer;
    lpAutoDialEntries: LPRasAutoDialEntryW;
    var lpdwcbAutoDialEntries: Longint;
    var lpdwcAutoDialEntries: Longint
    ): Longint; stdcall;
function RasGetAutodialAddress(
    lpszAddress: PChar;
    lpdwReserved: Pointer;
    lpAutoDialEntries: LPRasAutoDialEntry;
    var lpdwcbAutoDialEntries: Longint;
    var lpdwcAutoDialEntries: Longint
    ): Longint; stdcall;

function RasSetAutodialAddressA(
    lpszAddress: PAnsiChar;
    dwReserved: Longint;
    lpAutoDialEntries: LPRasAutoDialEntryA;
    dwcbAutoDialEntries: Longint;
    dwcAutoDialEntries: Longint
    ): Longint; stdcall;
function RasSetAutodialAddressW(
    lpszAddress: PWideChar;
    dwReserved: Longint;
    lpAutoDialEntries: LPRasAutoDialEntryW;
    dwcbAutoDialEntries: Longint;
    dwcAutoDialEntries: Longint
    ): Longint; stdcall;
function RasSetAutodialAddress(
    lpszAddress: PChar;
    dwReserved: Longint;
    lpAutoDialEntries: LPRasAutoDialEntry;
    dwcbAutoDialEntries: Longint;
    dwcAutoDialEntries: Longint
    ): Longint; stdcall;

function RasEnumAutodialAddressesA(
    lppAddresses: Pointer;
    var lpdwcbAddresses: Longint;
    var lpdwAddresses: Longint
    ): Longint; stdcall;
function RasEnumAutodialAddressesW(
    lppAddresses: Pointer;
    var lpdwcbAddresses: Longint;
    var lpdwAddresses: Longint
    ): Longint; stdcall;
function RasEnumAutodialAddresses(
    lppAddresses: Pointer;
    var lpdwcbAddresses: Longint;
    var lpdwAddresses: Longint
    ): Longint; stdcall;

function RasGetAutodialEnableA(
    dwDialingLocation: Longint;
    var lpfEnabled: LongBool
    ): Longint; stdcall;
function RasGetAutodialEnableW(
    dwDialingLocation: Longint;
    var lpfEnabled: LongBool
    ): Longint; stdcall;
function RasGetAutodialEnable(
    dwDialingLocation: Longint;
    var lpfEnabled: LongBool
    ): Longint; stdcall;

function RasSetAutodialEnableA(
    dwDialingLocation: Longint;
    fEnabled: LongBool
    ): Longint; stdcall;
function RasSetAutodialEnableW(
    dwDialingLocation: Longint;
    fEnabled: LongBool
    ): Longint; stdcall;
function RasSetAutodialEnable(
    dwDialingLocation: Longint;
    fEnabled: LongBool
    ): Longint; stdcall;

function RasGetAutodialParamA(
    dwKey: Longint;
    lpvValue: Pointer;
    var lpdwcbValue: Longint
    ): Longint; stdcall;
function RasGetAutodialParamW(
    dwKey: Longint;
    lpvValue: Pointer;
    var lpdwcbValue: Longint
    ): Longint; stdcall;
function RasGetAutodialParam(
    dwKey: Longint;
    lpvValue: Pointer;
    var lpdwcbValue: Longint
    ): Longint; stdcall;

function RasSetAutodialParamA(
    dwKey: Longint;
    lpvValue: Pointer;
    dwcbValue: Longint
    ): Longint; stdcall;
function RasSetAutodialParamW(
    dwKey: Longint;
    lpvValue: Pointer;
    dwcbValue: Longint
    ): Longint; stdcall;
function RasSetAutodialParam(
    dwKey: Longint;
    lpvValue: Pointer;
    dwcbValue: Longint
    ): Longint; stdcall;
{$ENDIF

{**
** raserror.h
** Remote Access external API
** RAS specific error codes
*}

const

  RASBASE = 600;
  SUCCESS = 0;

  PENDING                              = (RASBASE+0);
{*
 * An operation is pending.%0
 *}
  ERROR_INVALID_PORT_HANDLE            = (RASBASE+1);
{*
 * The port handle is invalid.%0
 *}
  ERROR_PORT_ALREADY_OPEN              = (RASBASE+2);
{*
 * The port is already open.%0
 *}
  ERROR_BUFFER_TOO_SMALL               = (RASBASE+3);
{*
 * Caller's buffer is too small.%0
 *}
  ERROR_WRONG_INFO_SPECIFIED           = (RASBASE+4);
{*
 * Wrong information specified.%0
 *}
  ERROR_CANNOT_SET_PORT_INFO           = (RASBASE+5);
{*
 * Cannot set port information.%0
 *}
  ERROR_PORT_NOT_CONNECTED             = (RASBASE+6);
{*
 * The port is not connected.%0
 *}
  ERROR_EVENT_INVALID                  = (RASBASE+7);
{*
 * The event is invalid.%0
 *}
  ERROR_DEVICE_DOES_NOT_EXIST          = (RASBASE+8);
{*
 * The device does not exist.%0
 *}
  ERROR_DEVICETYPE_DOES_NOT_EXIST      = (RASBASE+9);
{*
 * The device type does not exist.%0
 *}
  ERROR_BUFFER_INVALID                 = (RASBASE+10);
{*
 * The buffer is invalid.%0
 *}
  ERROR_ROUTE_NOT_AVAILABLE            = (RASBASE+11);
{*
 * The route is not available.%0
 *}
  ERROR_ROUTE_NOT_ALLOCATED            = (RASBASE+12);
{*
 * The route is not allocated.%0
 *}
  ERROR_INVALID_COMPRESSION_SPECIFIED  = (RASBASE+13);
{*
 * Invalid compression specified.%0
 *}
  ERROR_OUT_OF_BUFFERS                 = (RASBASE+14);
{*
 * Out of buffers.%0
 *}
  ERROR_PORT_NOT_FOUND                 = (RASBASE+15);
{*
 * The port was not found.%0
 *}
  ERROR_ASYNC_REQUEST_PENDING          = (RASBASE+16);
{*
 * An asynchronous request is pending.%0
 *}
  ERROR_ALREADY_DISCONNECTING          = (RASBASE+17);
{*
 * The port or device is already disconnecting.%0
 *}
  ERROR_PORT_NOT_OPEN                  = (RASBASE+18);
{*
 * The port is not open.%0
 *}
  ERROR_PORT_DISCONNECTED              = (RASBASE+19);
{*
 * The port is disconnected.%0
 *}
  ERROR_NO_ENDPOINTS                   = (RASBASE+20);
{*
 * There are no endpoints.%0
 *}
  ERROR_CANNOT_OPEN_PHONEBOOK          = (RASBASE+21);
{*
 * Cannot open the phone book file.%0
 *}
  ERROR_CANNOT_LOAD_PHONEBOOK          = (RASBASE+22);
{*
 * Cannot load the phone book file.%0
 *}
  ERROR_CANNOT_FIND_PHONEBOOK_ENTRY    = (RASBASE+23);
{*
 * Cannot find the phone book entry.%0
 *}
  ERROR_CANNOT_WRITE_PHONEBOOK         = (RASBASE+24);
{*
 * Cannot write the phone book file.%0
 *}
  ERROR_CORRUPT_PHONEBOOK              = (RASBASE+25);
{*
 * Invalid information found in the phone book file.%0
 *}
  ERROR_CANNOT_LOAD_STRING             = (RASBASE+26);
{*
 * Cannot load a string.%0
 *}
  ERROR_KEY_NOT_FOUND                  = (RASBASE+27);
{*
 * Cannot find key.%0
 *}
  ERROR_DISCONNECTION                  = (RASBASE+28);
{*
 * The port was disconnected.%0
 *}
  ERROR_REMOTE_DISCONNECTION           = (RASBASE+29);
{*
 * The port was disconnected by the remote machine.%0
 *}
  ERROR_HARDWARE_FAILURE               = (RASBASE+30);
{*
 * The port was disconnected due to hardware failure.%0
 *}
  ERROR_USER_DISCONNECTION             = (RASBASE+31);
{*
 * The port was disconnected by the user.%0
 *}
  ERROR_INVALID_SIZE                   = (RASBASE+32);
{*
 * The structure size is incorrect.%0
 *}
  ERROR_PORT_NOT_AVAILABLE             = (RASBASE+33);
{*
 * The port is already in use or is not configured for Remote Access dial out.%0
 *}
  ERROR_CANNOT_PROJECT_CLIENT          = (RASBASE+34);
{*
 * Cannot register your computer on on the remote network.%0
 *}
  ERROR_UNKNOWN                        = (RASBASE+35);
{*
 * Unknown error.%0
 *}
  ERROR_WRONG_DEVICE_ATTACHED          = (RASBASE+36);
{*
 * The wrong device is attached to the port.%0
 *}
  ERROR_BAD_STRING                     = (RASBASE+37);
{*
 * The string could not be converted.%0
 *}
  ERROR_REQUEST_TIMEOUT                = (RASBASE+38);
{*
 * The request has timed out.%0
 *}
  ERROR_CANNOT_GET_LANA                = (RASBASE+39);
{*
 * No asynchronous net available.%0
 *}
  ERROR_NETBIOS_ERROR                  = (RASBASE+40);
{*
 * A NetBIOS error has occurred.%0
 *}
  ERROR_SERVER_OUT_OF_RESOURCES        = (RASBASE+41);
{*
 * The server cannot allocate NetBIOS resources needed to support the client.%0
 *}
  ERROR_NAME_EXISTS_ON_NET             = (RASBASE+42);
{*
 * One of your NetBIOS names is already registered on the remote network.%0
 *}
  ERROR_SERVER_GENERAL_NET_FAILURE     = (RASBASE+43);
{*
 * A network adapter at the server failed.%0
 *}
  WARNING_MSG_ALIAS_NOT_ADDED          = (RASBASE+44);
{*
 * You will not receive network message popups.%0
 *}
  ERROR_AUTH_INTERNAL                  = (RASBASE+45);
{*
 * Internal authentication error.%0
 *}
  ERROR_RESTRICTED_LOGON_HOURS         = (RASBASE+46);
{*
 * The account is not permitted to logon at this time of day.%0
 *}
  ERROR_ACCT_DISABLED                  = (RASBASE+47);
{*
 * The account is disabled.%0
 *}
  ERROR_PASSWD_EXPIRED                 = (RASBASE+48);
{*
 * The password has expired.%0
 *}
  ERROR_NO_DIALIN_PERMISSION           = (RASBASE+49);
{*
 * The account does not have Remote Access permission.%0
 *}
  ERROR_SERVER_NOT_RESPONDING          = (RASBASE+50);
{*
 * The Remote Access server is not responding.%0
 *}
  ERROR_FROM_DEVICE                    = (RASBASE+51);
{*
 * Your modem (or other connecting device) has reported an error.%0
 *}
  ERROR_UNRECOGNIZED_RESPONSE          = (RASBASE+52);
{*
 * Unrecognized response from the device.%0
 *}
  ERROR_MACRO_NOT_FOUND                = (RASBASE+53);
{*
 * A macro required by the device was not found in the device .INF file section.%0
 *}
  ERROR_MACRO_NOT_DEFINED              = (RASBASE+54);
{*
 * A command or response in the device .INF file section refers to an undefined macro.%0
 *}
  ERROR_MESSAGE_MACRO_NOT_FOUND        = (RASBASE+55);
{*
 * The <message> macro was not found in the device .INF file secion.%0
 *}
  ERROR_DEFAULTOFF_MACRO_NOT_FOUND     = (RASBASE+56);
{*
 * The <defaultoff> macro in the device .INF file section contains an undefined macro.%0
 *}
  ERROR_FILE_COULD_NOT_BE_OPENED       = (RASBASE+57);
{*
 * The device .INF file could not be opened.%0
 *}
  ERROR_DEVICENAME_TOO_LONG            = (RASBASE+58);
{*
 * The device name in the device .INF or media .INI file is too long.%0
 *}
  ERROR_DEVICENAME_NOT_FOUND           = (RASBASE+59);
{*
 * The media .INI file refers to an unknown device name.%0
 *}
  ERROR_NO_RESPONSES                   = (RASBASE+60);
{*
 * The device .INF file contains no responses for the command.%0
 *}
  ERROR_NO_COMMAND_FOUND               = (RASBASE+61);
{*
 * The device .INF file is missing a command.%0
 *}
  ERROR_WRONG_KEY_SPECIFIED            = (RASBASE+62);
{*
 * Attempted to set a macro not listed in device .INF file section.%0
 *}
  ERROR_UNKNOWN_DEVICE_TYPE            = (RASBASE+63);
{*
 * The media .INI file refers to an unknown device type.%0
 *}
  ERROR_ALLOCATING_MEMORY              = (RASBASE+64);
{*
 * Cannot allocate memory.%0
 *}
  ERROR_PORT_NOT_CONFIGURED            = (RASBASE+65);
{*
 * The port is not configured for Remote Access.%0
 *}
  ERROR_DEVICE_NOT_READY               = (RASBASE+66);
{*
 * Your modem (or other connecting device) is not functioning.%0
 *}
  ERROR_READING_INI_FILE               = (RASBASE+67);
{*
 * Cannot read the media .INI file.%0
 *}
  ERROR_NO_CONNECTION                  = (RASBASE+68);
{*
 * The connection dropped.%0
 *}
  ERROR_BAD_USAGE_IN_INI_FILE          = (RASBASE+69);
{*
 * The usage parameter in the media .INI file is invalid.%0
 *}
  ERROR_READING_SECTIONNAME            = (RASBASE+70);
{*
 * Cannot read the section name from the media .INI file.%0
 *}
  ERROR_READING_DEVICETYPE             = (RASBASE+71);
{*
 * Cannot read the device type from the media .INI file.%0
 *}
  ERROR_READING_DEVICENAME             = (RASBASE+72);
{*
 * Cannot read the device name from the media .INI file.%0
 *}
  ERROR_READING_USAGE                  = (RASBASE+73);
{*
 * Cannot read the usage from the media .INI file.%0
 *}
  ERROR_READING_MAXCONNECTBPS          = (RASBASE+74);
{*
 * Cannot read the maximum connection BPS rate from the media .INI file.%0
 *}
  ERROR_READING_MAXCARRIERBPS          = (RASBASE+75);
{*
 * Cannot read the maximum carrier BPS rate from the media .INI file.%0
 *}
  ERROR_LINE_BUSY                      = (RASBASE+76);
{*
 * The line is busy.%0
 *}
  ERROR_VOICE_ANSWER                   = (RASBASE+77);
{*
 * A person answered instead of a modem.%0
 *}
  ERROR_NO_ANSWER                      = (RASBASE+78);
{*
 * There is no answer.%0
 *}
  ERROR_NO_CARRIER                     = (RASBASE+79);
{*
 * Cannot detect carrier.%0
 *}
  ERROR_NO_DIALTONE                    = (RASBASE+80);
{*
 * There is no dial tone.%0
 *}
  ERROR_IN_COMMAND                     = (RASBASE+81);
{*
 * General error reported by device.%0
 *}
  ERROR_WRITING_SECTIONNAME            = (RASBASE+82);
{*
 * ERROR_WRITING_SECTIONNAME%0
 *}
  ERROR_WRITING_DEVICETYPE             = (RASBASE+83);
{*
 * ERROR_WRITING_DEVICETYPE%0
 *}
  ERROR_WRITING_DEVICENAME             = (RASBASE+84);
{*
 * ERROR_WRITING_DEVICENAME%0
 *}
  ERROR_WRITING_MAXCONNECTBPS          = (RASBASE+85);
{*
 * ERROR_WRITING_MAXCONNECTBPS%0
 *}
  ERROR_WRITING_MAXCARRIERBPS          = (RASBASE+86);
{*
 * ERROR_WRITING_MAXCARRIERBPS%0
 *}
  ERROR_WRITING_USAGE                  = (RASBASE+87);
{*
 * ERROR_WRITING_USAGE%0
 *}
  ERROR_WRITING_DEFAULTOFF             = (RASBASE+88);
{*
 * ERROR_WRITING_DEFAULTOFF%0
 *}
  ERROR_READING_DEFAULTOFF             = (RASBASE+89);
{*
 * ERROR_READING_DEFAULTOFF%0
 *}
  ERROR_EMPTY_INI_FILE                 = (RASBASE+90);
{*
 * ERROR_EMPTY_INI_FILE%0
 *}
  ERROR_AUTHENTICATION_FAILURE         = (RASBASE+91);
{*
 * Access denied because username and/or password is invalid on the domain.%0
 *}
  ERROR_PORT_OR_DEVICE                 = (RASBASE+92);
{*
 * Hardware failure in port or attached device.%0
 *}
  ERROR_NOT_BINARY_MACRO               = (RASBASE+93);
{*
 * ERROR_NOT_BINARY_MACRO%0
 *}
  ERROR_DCB_NOT_FOUND                  = (RASBASE+94);
{*
 * ERROR_DCB_NOT_FOUND%0
 *}
  ERROR_STATE_MACHINES_NOT_STARTED     = (RASBASE+95);
{*
 * ERROR_STATE_MACHINES_NOT_STARTED%0
 *}
  ERROR_STATE_MACHINES_ALREADY_STARTED = (RASBASE+96);
{*
 * ERROR_STATE_MACHINES_ALREADY_STARTED%0
 *}
  ERROR_PARTIAL_RESPONSE_LOOPING       = (RASBASE+97);
{*
 * ERROR_PARTIAL_RESPONSE_LOOPING%0
 *}
  ERROR_UNKNOWN_RESPONSE_KEY           = (RASBASE+98);
{*
 * A response keyname in the device .INF file is not in the expected format.%0
 *}
  ERROR_RECV_BUF_FULL                  = (RASBASE+99);
{*
 * The device response caused buffer overflow.%0
 *}
  ERROR_CMD_TOO_LONG                   = (RASBASE+100);
{*
 * The expanded command in the device .INF file is too long.%0
 *}
  ERROR_UNSUPPORTED_BPS                = (RASBASE+101);
{*
 * The device moved to a BPS rate not supported by the COM driver.%0
 *}
  ERROR_UNEXPECTED_RESPONSE            = (RASBASE+102);
{*
 * Device response received when none expected.%0
 *}
  ERROR_INTERACTIVE_MODE               = (RASBASE+103);
{*
 * ERROR_INTERACTIVE_MODE%0
 *}
  ERROR_BAD_CALLBACK_NUMBER            = (RASBASE+104);
{*
 * ERROR_BAD_CALLBACK_NUMBER
 *}
  ERROR_INVALID_AUTH_STATE             = (RASBASE+105);
{*
 * ERROR_INVALID_AUTH_STATE%0
 *}
  ERROR_WRITING_INITBPS                = (RASBASE+106);
{*
 * ERROR_WRITING_INITBPS%0
 *}
  ERROR_X25_DIAGNOSTIC                 = (RASBASE+107);
{*
 * X.25 diagnostic indication.%0
 *}
  ERROR_ACCT_EXPIRED                   = (RASBASE+108);
{*
 * The account has expired.%0
 *}
  ERROR_CHANGING_PASSWORD              = (RASBASE+109);
{*
 * Error changing password on domain.  The password may be too short or may match a previously used password.%0
 *}
  ERROR_OVERRUN                        = (RASBASE+110);
{*
 * Serial overrun errors were detected while communicating with your modem.%0
 *}
  ERROR_RASMAN_CANNOT_INITIALIZE	     = (RASBASE+111);
{*
 * RasMan initialization failure.  Check the event log.%0
 *}
  ERROR_BIPLEX_PORT_NOT_AVAILABLE      = (RASBASE+112);
{*
 * Biplex port initializing.  Wait a few seconds and redial.%0
 *}
  ERROR_NO_ACTIVE_ISDN_LINES           = (RASBASE+113);
{*
 * No active ISDN lines are available.%0
 *}
  ERROR_NO_ISDN_CHANNELS_AVAILABLE     = (RASBASE+114);
{*
 * No ISDN channels are available to make the call.%0
 *}
  ERROR_TOO_MANY_LINE_ERRORS           = (RASBASE+115);
{*
 * Too many errors occured because of poor phone line quality.%0
 *}
  ERROR_IP_CONFIGURATION               = (RASBASE+116);
{*
 * The Remote Access IP configuration is unusable.%0
 *}
  ERROR_NO_IP_ADDRESSES                = (RASBASE+117);
{*
 * No IP addresses are available in the static pool of Remote Access IP addresses.%0
 *}
  ERROR_PPP_TIMEOUT                    = (RASBASE+118);
{*
 * Timed out waiting for a valid response from the remote PPP peer.%0
 *}
  ERROR_PPP_REMOTE_TERMINATED          = (RASBASE+119);
{*
 * PPP terminated by remote machine.%0
 *}
  ERROR_PPP_NO_PROTOCOLS_CONFIGURED    = (RASBASE+120);
{*
 * No PPP control protocols configured.%0
 *}
  ERROR_PPP_NO_RESPONSE                = (RASBASE+121);
{*
 * Remote PPP peer is not responding.%0
 *}
  ERROR_PPP_INVALID_PACKET             = (RASBASE+122);
{*
 * The PPP packet is invalid.%0
 *}
  ERROR_PHONE_NUMBER_TOO_LONG          = (RASBASE+123);
{*
 * The phone number including prefix and suffix is too long.%0
 *}
  ERROR_IPXCP_NO_DIALOUT_CONFIGURED    = (RASBASE+124);
{*
 * The IPX protocol cannot dial-out on the port because the machine is an IPX router.%0
 *}
  ERROR_IPXCP_NO_DIALIN_CONFIGURED     = (RASBASE+125);
{*
 * The IPX protocol cannot dial-in on the port because the IPX router is not installed.%0
 *}
  ERROR_IPXCP_DIALOUT_ALREADY_ACTIVE   = (RASBASE+126);
{*
 * The IPX protocol cannot be used for dial-out on more than one port at a time.%0
 *}
  ERROR_ACCESSING_TCPCFGDLL            = (RASBASE+127);
{*
 * Cannot access TCPCFG.DLL.%0
 *}
  ERROR_NO_IP_RAS_ADAPTER              = (RASBASE+128);
{*
 * Cannot find an IP adapter bound to Remote Access.%0
 *}
  ERROR_SLIP_REQUIRES_IP               = (RASBASE+129);
{*
 * SLIP cannot be used unless the IP protocol is installed.%0
 *}
  ERROR_PROJECTION_NOT_COMPLETE        = (RASBASE+130);
{*
 * Computer registration is not complete.%0
 *}
  ERROR_PROTOCOL_NOT_CONFIGURED        = (RASBASE+131);
{*
 * The protocol is not configured.%0
 *}
  ERROR_PPP_NOT_CONVERGING             = (RASBASE+132);
{*
 * The PPP negotiation is not converging.%0
 *}
  ERROR_PPP_CP_REJECTED                = (RASBASE+133);
{*
 * The PPP control protocol for this network protocol is not available on the server.%0
 *}
  ERROR_PPP_LCP_TERMINATED             = (RASBASE+134);
{*
 * The PPP link control protocol terminated.%0
 *}
  ERROR_PPP_REQUIRED_ADDRESS_REJECTED  = (RASBASE+135);
{*
 * The requested address was rejected by the server.%0
 *}
  ERROR_PPP_NCP_TERMINATED             = (RASBASE+136);
{*
 * The remote computer terminated the control protocol.%0
 *}
  ERROR_PPP_LOOPBACK_DETECTED          = (RASBASE+137);
{*
 * Loopback detected.%0
 *}
  ERROR_PPP_NO_ADDRESS_ASSIGNED        = (RASBASE+138);
{*
 * The server did not assign an address.%0
 *}
  ERROR_CANNOT_USE_LOGON_CREDENTIALS   = (RASBASE+139);
{*
 * The authentication protocol required by the remote server cannot use the Windows NT encrypted password.  Redial, entering the password explicitly.%0
 *}
  ERROR_TAPI_CONFIGURATION             = (RASBASE+140);
{*
 * Invalid TAPI configuration.%0
 *}
  ERROR_NO_LOCAL_ENCRYPTION            = (RASBASE+141);
{*
 * The local computer does not support encryption.%0
 *}
  ERROR_NO_REMOTE_ENCRYPTION           = (RASBASE+142);
{*
 * The remote server does not support encryption.%0
 *}
  ERROR_REMOTE_REQUIRES_ENCRYPTION     = (RASBASE+143);
{*
 * The remote server requires encryption.%0
 *}
  ERROR_IPXCP_NET_NUMBER_CONFLICT      = (RASBASE+144);
{*
 * Cannot use the IPX network number assigned by remote server.  Check the event log.%0
 *}
  ERROR_INVALID_SMM                    = (RASBASE+145);
{*
 * ERROR_INVALID_SMM%0
 *}
  ERROR_SMM_UNINITIALIZED              = (RASBASE+146);
{*
 * ERROR_SMM_UNINITIALIZED%0
 *}
  ERROR_NO_MAC_FOR_PORT                = (RASBASE+147);
{*
 * ERROR_NO_MAC_FOR_PORT%0
 *}
  ERROR_SMM_TIMEOUT                    = (RASBASE+148);
{*
 * ERROR_SMM_TIMEOUT%0
 *}
  ERROR_BAD_PHONE_NUMBER               = (RASBASE+149);
{*
 * ERROR_BAD_PHONE_NUMBER%0
 *}
  ERROR_WRONG_MODULE                   = (RASBASE+150);
{*
 * ERROR_WRONG_MODULE%0
 *}
  ERROR_INVALID_CALLBACK_NUMBER        = (RASBASE+151);
{*
 * Invalid callback number.  Only the characters 0 to 9, T, P, W, (, ), -, @, and space are allowed in the number.%0
 *}
  ERROR_SCRIPT_SYNTAX                  = (RASBASE+152);
{*
 * A syntax error was encountered while processing a script.%0
 *}
  RASBASEEND                           = (RASBASE+152);

implementation

function RasCreatePhonebookEntryA;   external 'rasapi32.dll' name 'RasCreatePhonebookEntryA';
function RasCreatePhonebookEntryW;   external 'rasapi32.dll' name 'RasCreatePhonebookEntryW';
function RasCreatePhonebookEntry;    external 'rasapi32.dll' name 'RasCreatePhonebookEntryA';
function RasDialA;                   external 'rasapi32.dll' name 'RasDialA';
function RasDialW;                   external 'rasapi32.dll' name 'RasDialW';
function RasDial;                    external 'rasapi32.dll' name 'RasDialA';
function RasEditPhonebookEntryA;     external 'rasapi32.dll' name 'RasEditPhonebookEntryA';
function RasEditPhonebookEntryW;     external 'rasapi32.dll' name 'RasEditPhonebookEntryW';
function RasEditPhonebookEntry;      external 'rasapi32.dll' name 'RasEditPhonebookEntryA';
function RasEnumConnectionsA;        external 'rasapi32.dll' name 'RasEnumConnectionsA';
function RasEnumConnectionsW;        external 'rasapi32.dll' name 'RasEnumConnectionsW';
function RasEnumConnections;         external 'rasapi32.dll' name 'RasEnumConnectionsA';
function RasEnumEntriesA;            external 'rasapi32.dll' name 'RasEnumEntriesA';
function RasEnumEntriesW;            external 'rasapi32.dll' name 'RasEnumEntriesW';
function RasEnumEntries;             external 'rasapi32.dll' name 'RasEnumEntriesA';
function RasGetConnectStatusA;       external 'rasapi32.dll' name 'RasGetConnectStatusA';
function RasGetConnectStatusW;       external 'rasapi32.dll' name 'RasGetConnectStatusW';
function RasGetConnectStatus;        external 'rasapi32.dll' name 'RasGetConnectStatusA';
function RasGetEntryDialParamsA;     external 'rasapi32.dll' name 'RasGetEntryDialParamsA';
function RasGetEntryDialParamsW;     external 'rasapi32.dll' name 'RasGetEntryDialParamsW';
function RasGetEntryDialParams;      external 'rasapi32.dll' name 'RasGetEntryDialParamsA';
function RasGetErrorStringA;         external 'rasapi32.dll' name 'RasGetErrorStringA';
function RasGetErrorStringW;         external 'rasapi32.dll' name 'RasGetErrorStringW';
function RasGetErrorString;          external 'rasapi32.dll' name 'RasGetErrorStringA';
function RasGetProjectionInfoA;      external 'rasapi32.dll' name 'RasGetProjectionInfoA';
function RasGetProjectionInfoW;      external 'rasapi32.dll' name 'RasGetProjectionInfoW';
function RasGetProjectionInfo;       external 'rasapi32.dll' name 'RasGetProjectionInfoA';
function RasHangUpA;                 external 'rasapi32.dll' name 'RasHangUpA';
function RasHangUpW;                 external 'rasapi32.dll' name 'RasHangUpW';
function RasHangUp;                  external 'rasapi32.dll' name 'RasHangUpA';
function RasSetEntryDialParamsA;     external 'rasapi32.dll' name 'RasSetEntryDialParamsA';
function RasSetEntryDialParamsW;     external 'rasapi32.dll' name 'RasSetEntryDialParamsW';
function RasSetEntryDialParams;      external 'rasapi32.dll' name 'RasSetEntryDialParamsA';

{* These are subject to change, since RNAPH.DLL will be removed.
** The 'A' and 'W' functions are present in Windows NT 4.0
*}
function RasEnumDevicesA;            external 'rasapi32.dll' name 'RasEnumDevicesA';
function RasEnumDevicesW;            external 'rasapi32.dll' name 'RasEnumDevicesW';
{$IFDEF WINVER41}
function RasEnumDevices;             external 'rasapi32.dll' name 'RasEnumDevicesA';
{$ENDIF}
function RasGetCountryInfoA;         external 'rasapi32.dll' name 'RasGetCountryInfoA';
function RasGetCountryInfoW;         external 'rasapi32.dll' name 'RasGetCountryInfoW';
{$IFDEF WINVER41}
function RasGetCountryInfo;          external 'rasapi32.dll' name 'RasGetCountryInfoA';
{$ENDIF}
function RasGetEntryPropertiesA;     external 'rasapi32.dll' name 'RasGetEntryPropertiesA';
function RasGetEntryPropertiesW;     external 'rasapi32.dll' name 'RasGetEntryPropertiesW';
{$IFDEF WINVER41}
function RasGetEntryProperties;      external 'rasapi32.dll' name 'RasGetEntryPropertiesA';
{$ENDIF}
function RasSetEntryPropertiesA;     external 'rasapi32.dll' name 'RasSetEntryPropertiesA';
function RasSetEntryPropertiesW;     external 'rasapi32.dll' name 'RasSetEntryPropertiesW';
{$IFDEF WINVER41}
function RasSetEntryProperties;      external 'rasapi32.dll' name 'RasSetEntryPropertiesA';
{$ENDIF}
function RasRenameEntryA;            external 'rasapi32.dll' name 'RasRenameEntryA';
function RasRenameEntryW;            external 'rasapi32.dll' name 'RasRenameEntryW';
{$IFDEF WINVER41}
function RasRenameEntry;             external 'rasapi32.dll' name 'RasRenameEntryA';
{$ENDIF}
function RasDeleteEntryA;            external 'rasapi32.dll' name 'RasDeleteEntryA';
function RasDeleteEntryW;            external 'rasapi32.dll' name 'RasDeleteEntryW';
{$IFDEF WINVER41}
function RasDeleteEntry;             external 'rasapi32.dll' name 'RasDeleteEntryA';
{$ENDIF}
function RasValidateEntryNameA;      external 'rasapi32.dll' name 'RasValidateEntryNameA';
function RasValidateEntryNameW;      external 'rasapi32.dll' name 'RasValidateEntryNameW';
{$IFDEF WINVER41}
function RasValidateEntryName;       external 'rasapi32.dll' name 'RasValidateEntryNameA';
{$ENDIF}
{$IFDEF WINVER41}
function RasGetSubEntryHandleA;      external 'rasapi32.dll' name 'RasGetSubEntryHandleA';
function RasGetSubEntryHandleW;      external 'rasapi32.dll' name 'RasGetSubEntryHandleW';
function RasGetSubEntryHandle;       external 'rasapi32.dll' name 'RasGetSubEntryHandleA';
function RasGetCredentialsA;         external 'rasapi32.dll' name 'RasGetCredentialsA';
function RasGetCredentialsW;         external 'rasapi32.dll' name 'RasGetCredentialsW';
function RasGetCredentials;          external 'rasapi32.dll' name 'RasGetCredentialsA';
function RasSetCredentialsA;         external 'rasapi32.dll' name 'RasSetCredentialsA';
function RasSetCredentialsW;         external 'rasapi32.dll' name 'RasSetCredentialsW';
function RasSetCredentials;          external 'rasapi32.dll' name 'RasSetCredentialsA';
function RasConnectionNotificationA; external 'rasapi32.dll' name 'RasConnectionNotificationA';
function RasConnectionNotificationW; external 'rasapi32.dll' name 'RasConnectionNotificationW';
function RasConnectionNotification;  external 'rasapi32.dll' name 'RasConnectionNotificationA';
function RasGetSubEntryPropertiesA;  external 'rasapi32.dll' name 'RasGetSubEntryPropertiesA';
function RasGetSubEntryPropertiesW;  external 'rasapi32.dll' name 'RasGetSubEntryPropertiesW';
function RasGetSubEntryProperties;   external 'rasapi32.dll' name 'RasGetSubEntryPropertiesA';
function RasSetSubEntryPropertiesA;  external 'rasapi32.dll' name 'RasSetSubEntryPropertiesA';
function RasSetSubEntryPropertiesW;  external 'rasapi32.dll' name 'RasSetSubEntryPropertiesW';
function RasSetSubEntryProperties;   external 'rasapi32.dll' name 'RasSetSubEntryPropertiesA';
function RasGetAutodialAddressA;     external 'rasapi32.dll' name 'RasGetAutodialAddressA';
function RasGetAutodialAddressW;     external 'rasapi32.dll' name 'RasGetAutodialAddressW';
function RasGetAutodialAddress;      external 'rasapi32.dll' name 'RasGetAutodialAddressA';
function RasSetAutodialAddressA;     external 'rasapi32.dll' name 'RasSetAutodialAddressA';
function RasSetAutodialAddressW;     external 'rasapi32.dll' name 'RasSetAutodialAddressW';
function RasSetAutodialAddress;      external 'rasapi32.dll' name 'RasSetAutodialAddressA';
function RasEnumAutodialAddressesA;  external 'rasapi32.dll' name 'RasEnumAutodialAddressesA';
function RasEnumAutodialAddressesW;  external 'rasapi32.dll' name 'RasEnumAutodialAddressesW';
function RasEnumAutodialAddresses;   external 'rasapi32.dll' name 'RasEnumAutodialAddressesA';
function RasGetAutodialEnableA;      external 'rasapi32.dll' name 'RasGetAutodialEnableA';
function RasGetAutodialEnableW;      external 'rasapi32.dll' name 'RasGetAutodialEnableW';
function RasGetAutodialEnable;       external 'rasapi32.dll' name 'RasGetAutodialEnableA';
function RasSetAutodialEnableA;      external 'rasapi32.dll' name 'RasSetAutodialEnableA';
function RasSetAutodialEnableW;      external 'rasapi32.dll' name 'RasSetAutodialEnableW';
function RasSetAutodialEnable;       external 'rasapi32.dll' name 'RasSetAutodialEnableA';
function RasGetAutodialParamA;       external 'rasapi32.dll' name 'RasGetAutodialParamA';
function RasGetAutodialParamW;       external 'rasapi32.dll' name 'RasGetAutodialParamW';
function RasGetAutodialParam;        external 'rasapi32.dll' name 'RasGetAutodialParamA';
function RasSetAutodialParamA;       external 'rasapi32.dll' name 'RasSetAutodialParamA';
function RasSetAutodialParamW;       external 'rasapi32.dll' name 'RasSetAutodialParamW';
function RasSetAutodialParam;        external 'rasapi32.dll' name 'RasSetAutodialParamA';
{$ENDIF}
{*
** but for now the functions without the type specifier must be implemented
** as follows (at least until rnaph.dll disappears...
*}

{$IFNDEF WINVER41}
var
  rnaph_initialized: Boolean = False;
  is_rnaph: Boolean = False;
  lib: HModule;

function rnaph_(const func: String): Pointer;
  begin
  Result := nil;
  if not rnaph_initialized then
    begin
    // Try first with RASAPI32.DLL
    lib := LoadLibrary('rasapi32.dll');
    if lib <> 0 then
      begin
      Result := GetProcAddress(lib, PChar(func + 'A'));
      if Result <> nil then
        begin
        rnaph_initialized := True;
        Exit;
        end;
      end
    else begin
       MsgOK('RAS: Error opening rasapi.dll');
    end;
    // function not found - try rnaph.dll
    lib := LoadLibrary('rnaph.dll');
    if lib <> 0 then
      begin
      Result := GetProcAddress(lib, PChar(func));
      if Result <> nil then
        begin
        rnaph_initialized := True;
        is_rnaph := True;
        Exit;
        end
      else begin
           MsgOK('RAS: Function ' + func + ' not found!');
        end
      end
    else begin
         MsgOK('RAS: Error opening rnaph.dll');
      end
    end
  else
    begin
    if is_rnaph then
      Result := GetProcAddress(lib, PChar(func))
    else
      Result := GetProcAddress(lib, PChar(func + 'A'));
    if Result = nil then begin
         MsgOK('RAS: Function ' + func + ' not found!');
      end
    end;
  end;

function RasValidateEntryName(lpszPhonebook, szEntry: PAnsiChar): Longint;
  var
    f: Function(lpszPhonebook, szEntry: PAnsiChar): Longint; stdcall;
  begin
  @f := rnaph_('RasValidateEntryName');
  Result := f(lpszPhonebook, szEntry);
  end;

function RasRenameEntry(lpszPhonebook, szEntryOld, szEntryNew: PAnsiChar): Longint;
  var
    f: function(lpszPhonebook, szEntryOld, szEntryNew: PAnsiChar): Longint; stdcall;
  begin
  @f := rnaph_('RasRenameEntry');
  Result := f(lpszPhonebook, szEntryOld, szEntryNew);
  end;

function RasDeleteEntry(lpszPhonebook, szEntry: PAnsiChar): Longint;
  var
    f: function(lpszPhonebook, szEntry: PAnsiChar): Longint; stdcall;
  begin
  @f := rnaph_('RasDeleteEntry');
  Result := f(lpszPhonebook, szEntry);
  end;

function RasGetEntryProperties(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
    var lpdwEntrySize: Longint; lpbDeviceInfo: Pointer;
    var lpdwDeviceInfoSize: Longint): Longint;
  var
    f: function(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
        var lpdwEntrySize: Longint; lpbDeviceInfo: Pointer;
        var lpdwDeviceInfoSize: Longint): Longint; stdcall;
  begin
  @f := rnaph_('RasGetEntryProperties');
  Result := f(lpszPhonebook, szEntry, lpbEntry, lpdwEntrySize, lpbDeviceInfo, lpdwDeviceInfoSize);
  end;

function RasSetEntryProperties(lpszPhonebook, szEntry: PAnsiChar;
	  lpbEntry: Pointer; dwEntrySize: Longint; lpbDeviceInfo: Pointer;
    dwDeviceInfoSize: Longint): Longint;
  var
    f: function(lpszPhonebook, szEntry: PAnsiChar;
    	  lpbEntry: Pointer; dwEntrySize: Longint; lpbDeviceInfo: Pointer;
        dwDeviceInfoSize: Longint): Longint; stdcall;
  begin
  @f := rnaph_('RasSetEntryProperties');
  Result := f(lpszPhonebook, szEntry, lpbEntry, dwEntrySize, lpbDeviceInfo, dwDeviceInfoSize);
  end;

function RasGetCountryInfo(var lpCtryInfo: TRasCtryInfo;
    var lpdwSize: Longint): Longint;
  var
    f: function(var lpCtryInfo: TRasCtryInfo;
        var lpdwSize: Longint): Longint; stdcall;
  begin
  @f := rnaph_('RasGetCountryInfo');
  Result := f(lpCtryInfo, lpdwSize);
  end;

function RasEnumDevices(lpBuff: LpRasDevInfo; var lpcbSize: Longint;
    var lpcDevices: Longint): Longint;
  var
    f: function(lpBuff: LpRasDevInfo; var lpcbSize: Longint;
        var lpcDevices: Longint): Longint; stdcall;
  begin
  @f := rnaph_('RasEnumDevices');
  Result := f(lpBuff, lpcbSize, lpcDevices);
  end;

initialization
finalization
  if rnaph_initialized and is_rnaph then
    FreeLibrary(lib);
{$ENDIF}
end.
