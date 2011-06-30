unit KOLMHHeaderControl;
//  MHHeaderControl Компонент (MHHeaderControl Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 17-апр(apr)-2002
//  Дата коррекции (Last correction Date): 15-фев(feb)-2003
//  Версия (Version): 0.5
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Alexander Pravdin
//  Новое в (New in):
//  V0.5
//  [+++] Много чего, теперь реально полезен (Very much, realy usefull now) [KOLnMCK]
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V0.12
//  [+] Поддержка D6 (D6 Support) <Thanks to Alexander Pravdin> [KOLnMCK]
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Подчистить (Clear Stuff)
//  4. Ошибки (Errors)

interface
uses
  KOL, Windows, Messages;

type
  TTrackBarOrientation = (trHorizontal, trVertical);
  TTickMark = (tmBottomRight, tmTopLeft, tmBoth);
  TTickStyle = (tsNone, tsAuto, tsManual);

  RClearField = record
    UpRange: Byte;
    DownRange: Byte;
  end;

  TFieldFocusRange = 0..3;

  PMHHeaderSection = ^TMHHeaderSection;
  TKOLMHHeaderSection = PMHHeaderSection;

  PMHHeaderSections = ^TMHHeaderSections;
  TKOLMHHeaderSections = PMHHeaderSections;

  PMHHeaderControl = ^TMHHeaderControl;

  THeaderSectionSortStyle=(ssNone,ssDown,ssUp);

  TMHHeaderSection = object(TObj)
  private
    FIndex: Integer;
    FHeaderSections: PMHHeaderSections;
    FHeight: Integer;
    procedure SetText(const Value: string);
    function GetText(): string;
    function GetWidth: Integer;
    procedure SetWidth(const Value: Integer);
//    procedure SetHeight(const Value: Integer);
//    function GetHeight: Integer;
    function GetTextAlign: TTextAlign;
    procedure SetTextAlign(const Value: TTextAlign);
    function GetSortStyle: THeaderSectionSortStyle;
    procedure SetSortStyle(const Value: THeaderSectionSortStyle);
  public
    property SortStyle:THeaderSectionSortStyle read GetSortStyle write SetSortStyle;
    property Text: string read GetText write SetText;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetWidth write SetWidth;//read GetHeight write SetHeight;
    property TextAlign: TTextAlign read GetTextAlign write SetTextAlign;
  end;


  TMHHeaderSections = object(TObj) //TList)
  private
    FItems: array of PMHHeaderSection;
    FHeaderControl: PMHHeaderControl;
    function GetItem(Index: Integer): PMHHeaderSection;
    procedure SetItem(Index: Integer; Value: PMHHeaderSection);
    function GetCount: Integer;
  protected
//    function GetOwner: TPersistent; override;
//    procedure Update(Item: TCollectionItem); override;
  public
//    constructor Create(HeaderControl: TCustomHeaderControl);
    property Count:Integer read GetCount;
    function Add: PMHHeaderSection;
    function AddItem(Item: PMHHeaderSection; Index: Integer): PMHHeaderSection;
    function Insert(Index: Integer): PMHHeaderSection;
    property Items[Index: Integer]: PMHHeaderSection read GetItem write SetItem; default;
  end;

  THeaderOption=(hoButtons,hoDragDrop,hoFilterBar,hoFlat,hoFullDrag,hoHidden,hoHorz,hoHotTrack);
  THeaderOptions=set of THeaderOption;

  TKOLMHHeaderControl = PMHHeaderControl; //PControl;
  TMHHeaderControl = object(TControl) //TObj)
  private
    function GetSections: PMHHeaderSections;
    procedure SetSections(const Value: PMHHeaderSections);
    function GetOptions: THeaderOptions;
    procedure SetOptions(const Value: THeaderOptions);



{     function GetLeft:Integer;
     procedure SetLeft(const Value:Integer);
     function GetTop:Integer;
     procedure SetTop(const Value:Integer);
     function GetWidth:Integer;
     procedure SetWidth(const Value:Integer);
     function GetHeight:Integer;
     procedure SetHeight(const Value:Integer);}
   {  function GetCursor:HCursor;
     procedure SetCursor(const Value:HCursor);

     procedure SetVisible(const Value: Boolean );
     function GetVisible: Boolean;

     procedure SetOnScroll(const Value: TOnScroll);
     function GetOnScroll:TOnScroll;

     procedure SetOnKeyUp(const Value: TOnKey);
     function GetOnKeyUp:TOnKey;

     procedure SetOnKeyDown(const Value: TOnKey);
     function GetOnKeyDown:TOnKey;


     procedure SetOnMove(const Value: TOnEvent);
     function GetOnMove:TOnEvent;


     }
{     procedure SetOnEnter(const Value: TOnEvent);
     function GetOnEnter:TOnEvent;

     procedure SetOnLeave(const Value: TOnEvent);
     function GetOnLeave:TOnEvent;}
{
       procedure SetOnHide(const Value: TOnEvent);
       function GetOnHide:TOnEvent;

       procedure SetOnShow(const Value: TOnEvent);
       function GetOnShow:TOnEvent;}

      { procedure SetOnMouseMove(const Value:TOnMouse);
       function GetOnMouseMove:TOnMouse;

       procedure SetOnMouseUp(const Value:TOnMouse);
       function GetOnMouseUp:TOnMouse;

       procedure SetOnMouseDown(const Value:TOnMouse);
       function GetOnMouseDown:TOnMouse;

//       procedure SetOnMouseDblClk(const Value:TOnMouse);
//       function GetOnMouseDblClk:TOnMouse;

       procedure SetOnMouseWheel(const Value:TOnMouse);
       function GetOnMouseWheel:TOnMouse;

       procedure SetOnMouseEnter(const Value:TOnEvent);
       function GetOnMouseEnter:TOnEvent;

       procedure SetOnMouseLeave(const Value:TOnEvent);
       function GetOnMouseLeave:TOnEvent;

       procedure SetOnMessage(const Value:TOnMessage);
       function GetOnMessage:TOnMessage;

//       procedure SetOnClick(const Value: TOnEvent);
//       function GetOnClick:TOnEvent;

       procedure SetOnResize(const Value:TOnEvent);
       function GetOnResize:TOnEvent;

       procedure SetOnDropFiles(const Value:TOnDropFiles);
       function GetOnDropFiles:TOnDropFiles;

       procedure SetOnPaint(const Value:TOnPaint);
       function GetOnPaint:TOnPaint;

       procedure SetOnChar(const Value: TOnChar);
       function GetOnChar:TOnChar;}
  public


    property Options: THeaderOptions read GetOptions write SetOptions;

    property Sections: PMHHeaderSections read GetSections write SetSections;

{    property Cursor: HCursor read GetCursor write SetCursor;

    property Visible: Boolean read GetVisible write SetVisible;

    property OnScroll:TOnScroll read GetOnScroll write SetOnScroll;
    property OnKeyDown: TOnKey read GetOnKeyDown write SetOnKeyDown;
    property OnKeyUp: TOnKey read GetOnKeyUp write SetOnKeyUp;
//    property OnShow: TOnEvent read GetOnShow write SetOnShow;
//    property OnHide: TOnEvent read GetOnHide write SetOnHide;
    property OnMove: TOnEvent read GetOnMove write SetOnMove;
    property OnMouseMove: TOnMouse read GetOnMouseMove write SetOnMouseMove;
//    property OnEnter: TOnEvent read GetOnEnter write SetOnEnter;
//    property OnLeave: TOnEvent read GetOnLeave write SetOnLeave;
    property OnMessage: TOnMessage read GetOnMessage write SetOnMessage;
//    property OnClick: TOnEvent read GetOnClick write SetOnClick;

    property OnMouseDown: TOnMouse read GetOnMouseDown write SetOnMouseDown;
    property OnMouseUp: TOnMouse read GetOnMouseUp write SetOnMouseUp;
//    property OnMouseDblClk: TOnMouse read GetOnMouseDblClk write SetOnMouseDblClk;
    property OnMouseWheel: TOnMouse read GetOnMouseWheel write SetOnMouseWheel;
    property OnMouseEnter: TOnEvent read GetOnMouseEnter write SetOnMouseEnter;
    property OnMouseLeave: TOnEvent read GetOnMouseLeave write SetOnMouseLeave;
    property OnResize: TOnEvent read GetOnResize write SetOnResize;
    property OnDropFiles: TOnDropFiles read GetOnDropFiles write SetOnDropFiles;
    property OnPaint: TOnPaint read GetOnPaint write SetOnPaint;
    property OnChar: TOnChar read GetOnChar write SetOnChar;}
  end;

  PHeaderControlData = ^THeaderControlData;
  THeaderControlData = packed record
    FSections: PMHHeaderSections;
  end;

const
  WC_HEADER = 'SysHeader32';

  HDM_FIRST = $1200; { Header messages }
  CCM_FIRST = $2000; { Common control shared messages }
  CCM_GETDROPTARGET = CCM_FIRST + 4;
  CCM_SETUNICODEFORMAT = CCM_FIRST + 5;
  CCM_GETUNICODEFORMAT = CCM_FIRST + 6;
  HDN_FIRST = 0 - 300; { header }
  HDN_LAST = 0 - 399;

  HDS_HORZ = $00000000;
  HDS_BUTTONS = $00000002;
  HDS_HOTTRACK = $00000004;
  HDS_HIDDEN = $00000008;
  HDS_DRAGDROP = $00000040;
  HDS_FULLDRAG = $00000080;

type
  PHDItemA = ^THDItemA;
  PHDItemW = ^THDItemW;
  PHDItem = PHDItemA;

  _HD_ITEMA = packed record
    Mask: Cardinal;
    cxy: Integer;
    pszText: PAnsiChar;
    hbm: HBITMAP;
    cchTextMax: Integer;
    fmt: Integer;
    lParam: LPARAM;
    iImage: Integer; // index of bitmap in ImageList
    iOrder: Integer; // where to draw this item
  end;

  _HD_ITEMW = packed record
    Mask: Cardinal;
    cxy: Integer;
    pszText: PWideChar;
    hbm: HBITMAP;
    cchTextMax: Integer;
    fmt: Integer;
    lParam: LPARAM;
    iImage: Integer; // index of bitmap in ImageList
    iOrder: Integer; // where to draw this item
  end;

  _HD_ITEM = _HD_ITEMA;
  THDItemA = _HD_ITEMA;
  THDItemW = _HD_ITEMW;
  THDItem = THDItemA;
  HD_ITEMA = _HD_ITEMA;
  HD_ITEMW = _HD_ITEMW;
  HD_ITEM = HD_ITEMA;

const
  HDI_WIDTH = $0001;
  HDI_HEIGHT = HDI_WIDTH;
  HDI_TEXT = $0002;
  HDI_FORMAT = $0004;
  HDI_LPARAM = $0008;
  HDI_BITMAP = $0010;
  HDI_IMAGE = $0020;
  HDI_DI_SETITEM = $0040;
  HDI_ORDER = $0080;

  HDF_LEFT = 0;
  HDF_RIGHT = 1;
  HDF_CENTER = 2;
  HDF_JUSTIFYMASK = $0003;
  HDF_RTLREADING = 4;

  HDF_OWNERDRAW = $8000;
  HDF_STRING = $4000;
  HDF_BITMAP = $2000;
  HDF_BITMAP_ON_RIGHT = $1000;
  HDF_IMAGE = $0800;

  HDM_GETITEMCOUNT = HDM_FIRST + 0;

//function Header_GetItemCount(Header: HWnd): Integer;

//const
  HDM_INSERTITEMW = HDM_FIRST + 10;
  HDM_INSERTITEMA = HDM_FIRST + 1;

  HDM_INSERTITEM = HDM_INSERTITEMA;


//function Header_InsertItem(Header: HWnd; Index: integer; const Item: THDItem): integer;

//const
  HDM_DELETEITEM = HDM_FIRST + 2;

//function Header_DeleteItem(Header: HWnd; Index: integer): boolean;

//const
  HDM_GETITEMW = HDM_FIRST + 11;
  HDM_GETITEMA = HDM_FIRST + 3;


  HDM_GETITEM = HDM_GETITEMA;


//function Header_GetItem(Header: HWnd; Index: integer; var Item: THDItem): boolean;

//const
  HDM_SETITEMA = HDM_FIRST + 4;
  HDM_SETITEMW = HDM_FIRST + 12;
  HDM_SETITEM = HDM_SETITEMA;
//function Header_SetItem(Header: HWnd; Index: integer; const Item: THDItem): Boolean;

type
  PHDLayout = ^THDLayout;
  _HD_LAYOUT = packed record
    Rect: ^TRect;
    WindowPos: PWindowPos;
  end;
  THDLayout = _HD_LAYOUT;
  HD_LAYOUT = _HD_LAYOUT;

const
  HDM_LAYOUT = HDM_FIRST + 5;

//function Header_Layout(Header: HWnd; Layout: PHDLayout): Boolean;

//const
  HHT_NOWHERE = $0001;
  HHT_ONHEADER = $0002;
  HHT_ONDIVIDER = $0004;
  HHT_ONDIVOPEN = $0008;
  HHT_ABOVE = $0100;
  HHT_BELOW = $0200;
  HHT_TORIGHT = $0400;
  HHT_TOLEFT = $0800;

type
  PHDHitTestInfo = ^THDHitTestInfo;
  _HD_HITTESTINFO = packed record
    Point: TPoint;
    Flags: Cardinal;
    Item: Integer;
  end;
  THDHitTestInfo = _HD_HITTESTINFO;
  HD_HITTESTINFO = _HD_HITTESTINFO;

const
  HDM_HITTEST = HDM_FIRST + 6;
  HDM_GETITEMRECT = HDM_FIRST + 7;
  HDM_SETIMAGELIST = HDM_FIRST + 8;
  HDM_GETIMAGELIST = HDM_FIRST + 9;
  HDM_ORDERTOINDEX = HDM_FIRST + 15;
  HDM_CREATEDRAGIMAGE = HDM_FIRST + 16; // wparam = which item = by index;
  HDM_GETORDERARRAY = HDM_FIRST + 17;
  HDM_SETORDERARRAY = HDM_FIRST + 18;
  HDM_SETHOTDIVIDER = HDM_FIRST + 19;
  HDM_SETUNICODEFORMAT = CCM_SETUNICODEFORMAT;
  HDM_GETUNICODEFORMAT = CCM_GETUNICODEFORMAT;

{function Header_GetItemRect(hwnd: HWND; Item: integer; lprc: PRect): integer;
function Header_SetImageList(hwnd: HWND; himl: THandle): THandle;
function Header_GetImageList(hwnd: HWND): THandle;
function Header_OrderToIndex(hwnd: HWND; I: integer): integer;
function Header_CreateDragImage(hwnd: HWND; I: integer): THandle;
function Header_GetOrderArray(hwnd: HWND; Count: integer; lpi: PInteger): integer;
function Header_SetOrderArray(hwnd: HWND; Count: integer; lpi: PInteger): integer;
 }
// lparam = int array of size HDM_GETITEMCOUNT
// the array specifies the order that all items should be displayed.
// e.g.  { 2, 0, 1}
// says the index 2 item should be shown in the 0ths position
//      index 0 should be shown in the 1st position
//      index 1 should be shown in the 2nd position

//function Header_SetHotDivider(hwnd: HWND; fPos: boolean; dw: DWORD): integer;

// convenience message for external dragdrop
// wParam = BOOL  specifying whether the lParam is a dwPos of the cursor
//              position or the index of which divider to hotlight
// lParam = depends on wParam  (-1 and wParm = FALSE turns off hotlight)

//function Header_SetUnicodeFormat(hwnd: HWND; fUnicode: boolean): integer;
//function Header_GetUnicodeFormat(hwnd: HWND): integer;

const
  HDN_ITEMCHANGINGA = HDN_FIRST - 0;
  HDN_ITEMCHANGEDA = HDN_FIRST - 1;
  HDN_ITEMCLICKA = HDN_FIRST - 2;
  HDN_ITEMDBLCLICKA = HDN_FIRST - 3;
  HDN_DIVIDERDBLCLICKA = HDN_FIRST - 5;
  HDN_BEGINTRACKA = HDN_FIRST - 6;
  HDN_ENDTRACKA = HDN_FIRST - 7;
  HDN_TRACKA = HDN_FIRST - 8;
  HDN_GETDISPINFOA = HDN_FIRST - 9;
  HDN_BEGINDRAG = HDN_FIRST - 10;
  HDN_ENDDRAG = HDN_FIRST - 11;

  HDN_ITEMCHANGINGW = HDN_FIRST - 20;
  HDN_ITEMCHANGEDW = HDN_FIRST - 21;
  HDN_ITEMCLICKW = HDN_FIRST - 22;
  HDN_ITEMDBLCLICKW = HDN_FIRST - 23;
  HDN_DIVIDERDBLCLICKW = HDN_FIRST - 25;
  HDN_BEGINTRACKW = HDN_FIRST - 26;
  HDN_ENDTRACKW = HDN_FIRST - 27;
  HDN_TRACKW = HDN_FIRST - 28;
  HDN_GETDISPINFOW = HDN_FIRST - 29;

  HDN_ITEMCHANGING = HDN_ITEMCHANGINGA;
  HDN_ITEMCHANGED = HDN_ITEMCHANGEDA;
  HDN_ITEMCLICK = HDN_ITEMCLICKA;
  HDN_ITEMDBLCLICK = HDN_ITEMDBLCLICKA;
  HDN_DIVIDERDBLCLICK = HDN_DIVIDERDBLCLICKA;
  HDN_BEGINTRACK = HDN_BEGINTRACKA;
  HDN_ENDTRACK = HDN_ENDTRACKA;
  HDN_TRACK = HDN_TRACKA;
  HDN_GETDISPINFO = HDN_GETDISPINFOA;


type
  tagNMHEADERA = packed record
    Hdr: TNMHdr;
    Item: Integer;
    Button: Integer;
    PItem: PHDItemA;
  end;
  tagNMHEADERW = packed record
    Hdr: TNMHdr;
    Item: Integer;
    Button: Integer;
    PItem: PHDItemW;
  end;
  tagNMHEADER = tagNMHEADERA;
  HD_NOTIFYA = tagNMHEADERA;
  HD_NOTIFYW = tagNMHEADERW;
  HD_NOTIFY = HD_NOTIFYA;
  PHDNotifyA = ^THDNotifyA;
  PHDNotifyW = ^THDNotifyW;
  PHDNotify = PHDNotifyA;
  THDNotifyA = tagNMHEADERA;
  THDNotifyW = tagNMHEADERW;
  THDNotify = THDNotifyA;

  tagNMHDDISPINFOA = packed record
    hdr: TNMHdr;
    iItem: Integer;
    mask: UINT;
    pszText: PAnsiChar;
    cchTextMax: Integer;
    iImage: Integer;
    lParam: LPARAM;
  end;
  tagNMHDDISPINFOW = packed record
    hdr: TNMHdr;
    iItem: Integer;
    mask: UINT;
    pszText: PWideChar;
    cchTextMax: Integer;
    iImage: Integer;
    lParam: LPARAM;
  end;
  tagNMHDDISPINFO = tagNMHDDISPINFOA;
  PNMHDispInfoA = ^TNMHDispInfoA;
  PNMHDispInfoW = ^TNMHDispInfoW;
  PNMHDispInfo = PNMHDispInfoA;
  TNMHDispInfoA = tagNMHDDISPINFOA;
  TNMHDispInfoW = tagNMHDDISPINFOW;
  TNMHDispInfo = TNMHDispInfoA;


function NewMHHeaderSection(AHeaderSections: PMHHeaderSections; AIndex: Integer): PMHHeaderSection;
function NewMHHeaderSections(AHeaderControl: PMHHeaderControl): PMHHeaderSections;
function NewMHHeaderControl(AParent: PControl {; Left,Top,Width,Height:Integer}): PMHHeaderControl; //PControl;


implementation

const
  HDS_FILTERBAR=0;
  HDS_FLAT=0;
  HeaderOptions:array [THeaderOption] of Integer=(HDS_BUTTONS,HDS_DRAGDROP ,HDS_FILTERBAR ,HDS_FLAT ,HDS_FULLDRAG ,HDS_HIDDEN ,HDS_HORZ ,HDS_HOTTRACK );


{function WndProcTrackBar( Control: PControl; var Msg: TMsg; var Rslt: Integer ) : Boolean;
var Bar: TScrollerBar;
begin
  Bar := sbHorizontal; //0
  if Msg.message = WM_VSCROLL then
    Bar := sbVertical
  else
  if Msg.message <> WM_HSCROLL then
  begin
    Result := FALSE;
    Exit;
  end;

  if Assigned( Control.OnScroll ) then
    Control.OnScroll( Control, Bar, LoWord( Msg.wParam ), HiWord( Msg.wParam ) );
  Result := FALSE;
end;
 }
{function WndProcMHFontDialog( Control: PControl; var Msg: TMsg; var Rslt: Integer ) : Boolean;
begin
  Result:=False;
  if Msg.message=HelpMessageIndex then
  begin
    if Assigned( MHFontDialogNow.FOnHelp ) then
      MHFontDialogNow.FOnHelp( @MHFontDialogNow);
    Rslt:=0;
    Result:=True;
  end;
end;

function NewMHFontDialog(Wnd: PControl):PMHFontDialog;
begin
  New(Result, Create);
  Result.FControl:=Wnd;
  Result.Font:=NewFont;
  Result.FInitFont :=NewFont;
  Wnd.AttachProc(WndProcMHFontDialog);
end;}


function NewMHHeaderSection(AHeaderSections: PMHHeaderSections; AIndex: Integer): PMHHeaderSection;
var
  tmp: THDItem;
begin
  tmp.mask :=HDI_FORMAT or HDI_TEXT or HDI_WIDTH;
  tmp.fmt := HDF_STRING or HDF_LEFT;
  tmp.pszText := PChar('');//'Items'+Int2Str(AIndex));
  tmp.cchTextMax := Length('');//'Items'+Int2Str(AIndex));
  tmp.cxy:=50;
  New(Result, Create);
  with Result^ do
  begin
    FIndex := AIndex;
    FHeaderSections := AHeaderSections;
    SendMessage(FHeaderSections.FHeaderControl.handle, HDM_INSERTITEM, FIndex, DWord(@tmp));
  end;
end;

function NewMHHeaderSections(AHeaderControl: PMHHeaderControl): PMHHeaderSections;
begin
  New(Result, Create);
  Result.FHeaderControl := AHeaderControl;
end;


function NewMHHeaderControl(AParent: PControl): PMHHeaderControl;
var
  Data: PHeaderControlData;
begin
  Result := PMHHeaderControl(_NewCommonControl(AParent, WC_HEADER, WS_CHILD or WS_VISIBLE{ or HDS_BUTTONS}, False, 0));

  GetMem(Data, Sizeof(Data^));
  FillChar(Data^, Sizeof(Data^), 0);
  Result.CustomData := Data;

//  P.FMHHeaderControl.CreateWindow;
//  InitCommonControlCommonNotify(P.FMHHeaderControl);
//  P.FMHHeaderControl.Left:=Left;
//  P.FMHHeaderControl.Top:=Top;
//  P.FMHHeaderControl.Width:=Width;
//  P.FMHHeaderControl.Height:=Height;
//  Result:=P;
end;




function TMHHeaderControl.GetSections: PMHHeaderSections;
var
  Data: PHeaderControlData;
begin
  Data := CustomData;
  Result := Data.FSections;
  if Result = nil then
    Data.FSections := NewMHHeaderSections(@Self);
  Result := Data.FSections;
end;

procedure TMHHeaderControl.SetSections(const Value: PMHHeaderSections);
var
  Data: PHeaderControlData;
begin
  Data := CustomData;
 // Result:=Data.FSections;
end;

{ TMHHeaderSections }

function TMHHeaderSections.Add: PMHHeaderSection;
begin
  if Length(FItems)>=Count then
    SetLength(FItems,Count+1);
  FItems[Count-1] :=NewMHHeaderSection(@Self, Count);
//  inherited Add(NewMHHeaderSection(@Self));
end;

function TMHHeaderSections.AddItem(Item: PMHHeaderSection;
  Index: Integer): PMHHeaderSection;
begin

end;

function TMHHeaderSections.GetCount: Integer;
begin
  Result:=SendMessage(FHeaderControl.handle, HDM_GETITEMCOUNT, 0, 0);
end;

function TMHHeaderSections.GetItem(Index: Integer): PMHHeaderSection;
begin
  Result := FItems[Index];
end;

function TMHHeaderSections.Insert(Index: Integer): PMHHeaderSection;
begin
  if Length(FItems)>=Count then
    SetLength(FItems,Count+1);
  FItems[Count-1] :=NewMHHeaderSection(@Self, Index);
end;

procedure TMHHeaderSections.SetItem(Index: Integer;
  Value: PMHHeaderSection);
begin
  // ???
end;

{ TMHHeaderSection }

{function TMHHeaderSection.GetHeight: Integer;
var
  tmp: THDItem;
begin
  tmp.mask := HDI_HEIGHT;
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_GETITEM, FIndex, DWord(@tmp));
  Result := tmp.cxy;
end;
 }
function TMHHeaderSection.GetSortStyle: THeaderSectionSortStyle;
var
  tmp: THDItem;
begin
  tmp.mask := HDI_FORMAT;
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_GETITEM, FIndex, DWord(@tmp));
  Result := THeaderSectionSortStyle(tmp.fmt shr 8);
end;

function TMHHeaderSection.GetText: string;
var
  tmp: THDItem;
begin
  tmp.mask := HDI_TEXT;
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_GETITEM, FIndex, DWord(@tmp));
  Result := tmp.pszText;
end;

function TMHHeaderSection.GetTextAlign: TTextAlign;
var
  tmp: THDItem;
begin
  tmp.mask := HDI_FORMAT;
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_GETITEM, FIndex, DWord(@tmp));
  Result := TTextAlign(tmp.fmt and HDF_JUSTIFYMASK);
end;

function TMHHeaderSection.GetWidth: Integer;
var
  tmp: THDItem;
begin
  tmp.mask := HDI_WIDTH;
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_GETITEM, FIndex, DWord(@tmp));
  Result := tmp.cxy;
end;

{procedure TMHHeaderSection.SetHeight(const Value: Integer);
var
  tmp: THDItem;
begin
  tmp.mask := HDI_HEIGHT;
  tmp.cxy := Value;
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_SETITEM, FIndex, DWord(@tmp));
end;
 }
procedure TMHHeaderSection.SetSortStyle(
  const Value: THeaderSectionSortStyle);
var
  tmp: THDItem;
begin
  tmp.mask := HDI_FORMAT;
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_GETITEM, FIndex, DWord(@tmp));
//  tmp.mask := HDI_FORMAT;
  tmp.fmt:=tmp.fmt or DWord(Value);
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_SETITEM, FIndex, DWord(@tmp));
end;

procedure TMHHeaderSection.SetText(const Value: string);
var
  tmp: THDItem;
begin
  tmp.mask := HDI_TEXT;
  tmp.pszText := PChar(Value);
  tmp.cchTextMax := Length(Value);
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_SETITEM, FIndex, DWord(@tmp));
end;

procedure TMHHeaderSection.SetTextAlign(const Value: TTextAlign);
var
  tmp: THDItem;
begin
  tmp.mask := HDI_FORMAT;
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_GETITEM, FIndex, DWord(@tmp));
//  tmp.mask := HDI_FORMAT;
  tmp.fmt:=tmp.fmt and not (HDF_JUSTIFYMASK) or DWord(Value);
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_SETITEM, FIndex, DWord(@tmp));
end;

procedure TMHHeaderSection.SetWidth(const Value: Integer);
var
  tmp: THDItem;
begin
  tmp.mask := HDI_WIDTH;
  tmp.cxy := Value;
  SendMessage(FHeaderSections.FHeaderControl.handle, HDM_SETITEM, FIndex, DWord(@tmp));
end;

function TMHHeaderControl.GetOptions: THeaderOptions;
begin
  Result:=[];
end;

procedure TMHHeaderControl.SetOptions(const Value: THeaderOptions);
var
  Flags:DWORD;
begin
    Flags := MakeFlags(@Value, HeaderOptions);
    Style:=Style or Flags and Flags;
end;

end.

