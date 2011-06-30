unit KOLOleRE;

interface

uses
   Windows, Messages, KOL;

type

  PKOLOleRichEdit =^TKOLOleRichEdit;
  TKOLOleRichEdit = object(TControl)
  protected
     procedure CreateHandle;
     function GetDragOle: boolean;
     procedure SetDragOle(d: boolean);
  public
     destructor Destroy; virtual;
     function BitmapToRTF(pict: PBitmap): string;
     procedure HideFrames;
     property CanDragOle: boolean read GetDragOle write SetDragOle;
  end;

  function NewOLERichEdit( AParent: PControl; Options: TEditOptions ): PKOLOleRichEdit;

implementation

{$B-}
uses
   ActiveX, KOLComObj;

const
   {$EXTERNALSYM EM_GETOLEINTERFACE}
   EM_GETOLEINTERFACE = WM_USER + 60;

type

  _charrange = record
    cpMin: Longint;
    cpMax: LongInt;
  end;

  {$EXTERNALSYM _charrange}
  TCharRange = _charrange;
  CHARRANGE = _charrange;
  {$EXTERNALSYM CHARRANGE}

  TREOBJECT = packed record
    cbStruct: DWORD;			// Size of structure
    cp: longint;					// Character position of object
    clsid: TCLSID;				// Class ID of object
    oleobj: IOleObject;			// OLE object interface
    stg: IStorage;				// Associated storage interface
    olesite: IOLEClientSite;			// Associated client site interface
    sizel: TSize;				// Size of object (may be 0,0)
    dvaspect: DWORD;			// Display aspect to use
    dwFlags: DWORD;			// Object status flags
    dwUser: DWORD;				// Dword for user's use
  end;

  IRichEditOle = interface(IUnknown)
    ['{00020D00-0000-0000-C000-000000000046}']
    function GetClientSite(out lplpolesite: IOLECLIENTSITE): HResult; stdcall;
    function GetObjectCount: longint; stdcall;
    function GetLinkCount: longint; stdcall;
    function GetObject(iob: longint; out reobject: TREOBJECT; dwFlags: DWORD): HRESULT; stdcall;
    function InsertObject(const reobject: TREOBJECT): HResult; stdcall;
    function ConvertObject(iob: longint; const clsidNew: TCLSID;
       lpStrUserTypeNew: POleStr): HRESULT; stdcall;
    function ActivateAs(const clsid, clsidAs: TCLSID): HRESULT; stdcall;
    function SetHostNames(lpstrContainerApp, lpstrContainerObj: POleStr): HRESULT; stdcall;
    function SetLinkAvailable(iob: longint; fAvailable: BOOL): HRESULT; stdcall;
    function SetDvaspect(iob: longint; dvaspect: DWORD): HRESULT; stdcall;
    function HandsOffStorage(iob: longint): HRESULT; stdcall;
    function SaveCompleted(iob: longint; stg: IStorage): HRESULT; stdcall;
    function InPlaceDeactivate: HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD;
         out dataobj: IDataObject): HRESULT; stdcall;
    function ImportDataObject(dataobj: IDataObject; cf: TClipFormat;
         hMetaPict: HGLOBAL): HRESULT; stdcall;
  end;

  IRichEditOleCallback = interface(IUnknown)
    ['{00020D03-0000-0000-C000-000000000046}']
    function GetNewStorage: IStorage; safecall;
    procedure GetInPlaceContext(out Frame: IOleInPlaceFrame;
      out Doc: IOleInPlaceUIWindow; var FrameInfo: TOleInPlaceFrameInfo); safecall;
    procedure ShowContainerUI(fShow: Bool); safecall;
    procedure QueryInsertObject(const ClsID: TCLSID; Stg: IStorage; CP: Longint); safecall;
    procedure DeleteObject(OleObj: IOleObject); safecall;
    procedure QueryAcceptData(dataobj: IDataObject; var cfFormat: TClipFormat;
      reCO: DWord; fReally: Bool; hMetaPict: HGlobal); safecall;
    function ContextSensitiveHelp(fEnterMode: Bool): HResult; stdcall;
    function GetClipboardData(const ChRg: TCharRange; reCO: DWord; out DataObj: IDataObject): HResult; stdcall;
    procedure GetDragDropEffect(fDrag: Bool; grfKeyState: DWord;
      var dwEffect: DWord); safecall;
    procedure GetContextMenu(SelType: Word; OleObj: IOleObject;
      const ChRg: TCharRange; var Menu: HMenu); safecall;
  end;

  TRichEditOleCallback = class(TInterfacedObject, IRichEditOleCallback)
  private
    FOwner: PKOLOleRichEdit;
  protected
    { IRichEditOleCallback }
    function GetNewStorage: IStorage; safecall;
    procedure GetInPlaceContext(out Frame: IOleInPlaceFrame;
      out Doc: IOleInPlaceUIWindow; var FrameInfo: TOleInPlaceFrameInfo); safecall;
    procedure ShowContainerUI(fShow: Bool); safecall;
    procedure QueryInsertObject(const ClsID: TCLSID; Stg: IStorage; CP: Longint); safecall;
    procedure DeleteObject(OleObj: IOleObject); safecall;
    procedure QueryAcceptData(dataobj: IDataObject; var cfFormat: TClipFormat;
      reCO: DWord; fReally: Bool; hMetaPict: HGlobal); safecall;
    function ContextSensitiveHelp(fEnterMode: Bool): HResult; stdcall;
    function GetClipboardData(const ChRg: TCharRange; reCO: DWord; out DataObj: IDataObject): HResult; stdcall;
    procedure GetDragDropEffect(fDrag: Bool; grfKeyState: DWord;
      var dwEffect: DWord); safecall;
    procedure GetContextMenu(SelType: Word; OleObj: IOleObject;
      const ChRg: TCharRange; var Menu: HMenu); safecall;
  public
    constructor Create(Owner: PKOLOleRichEdit);
    destructor Destroy; override;
  end;

  PData =^TData;
  TData = record
     IOle: IRichEditOle;
     IBck: TRichEditOleCallback;
     Drag: boolean;
  end;

const
  {$EXTERNALSYM EM_SETOLECALLBACK}
  EM_SETOLECALLBACK                   = WM_USER + 70;

function NewOLERichEdit( AParent: PControl; Options: TEditOptions ): PKOLOleRichEdit;
label exit;
var p: PData;
begin
   Result := PKOLOleRichEdit(KOL.NewRichEdit( AParent, Options ));
   new(p);
   FillChar(p^, SizeOf(p^), 0);
   Result.CustomData := p;
   Result.CreateWindow;
   Result.CreateHandle;
   Result.Perform(EM_GETOLEINTERFACE, 0, integer(@p.IOle));

  asm
    MOV   EDX, offset @@new_call + 4
    MOV   EDX, [EDX]
    ADD   EDX, 12
    MOV   [EBX], EDX
    jmp   exit
    @@new_call:
  end;

  new( Result, CreateParented( AParent ) );
  exit:

end;
{$O-}

destructor TKOLOleRichEdit.Destroy;
var //I: TRichEditOleCallback;
    P: PData;
begin
   P := CustomData;
   P.IBck._Release;
   Dispose(P);
   CustomData := nil;
   inherited;
end;
{$O+}

procedure TKOLOleRichEdit.CreateHandle;
var I: IRichEditOleCallback;
    T: TRichEditOleCallback;
    P: PData;
begin
  inherited;
  T := TRichEditOleCallback.Create(@Self);
  I := T as IRichEditOleCallback;
  Perform(em_SetOleCallback, 0, Longint(I));
  P := CustomData;
  P.IBck := T;
end;

{ TRichEditOleCallback }

constructor TRichEditOleCallback.Create(Owner: PKOLOleRichEdit);
begin
  inherited Create;
  FOwner := Owner;
end;

destructor TRichEditOleCallback.Destroy;
//var Form: PControl;
begin
{  Form := GetParentForm(FOwner);}
{  if Assigned(Form) and Assigned(Form.OleFormObject) then
    (Form.OleFormObject as IOleInPlaceUIWindow).SetActiveObject(nil, nil);}
  inherited;
end;

function TRichEditOleCallback.ContextSensitiveHelp(fEnterMode: Bool): HResult;
begin
  Result := E_NOTIMPL
end;

procedure TRichEditOleCallback.DeleteObject(OleObj: IOleObject);
begin
  OleObj.Close(OLECLOSE_NOSAVE);
end;

function TRichEditOleCallback.GetClipboardData(const ChRg: TCharRange; reCO: DWord; out DataObj: IDataObject): HResult;
begin
  Result := E_NOTIMPL;
end;

procedure TRichEditOleCallback.GetContextMenu(SelType: Word;
  OleObj: IOleObject; const ChRg: TCharRange; var Menu: HMenu);
begin
  Menu := 0
end;

procedure TRichEditOleCallback.GetDragDropEffect(fDrag: Bool;
  grfKeyState: DWord; var dwEffect: DWord);
var p: PData;
begin
   if fOwner <> nil then begin
      if fOwner.CustomData <> nil then begin
         p := fOwner.CustomData;
         if not p.Drag then begin
            dwEffect := 0;
         end;
      end;
   end;
end;

procedure TRichEditOleCallback.GetInPlaceContext(
  out Frame: IOleInPlaceFrame; out Doc: IOleInPlaceUIWindow;
  var FrameInfo: TOleInPlaceFrameInfo);
var
  Form: PControl;
begin
  //Get richedit's underlying form
{  Form := ValidParentForm(FOwner);}
  //Ensure there is a TOleForm object
{  if Form.OleFormObject = nil then
    TOleForm.Create(Form);}
  //Get relevant frame interface
{  Frame := Form.OleFormObject as IOleInPlaceFrame;}
  Doc := nil; //Document window is same as frame window
  FrameInfo.hWndFrame := 0; // Form.Handle;
  FrameInfo.fMDIApp := False;
  FrameInfo.hAccel := 0;
  FrameInfo.cAccelEntries := 0;
end;

function TRichEditOleCallback.GetNewStorage: IStorage;
var
  LockBytes: ILockBytes;
begin
  //Basically copied from TOleContainer.CreateStorage
  OleCheck(CreateILockBytesOnHGlobal(0, True, LockBytes));
  OleCheck(StgCreateDocfileOnILockBytes(LockBytes,
    STGM_READWRITE or STGM_SHARE_EXCLUSIVE or STGM_CREATE, 0, Result));
end;

procedure TRichEditOleCallback.QueryAcceptData(dataobj: IDataObject;
  var cfFormat: TClipFormat; reCO: DWord; fReally: Bool;
  hMetaPict: HGlobal);
begin
  //Accept anything
end;

procedure TRichEditOleCallback.QueryInsertObject(const ClsID: TCLSID;
  Stg: IStorage; CP: Integer);
begin
  //Accept anything
end;

procedure TRichEditOleCallback.ShowContainerUI(fShow: Bool);
var
  Form: PControl;
begin
  if fShow then
  begin
{    Form := GetParentForm(FOwner);}
{    if Assigned(Form) and Assigned(Form.Menu) then
    begin
      Form.Menu.SetOle2MenuHandle(0);
      (Form.OleFormObject as IVCLFrameForm).ClearBorderSpace
    end}
  end
end;

{ TOleRichEdit }

function BytesPerScanline(PixelsPerScanline, BitsPerPixel, Alignment: Longint): Longint;
begin
  Dec(Alignment);
  Result := ((PixelsPerScanline * BitsPerPixel) + Alignment) and not Alignment;
  Result := Result div 8;
end;

procedure InitializeBitmapInfoHeader(Bitmap: HBITMAP; var BI: TBitmapInfoHeader;
  Colors: Integer);
var
  DS: TDIBSection;
  Bytes: Integer;
begin
  DS.dsbmih.biSize := 0;
  Bytes := GetObject(Bitmap, SizeOf(DS), @DS);
  if Bytes = 0 then {InvalidBitmap}
  else if (Bytes >= (sizeof(DS.dsbm) + sizeof(DS.dsbmih))) and
    (DS.dsbmih.biSize >= DWORD(sizeof(DS.dsbmih))) then
    BI := DS.dsbmih
  else
  begin
    FillChar(BI, sizeof(BI), 0);
    with BI, DS.dsbm do
    begin
      biSize := SizeOf(BI);
      biWidth := bmWidth;
      biHeight := bmHeight;
    end;
  end;
  case Colors of
    2: BI.biBitCount := 1;
    3..16:
      begin
        BI.biBitCount := 4;
        BI.biClrUsed := Colors;
      end;
    17..256:
      begin
        BI.biBitCount := 8;
        BI.biClrUsed := Colors;
      end;
  else
    BI.biBitCount := DS.dsbm.bmBitsPixel * DS.dsbm.bmPlanes;
  end;
  BI.biPlanes := 1;
  if BI.biClrImportant > BI.biClrUsed then
    BI.biClrImportant := BI.biClrUsed;
  if BI.biSizeImage = 0 then
    BI.biSizeImage := BytesPerScanLine(BI.biWidth, BI.biBitCount, 32) * Abs(BI.biHeight);
end;

procedure InternalGetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: DWORD;
  var ImageSize: DWORD; Colors: Integer);
var
  BI: TBitmapInfoHeader;
begin
  InitializeBitmapInfoHeader(Bitmap, BI, Colors);
  if BI.biBitCount > 8 then
  begin
    InfoHeaderSize := SizeOf(TBitmapInfoHeader);
    if (BI.biCompression and BI_BITFIELDS) <> 0 then
      Inc(InfoHeaderSize, 12);
  end
  else
    if BI.biClrUsed = 0 then
      InfoHeaderSize := SizeOf(TBitmapInfoHeader) +
        SizeOf(TRGBQuad) * (1 shl BI.biBitCount)
    else
      InfoHeaderSize := SizeOf(TBitmapInfoHeader) +
        SizeOf(TRGBQuad) * BI.biClrUsed;
  ImageSize := BI.biSizeImage;
end;

procedure GetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: DWORD;
  var ImageSize: DWORD);
begin
  InternalGetDIBSizes(Bitmap, InfoHeaderSize, ImageSize, 0);
end;

function InternalGetDIB(Bitmap: HBITMAP; Palette: HPALETTE;
  var BitmapInfo; var Bits; Colors: Integer): Boolean;
var
  OldPal: HPALETTE;
  DC: HDC;
begin
  InitializeBitmapInfoHeader(Bitmap, TBitmapInfoHeader(BitmapInfo), Colors);
  OldPal := 0;
  DC := CreateCompatibleDC(0);
  try
    if Palette <> 0 then
    begin
      OldPal := SelectPalette(DC, Palette, False);
      RealizePalette(DC);
    end;
    Result := GetDIBits(DC, Bitmap, 0, TBitmapInfoHeader(BitmapInfo).biHeight, @Bits,
      TBitmapInfo(BitmapInfo), DIB_RGB_COLORS) <> 0;
  finally
    if OldPal <> 0 then SelectPalette(DC, OldPal, False);
    DeleteDC(DC);
  end;
end;

function GetDIB(Bitmap: HBITMAP; Palette: HPALETTE; var BitmapInfo; var Bits): Boolean;
begin
  Result := InternalGetDIB(Bitmap, Palette, BitmapInfo, Bits, 0);
end;

function TKOLOleRichEdit.BitmapToRTF(pict: PBitmap): string;
var
  bi, bb, rtf: string;
  bis, bbs: Cardinal;
  achar: ShortString;
  hexpict: string;
  I: Integer;
begin
  GetDIBSizes(pict.Handle, bis, bbs);
  SetLength(bi, bis);
  SetLength(bb, bbs);
  GetDIB(pict.Handle, {pict.Palette}0, PChar(bi)^, PChar(bb)^);
  rtf := '{\rtf1 {\pict\dibitmap ';
  SetLength(hexpict, (Length(bb) + Length(bi)) * 2);
  I := 2;
  for bis := 1 to Length(bi) do
  begin
    achar := Format('%x', [Integer(bi[bis])]);
    if Length(achar) = 1 then
      achar := '0' + achar;
    hexpict[I - 1] := achar[1];
    hexpict[I] := achar[2];
    Inc(I, 2);
  end;
  for bbs := 1 to Length(bb) do
  begin
    achar := Format('%x', [Integer(bb[bbs])]);
    if Length(achar) = 1 then
      achar := '0' + achar;
    hexpict[I - 1] := achar[1];
    hexpict[I] := achar[2];
    Inc(I, 2);
  end;
  rtf := rtf + hexpict + ' }}';
  Result := rtf;
end;

procedure TKOLOleRichEdit.HideFrames;
var p: PData;
    i: integer;
    n: integer;
    o: TREOBJECT;
begin
   p := CustomData;
   n := p.IOle.GetObjectCount;
   for i := n - 1 downto 0 do begin
      fillchar(o, sizeof(o), 0);
      o.cbStruct := sizeof(O);
      if p.IOle.GetObject(i, o, 7) = S_OK then begin
         o.dwFlags := 0;
         p.IOle.InsertObject(o);
      end;
   end;
end;

function TKOLOleRichEdit.GetDragOle;
var p: PData;
begin
   Result := False;
   if CustomData <> nil then begin
      p := CustomData;
      Result := p.Drag;
   end;
end;

procedure TKOLOleRichEdit.SetDragOle;
var p: PData;
begin
   if CustomData <> nil then begin
      p := CustomData;
      p.Drag := d;
   end;
end;

end.
