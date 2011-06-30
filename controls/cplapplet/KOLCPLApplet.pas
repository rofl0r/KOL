unit KOLCPLApplet;
{* TKOLCPLApplet object used with TKOLCPLProject to visually create CPL applets.
|<br>
Created for KOL by Bogus³aw Brandys.
}

interface

uses Messages, Windows, KOL;


const
  WM_CPL_LAUNCH   = (WM_USER+1000);
  WM_CPL_LAUNCHED = (WM_USER+1001);

  // The messages CPlApplet() must handle:
  CPL_DYNAMIC_RES = 0;
  { This constant may be used in place of real resource IDs for the idIcon,
    idName or idInfo members of the CPLINFO structure.  Normally, the system
    uses these values to extract copies of the resources and store them in a
    cache.  Once the resource information is in the cache, the system does not
    need to load a CPL unless the user actually tries to use it.

    CPL_DYNAMIC_RES tells the system not to cache the resource, but instead to
    load the CPL every time it needs to display information about an item.  This
    allows a CPL to dynamically decide what information will be displayed, but
    is SIGNIFICANTLY SLOWER than displaying information from a cache.
    Typically, CPL_DYNAMIC_RES is used when a control panel must inspect the
    runtime status of some device in order to provide text or icons to display.
  }
  
  CPL_INIT = 1;
  { This message is sent to indicate CPlApplet() was found. lParam1 and lParam2
    are not defined. Return TRUE or FALSE indicating whether the control panel
    should proceed.
  }
  
  CPL_GETCOUNT = 2;
  { This message is sent to determine the number of applets to be displayed.
    lParam1 and lParam2 are not defined. Return the number of applets you wish
    to display in the control
    panel window.
  }

  CPL_INQUIRE = 3;
  { This message is sent for information about each applet. lParam1 is the
    applet number to register, a value from 0 to(CPL_GETCOUNT - 1).
    lParam2 is a far ptr to a CPLINFO structure. Fill in CPL_INFO's idIcon,
    idName, idInfo and lData fields with the resource id for an icon to
    display, name and description string ids, and a long data item
    associated with applet #lParam1.
  }
  
  CPL_SELECT = 4;
  { This message is sent when the applet's icon has been clicked upon.
    lParam1 is the applet number which was selected.  lParam2 is the
    applet's lData value.
  }
  
  CPL_DBLCLK = 5;
  { This message is sent when the applet's icon has been double-clicked
    upon.  lParam1 is the applet number which was selected.  lParam2 is the
    applet's lData value. This message should initiate the applet's dialog box.
  }
  
  CPL_STOP = 6;
  { This message is sent for each applet when the control panel is exiting.
    lParam1 is the applet number.  lParam2 is the applet's lData  value.
    Do applet specific cleaning up here.
  }
  
  CPL_EXIT = 7;
  { This message is sent just before the control panel calls FreeLibrary.
    lParam1 and lParam2 are not defined.
    Do non-applet specific cleaning up here.
  }
  
  CPL_NEWINQUIRE = 8;
  { This is the same as CPL_INQUIRE execpt lParam2 is a pointer to a
    NEWCPLINFO structure.  this will be sent before the CPL_INQUIRE
    and if it is responed to (return != 0) CPL_INQUIRE will not be sent
  }

  CPL_STARTWPARMS = 9;
  { This message parallels CPL_DBLCLK in that the applet should initiate
    its dialog box.  where it differs is that this invocation is coming
    out of RUNDLL, and there may be some extra directions for execution.
    lParam1: the applet number.
    lParam2: an LPSTR to any extra directions that might exist.
    returns: TRUE if the message was handled; FALSE if not.
  }
  
  CPL_SETUP = 200;
  { This message is internal to the Control Panel and MAIN applets.
    It is only sent when an applet is invoked from the Command line
    during system installation.
  }

type
    TKOLCPLProject = Pointer;
 {
  //The data structure CPlApplet() must fill in.
  PCPLInfo = ^TCPLInfo;
  tagCPLINFO = packed record
     idIcon: Integer;  // icon resource id, provided by CPlApplet()
     idName: Integer;  // name string res. id, provided by CPlApplet()
     idInfo: Integer;  // info string res. id, provided by CPlApplet()
     lData : Longint;  // user defined data
  end;


  CPLINFO = tagCPLINFO;
  TCPLInfo = tagCPLINFO;
  }

  PNewCPLInfoA = ^TNewCPLInfoA;
  PNewCPLInfo = PNewCPLInfoA;
  tagNEWCPLINFOA = packed record
    dwSize:        DWORD;   // similar to the commdlg
    dwFlags:       DWORD;
    dwHelpContext: DWORD;   // help context to use
    lData:         Longint; // user defined data
    hIcon:         HICON;   // icon to use, this is owned by CONTROL.EXE (may be deleted)
    szName:        array[0..31] of AnsiChar;    // short name
    szInfo:        array[0..63] of AnsiChar;    // long name (status line)
    szHelpFile:    array[0..127] of AnsiChar;   // path to help file to use
  end;

  tagNEWCPLINFO = tagNEWCPLINFOA;
  NEWCPLINFOA = tagNEWCPLINFOA;
  NEWCPLINFO = NEWCPLINFOA;
  TNewCPLInfoA = tagNEWCPLINFOA;
  TNewCPLInfo = TNewCPLInfoA;


  TCPLExit = procedure of object;
  {*}
  TCPLInit = procedure (var Initiate : Boolean) of object;
  {*}
  TCPLSel = procedure (Number : Longint; Data : Longint) of object;
  {*}
  TCPLParams = procedure (Number : Longint; Params : PChar; var Handle : Boolean) of object;
  {*}
  TCPLStart = procedure (Number : Longint; var NewCPLInfo: TNewCPLInfo) of object;
  {*}



  PKOLCPLApplet =^TKOLCPLApplet;
  TKOLCPLApplet = object(TObj)
  {*}
  private
    fOnInit : TCPLInit;
    fOnSelect,fOnExecute,fOnStop : TCPLSel;
    fOnStart : TCPLStart;
    fOnParams : TCPLParams;
    fOnExit : TCPLExit;
    fIconList : PList;
  protected
  public
  destructor Destroy;virtual;
  {*}
  procedure AddIcon(IconRes,Name,InfoTip,Help : String; Data,HelpCtx : Integer);
  {* Adds applet (icon,necessary name,description,name of help file
  and help context and simple data sent to applet) to internal object applet's list}
  property IconList : PList read fIconList write fIconList;
  {* Low level access to applets list}
  property OnInit : TCPLInit read fOnInit write fOnInit;
  {* Initialize ALL applets. If Initiate = False applets are not loaded}
  property OnSelect : TCPLSel read fOnSelect write fOnSelect;
  {* Seems not working at all (CPL_SELECT is not invoked by system)}
  property OnExecute : TCPLSel read fOnExecute write fOnExecute;
  {* When user double-click applet icon}
  property OnStart : TCPLStart read fOnStart write fOnStart;
  {* After applet icon is created}
  property OnStop : TCPLSel read fOnStop write fOnStop;
  {* Put applet cleaning here }
  property OnParams : TCPLParams read fOnParams write fOnParams;
  {* When applet is invoked by rundll with params}
  property OnExit: TCPLExit read fOnExit write fOnExit;
  {* Just before control panel detach applet's library }
  end;


  function  NewCPLApplet: PKOLCPLApplet;
  function Run(hWndCpl: HWnd; Msg: Word; lParam: longint; var NewCPLInfo: TNewCPLInfo): longint;stdcall;

var
 CplObj : PKOLCPLApplet;


implementation

destructor TKOLCPLApplet.Destroy;
var
 CPLInfo : PNewCPLInfo;
 i : Integer;
begin
    for i:=0 to fIconList.Count-1 do begin
    CPLInfo := PNewCPLInfo(fIconList.Items[i]);
//    DestroyIcon(CPLInfo.hIcon);
    Dispose(CPLInfo);
    fIconList.Delete(i);
    end;
 fIconList.Free;
 inherited;
end;

procedure TKOLCPLApplet.AddIcon(IconRes,Name,InfoTip,Help : String; Data,HelpCtx : Integer);
var
 CPLInfo : PNewCPLInfo;
begin
  New(CPLInfo);
  with CPLInfo^ do begin
    dwSize  := sizeof(TNewCPLInfo);
    dwFlags := 0;
    dwHelpContext := HelpCtx;
    lData := Data;
    hIcon := LoadIcon(hInstance,PChar(UpperCase(IconRes)));
    StrPCopy(szName,Name);
    StrPCopy(szInfo,InfoTip);
    StrPCopy(szHelpFile,Help);
  end;
  fIconList.Add(CPLInfo);
 end;



function  NewCPLApplet;
begin
   New(Result, Create);
   CplObj := Result;
   Result.fIconList := NewList;
end;

function Run(hWndCpl: HWnd; Msg: Word; lParam: longint; var NewCPLInfo: TNewCPLInfo): longint;stdcall;
var
    i : Boolean;
    CPLInfo : PNewCPLInfo;

begin

 Result := 0;

 case msg of
  CPL_INIT: begin
    i := True;
    Applet := NewApplet('');
    Applet.Visible := False;
    if Assigned(CplObj.OnInit) then CplObj.OnInit(i);
    Result := Integer(i);
   end;

  CPL_GETCOUNT:
  begin
  Result := CplObj.fIconList.Count;
  end;


  CPL_NEWINQUIRE:begin
  CPLInfo := PNewCPLInfo(CplObj.fIconList.Items[lParam]);
  NewCPLInfo.dwSize  := sizeof(TNewCPLInfo);
  NewCPLInfo.dwFlags := 0;
  NewCPLInfo.dwHelpContext := CPLInfo.dwHelpContext;
  NewCPLInfo.lData := CPLInfo.lData;
  NewCPLInfo.hIcon := CPLInfo.hIcon;
  StrCopy(NewCPLInfo.szName,CPLInfo.szName);
  StrCopy(NewCPLInfo.szInfo,CPLInfo.szInfo);
  StrCopy(NewCPLInfo.szHelpFile,CPLInfo.szHelpFile);
  if Assigned(CplObj.OnStart) then CplObj.OnStart(lParam,NewCPLInfo);
  end;

  CPL_STARTWPARMS:begin
  i := True;
  if Assigned(CplObj.OnParams) then
    CplObj.OnParams(lParam,PChar(@NewCPLInfo),i);
  Result := Integer(i);
  end;

  CPL_DBLCLK:
  if Assigned(CplObj.OnExecute) then
    CplObj.OnExecute(lParam,Longint(@NewCPLInfo));


  CPL_SELECT:
  if Assigned(CplObj.OnSelect) then
    CplObj.OnSelect(lParam,Longint(@NewCPlInfo));

  CPL_STOP:
  if Assigned(CplObj.OnStop) then
    CplObj.OnStop(lParam,Longint(@NewCPlInfo));


  CPL_EXIT:
  begin
  if Assigned(CplObj.OnExit) then CplObj.OnExit;
  Applet.Free;
  end;


 end;
end;


end.
