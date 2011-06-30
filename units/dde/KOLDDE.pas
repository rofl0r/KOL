unit KOLDDE;

{$R-,T-,H+,X+}

interface

uses
  KOL, Windows, DDEML;

type

  PDDEObj =^TDDEObj;
  TDDEObj = object(TObj)
  public
     DDEType: string;
        Name: string;
  end;

  TDataMode = (ddeAutomatic, ddeManual);
  PDdeServerConv =^TDdeServerConv;
  PDdeClientItem =^TDdeClientItem;
  TMacroEvent = procedure(Sender: TDDEObj; Msg: PStrList) of object;

{ TDdeClientConv }

  PDdeClientConv =^TDdeClientConv;
  TDdeClientConv = object(TDDEObj)
  private
    FDdeService: string;
    FDdeTopic: string;
    FConv: HConv;
    FCnvInfo: TConvInfo;
    FItems: PList;
    FHszApp: HSZ;
    FHszTopic: HSZ;
    FDdeFmt: Integer;
    FOnClose: TOnEvent;
    FOnOpen: TOnEvent;
    FAppName: string;
    FDataMode: TDataMode;
    FConnectMode: TDataMode;
    FWaitStat: Boolean;
    FFormatChars: Boolean;
    procedure SetDdeService(const Value: string);
    procedure SetDdeTopic(const Value: string);
    procedure SetService(const Value: string);
    procedure SetTopic(const Value: string);
    procedure SetConnectMode(NewMode: TDataMode);
    procedure SetFormatChars(NewFmt: Boolean);
    procedure XactComplete;
    procedure SrvrDisconnect;
    procedure DataChange(DdeDat: HDDEData; hszIt: HSZ);
  protected
    function CreateDdeConv(FHszAp: HSZ; FHszTop: HSZ): Boolean;
    function GetCliItemByName(const ItemName: string): PDDEObj;
    function GetCliItemByCtrl(ACtrl: PDdeClientItem): PDDEObj;
    function OnSetItem(aCtrl: PDdeClientItem; const S: string): Boolean;
    procedure OnAttach(aCtrl: PDdeClientItem);
    procedure OnDetach(aCtrl: PDdeClientItem);
    procedure Close; virtual;
    procedure Open; virtual;
    function ChangeLink(const App, Topic, Item: string): Boolean;
    procedure ClearItems;
  public
    destructor Destroy; virtual;
    function OpenLink: Boolean;
    function SetLink(const Service, Topic: string): Boolean;
    procedure CloseLink;
    function StartAdvise: Boolean;
    function PokeDataLines(const Item: string; Data: PStrList): Boolean;
    function PokeData(const Item: string; Data: PChar): Boolean;
    function ExecuteMacroLines(Cmd: PStrList; waitFlg: Boolean): Boolean;
    function ExecuteMacro(Cmd: PChar; waitFlg: Boolean): Boolean;
    function RequestData(const Item: string): PChar;
    property DdeFmt: Integer read FDdeFmt;
    property WaitStat: Boolean read FWaitStat;
    property Conv: HConv read FConv;
    property DataMode: TDataMode read FDataMode write FDataMode;
  public
    property ServiceApplication: string read FAppName write FAppName;
    property DdeService: string read FDdeService write SetDdeService;
    property DdeTopic: string read FDdeTopic write SetDdeTopic;
    property ConnectMode: TDataMode read FConnectMode write SetConnectMode default ddeAutomatic;
    property FormatChars: Boolean read FFormatChars write SetFormatChars default False;
    property OnClose: TOnEvent read FOnClose write FOnClose;
    property OnOpen: TOnEvent read FOnOpen write FOnOpen;
  end;

{ TDdeClientItem }

  TDdeClientItem = object(TDDEObj)
  private
    FLines: PStrList;
    FDdeClientConv: PDdeClientConv;
    FDdeClientItem: string;
    FOnChange: TOnEvent;
    function GetText: string;
    procedure SetDdeClientItem(const Val: string);
    procedure SetDdeClientConv(Val: PDdeClientConv);
    procedure SetText(const S: string);
    procedure SetLines(L: PStrList);
    procedure OnAdvise;
  protected
  public
    destructor Destroy; virtual;
  public
    property Text: string read GetText write SetText;
    property Lines: PStrList read FLines write SetLines;
    property DdeConv: PDdeClientConv read FDdeClientConv write SetDdeClientConv;
    property DdeItem: string read FDdeClientItem write SetDdeClientItem;
    property OnChange: TOnEvent read FOnChange write FOnChange;
  end;

{ TDdeServerConv }

  TDdeServerConv = object(TDDEObj)
  private
    FOnOpen: TOnEvent;
    FOnClose: TOnEvent;
    FOnExecuteMacro: TMacroEvent;
    FItems: PList;
  protected
    procedure Connect; virtual;
    procedure Disconnect; virtual;
  public
    destructor Destroy; virtual;
    function ExecuteMacro(Data: HDdeData): LongInt;
  public
    property OnOpen: TOnEvent read FOnOpen write FOnOpen;
    property OnClose: TOnEvent read FOnClose write FOnClose;
    property OnExecuteMacro: TMacroEvent read FOnExecuteMacro write FOnExecuteMacro;
  end;

{ TDdeServerItem }

  PDdeServerItem =^TDdeServerItem;
  TDdeServerItem = object(TDDEObj)
  private
    FLines: PStrList;
    FServerConv: PDdeServerConv;
    FOnChange: TOnEvent;
    FOnPokeData: TOnEvent;
    FFmt: Integer;
    procedure ValueChanged;
  protected
    function GetText: string;
    procedure SetText(const Item: string);
    procedure SetLines(Value: PStrList);
    procedure SetServerConv(SConv: PDdeServerConv);
  public
    destructor Destroy; virtual;
    function PokeData(Data: HDdeData): LongInt;
    procedure Change; virtual;
    property Fmt: Integer read FFmt;
  public
    property Conv: PDdeServerConv read FServerConv write SetServerConv;
    property Text: string read GetText write SetText;
    property Lines: PStrList read FLines write SetLines;
    property OnChange: TOnEvent read FOnChange write FOnChange;
    property OnPokeData: TOnEvent read FOnPokeData write FOnPokeData;
  end;

  TKOLDDEClientConv = PDDEClientConv;
  TKOLDDEClientItem = PDDEClientItem;
  TKOLDDEServerConv = PDDEServerConv;
  TKOLDDEServerItem = PDDEServerItem;


{ TDdeMgr }
  PDdeMgr =^TDdeMgr;
  TDdeMgr = object(TDDEObj)
  private
    FAppName: string;
    FHszApp: HSZ;
    FConvs: PList;
    FCliConvs: PList;
    FConvCtrls: PList;
    FDdeInstId: Longint;
    FLinkClipFmt: Word;
    procedure Disconnect(DdeSrvrConv: PDDEObj);
    function GetSrvrConv(const Topic: string ): PDDEObj;
    function AllowConnect(hszApp: HSZ; hszTopic: HSZ): Boolean;
    function AllowWildConnect(hszApp: HSZ; hszTopic: HSZ): HDdeData;
    function Connect(Conv: HConv; hszTopic: HSZ; SameInst: Boolean): Boolean;
    procedure PostDataChange(const Topic: string; Item: string);
    procedure SetAppName(const ApName: string);
    procedure ResetAppName;
    function  GetServerConv(const Topic: string): PDdeServerConv;
    procedure InsertServerConv(SConv: PDdeServerConv);
    procedure RemoveServerConv(SConv: PDdeServerConv);
  public
    destructor Destroy; virtual;
    function GetExeName: string;     // obsolete
    property DdeInstId: LongInt read FDdeInstId write FDdeInstId;
    property AppName: string read FAppName write SetAppName;
    property LinkClipFmt: Word read FLinkClipFmt;
  end;

function NewDdeServerConv(AOwner: PControl): PDdeServerConv;
function NewDdeServerItem(AOwner: PControl): PDdeServerItem;
function NewDdeClientConv(AOwner: PControl): PDdeClientConv;
function NewDdeClientItem(AOwner: PControl): PDdeClientItem;

var
  ddeMgr: PDdeMgr;

implementation

uses Consts, err;

type
  EDdeError = class(Exception);
  PDdeSrvrConv =^TDdeSrvrConv;

{ TDdeSrvrItem }

  PDdeSrvrItem =^TDdeSrvrItem;
  TDdeSrvrItem = object(TDDEObj)
  private
    FConv: PDdeSrvrConv;
    FItem: string;
    FHszItem: HSZ;
    FSrvr: PDdeServerItem;
  protected
    procedure SetItem(const Value: string);
  public
    destructor Destroy; virtual;
    function RequestData(Fmt: Word): HDdeData;
    procedure PostDataChange;
    property Conv: PDdeSrvrConv read FConv write FConv;
    property Item: string read FItem write SetItem;
    property Srvr: PDdeServerItem read FSrvr write FSrvr;
    property HszItem: HSZ read FHszItem;
  end;

{ TDdeSrvrConv }

  TDdeSrvrConv = object(TDDEObj)
  private
    FTopic: string;
    FHszTopic: HSZ;
    FForm: PControl;
    FSConv: PDdeServerConv;
    FConv: HConv;
    FItems: PList;
  protected
    function GetControl(DdeConv: PDdeServerConv; const ItemName: string): PDdeServerItem;
    function GetSrvrItem(hszItem: HSZ): PDdeSrvrItem;
  public
    destructor Destroy; virtual;
    function RequestData(_Conv: HConv; hszTop: HSZ; hszItem: HSZ;
      Fmt: Word): HDdeData;
    function AdvStart(_Conv: HConv; hszTop: HSZ; hszItem: HSZ;
      Fmt: Word): Boolean;
    procedure AdvStop(_Conv: HConv; hszTop: HSZ; hszItem: HSZ);
    function PokeData(_Conv: HConv; hszTop: HSZ; hszItem: HSZ; Data: HDdeData;
      Fmt: Integer): LongInt;
    function ExecuteMacro(_Conv: HConv; hszTop: HSZ; Data: HDdeData): Integer;
    function GetItem(const ItemName: string): PDdeSrvrItem;
    property Conv: HConv read FConv;
    property Form: PControl read FForm;
    property SConv: PDdeServerConv read FSConv;
    property Topic: string read FTopic write FTopic;
    property HszTopic: HSZ read FHszTopic;
  end;

{ TDdeCliItem }

  PDdeCliItem =^TDdeCliItem;
  TDdeCliItem = object(TDDEObj)
  protected
    FItem: string;
    FHszItem: HSZ;
    FCliConv: PDdeClientConv;
    FCtrl: PDdeClientItem;
    function StartAdvise: Boolean;
    function StopAdvise: Boolean;
    procedure StoreData(DdeDat: HDDEData);
    procedure DataChange;
    function AccessData(DdeDat: HDDEData; pDataLen: PDWORD): Pointer;
    procedure ReleaseData(DdeDat: HDDEData);
  public
    destructor Destroy; virtual;
    function RefreshData: Boolean;
    function SetItem(const S: string): Boolean;
    procedure SrvrDisconnect;
    property HszItem: HSZ read FHszItem;
    property Control: PDdeClientItem read FCtrl write FCtrl;
  public
    property Item: string read FItem;
  end;

procedure DDECheck(Success: Boolean);
var
  err: Integer;
  ErrStr: string;
begin
  if Success then Exit;
  err := DdeGetLastError(DDEMgr.DdeInstId);
  case err of
    DMLERR_LOW_MEMORY, DMLERR_MEMORY_ERROR:
      ErrStr := Format(SDdeMemErr, [err]);
    DMLERR_NO_CONV_ESTABLISHED:
      ErrStr := Format(SDdeConvErr, [err]);
  else
    ErrStr := Format(SDdeErr, [err]);
  end;
  raise EDdeError.Create(e_Custom, ErrStr);
end;

function DdeMgrCallBack(CallType, Fmt : UINT; Conv: HConv; hsz1, hsz2: HSZ;
  Data: HDDEData; Data1, Data2: DWORD): HDDEData; stdcall;
var
  ci: TConvInfo;
  ddeCli: PDDEObj;
  ddeSrv: PDdeSrvrConv;
  ddeObj: PDDEObj;
  xID: DWORD;
begin
  Result := 0;
  case CallType of
    XTYP_CONNECT:
      Result := HDdeData(ddeMgr.AllowConnect(hsz2, hsz1));
    XTYP_WILDCONNECT:
      Result := ddeMgr.AllowWildConnect(hsz2, hsz1);
    XTYP_CONNECT_CONFIRM:
      ddeMgr.Connect(Conv, hsz1, Boolean(Data2));
    32930:
      ddeMgr.Connect(Conv, hsz1, Boolean(Data2));
  end;
  if Conv <> 0 then
  begin
    ci.cb := sizeof(TConvInfo);
    if CallType = XTYP_XACT_COMPLETE then
      xID := Data1
    else
      xID := QID_SYNC;
    if DdeQueryConvInfo(Conv, xID, @ci) = 0 then Exit;
    case CallType of
      XTYP_ADVREQ:
        begin
          ddeSrv := PDdeSrvrConv(ci.hUser);
          Result := ddeSrv.RequestData(Conv, hsz1, hsz2, Fmt);
        end;
      XTYP_REQUEST:
        begin
          ddeSrv := PDdeSrvrConv(ci.hUser);
          Result := ddeSrv.RequestData(Conv, hsz1, hsz2, Fmt);
        end;
      XTYP_ADVSTOP:
        begin
          ddeSrv := PDdeSrvrConv(ci.hUser);
          ddeSrv.AdvStop(Conv, hsz1, hsz2);
        end;
      XTYP_ADVSTART:
        begin
          ddeSrv := PDdeSrvrConv(ci.hUser);
          Result := HDdeData(ddeSrv.AdvStart(Conv, hsz1, hsz2, Fmt));
        end;
      XTYP_POKE:
        begin
          ddeSrv := PDdeSrvrConv(ci.hUser);
          Result := HDdeData(ddeSrv.PokeData(Conv, hsz1, hsz2, Data, Fmt));
        end;
      XTYP_EXECUTE:
        begin
          ddeSrv := PDdeSrvrConv(ci.hUser);
          Result := HDdeData(ddeSrv.ExecuteMacro(Conv, hsz1, Data));
        end;
      XTYP_XACT_COMPLETE:
        begin
          ddeCli := PDDEObj(ci.hUser);
          if ddeCli <> nil then PDdeClientConv(ddeCli).XactComplete
        end;
      XTYP_ADVDATA:
        begin
          ddeCli := PDDEObj(ci.hUser);
          PDdeClientConv(ddeCli).DataChange(Data, hsz2);
        end;
      XTYP_DISCONNECT:
        begin
          ddeObj := PDDEObj(ci.hUser);
          if ddeObj <> nil then
          begin
             if ddeObj.DDEType = 'TDdeClientConv' then
              PDdeClientConv(ddeObj).SrvrDisconnect
            else
              ddeMgr.Disconnect(ddeObj);
          end;
        end;
    end;
  end;
end;

{ TDdeMgr }

function NewDdeMgr: PDdeMgr;
begin
  New(Result, create);
  result.FDdeInstId := 0;
  DDECheck(DdeInitialize(result.FDdeInstId, DdeMgrCallBack, APPCLASS_STANDARD, 0) = 0);
  result.FConvs := NewList;
  result.FCliConvs := NewList;
  result.FConvCtrls := NewList;
  result.AppName := ParamStr(0);
end;

destructor TDdeMgr.Destroy;
var
  I: Integer;
begin
  if FConvs <> nil then
  begin
    for I := 0 to FConvs.Count - 1 do
      PDdeSrvrConv(FConvs.Items[I]).Free;
    FConvs.Free;
    FConvs := nil;
  end;
  if FCliConvs <> nil then
  begin
    for I := 0 to FCliConvs.Count - 1 do
      PDdeSrvrConv(FCliConvs.Items[I]).Free;
    FCliConvs.Free;
    FCliConvs := nil;
  end;
  if FConvCtrls <> nil then
  begin
    FConvCtrls.Free;
    FConvCtrls := nil;
  end;
  ResetAppName;
  DdeUnInitialize(FDdeInstId);
  inherited Destroy;
end;

function TDdeMgr.AllowConnect(hszApp: HSZ; hszTopic: HSZ): Boolean;
var
  Topic: string;
  Buffer: array[0..4095] of Char;
  Form: PControl;
  SConv: PDdeServerConv;
begin
  Result := False;
  if (hszApp = 0) or (DdeCmpStringHandles(hszApp, FHszApp) = 0)  then
  begin
    SetString(Topic, Buffer, DdeQueryString(FDdeInstId, hszTopic, Buffer,
      SizeOf(Buffer), CP_WINANSI));
    SConv := GetServerConv(Topic);
    if SConv <> nil then Result := True
  end;
end;

function TDdeMgr.AllowWildConnect(hszApp: HSZ; hszTopic: HSZ): HDdeData;
var
  conns: packed array[0..1] of THSZPair;
begin
  Result := 0;
  if hszTopic = 0 then Exit;
  if AllowConnect(hszApp, hszTopic) = True then
  begin
    conns[0].hszSvc := FHszApp;
    conns[0].hszTopic := hszTopic;
    conns[1].hszSvc := 0;
    conns[1].hszTopic := 0;
    Result := DdeCreateDataHandle(ddeMgr.DdeInstId, @conns,
      2 * sizeof(THSZPair), 0, 0, CF_TEXT, 0);
  end;
end;

function NewDdeSrvrConv(AOwner: PDDEObj): PDdeSrvrConv; forward;

function TDdeMgr.Connect(Conv: HConv; hszTopic: HSZ; SameInst: Boolean): Boolean;
var
  Topic: string;
  Buffer: array[0..4095] of Char;
  DdeConv: PDdeSrvrConv;
begin
  DdeConv := NewDdeSrvrConv(@Self);
  SetString(Topic, Buffer, DdeQueryString(FDdeInstId, hszTopic, Buffer,
    SizeOf(Buffer), CP_WINANSI));
  DdeConv.Topic := Topic;
  DdeConv.FSConv := GetServerConv(Topic);
  if DdeConv.FSConv = nil then exit;
  DdeConv.FConv := Conv;
  DdeSetUserHandle(Conv, QID_SYNC, DWORD(DdeConv));
  FConvs.Add(DdeConv);
  if DdeConv.FSConv <> nil then DdeConv.FSConv.Connect;
  Result := True;
end;

procedure TDdeMgr.Disconnect(DdeSrvrConv: PDDEObj);
var
  DdeConv: PDdeSrvrConv;
begin
  DdeConv := PDdeSrvrConv(DdeSrvrConv);
  if DdeConv.FSConv <> nil then DdeConv.FSConv.Disconnect;
  if DdeConv.FConv <> 0 then DdeSetUserHandle(DdeConv.FConv, QID_SYNC, 0);
  DdeConv.FConv := 0;
  if FConvs <> nil then
  begin
    FConvs.Delete(FConvs.IndexOf(DdeConv));
    DdeConv.Free;
  end;
end;

function TDdeMgr.GetExeName: string;
begin
  Result := ParamStr(0);
end;

procedure TDdeMgr.SetAppName(const ApName: string);
var
  Dot: Integer;
begin
  ResetAppName;
  FAppName := ExtractFileName(ApName);
  Dot := Pos('.', FAppName);
  if Dot <> 0 then
    Delete(FAppName, Dot, Length(FAppName));
  FHszApp := DdeCreateStringHandle(FDdeInstId, PChar(FAppName), CP_WINANSI);
  DdeNameService(FDdeInstId, FHszApp, 0, DNS_REGISTER);
end;

procedure TDdeMgr.ResetAppName;
begin
  if FHszApp <> 0 then
  begin
    DdeNameService(FDdeInstId, FHszApp, 0, DNS_UNREGISTER);
    DdeFreeStringHandle(FDdeInstId, FHszApp);
  end;
  FHszApp := 0;
end;

function TDdeMgr.GetServerConv(const Topic: string): PDdeServerConv;
var
  I: Integer;
  SConv: PDdeServerConv;
begin
  Result := nil;
  for I := 0 to FConvCtrls.Count - 1 do
  begin
    SConv := PDdeServerConv(FConvCtrls.Items[I]);
    if AnsiCompareText(SConv.Name, Topic) = 0 then
    begin
      Result := SConv;
      Exit;
    end;
  end;
end;

function TDdeMgr.GetSrvrConv(const Topic: string ): PDDEObj;
var
  I: Integer;
  Conv: PDdeSrvrConv;
begin
  Result := nil;
  for I := 0 to FConvs.Count - 1 do
  begin
    Conv := FConvs.Items[I];
    if AnsiCompareText(Conv.Topic, Topic) = 0 then
    begin
      Result := Conv;
      Exit;
    end;
  end;
end;

procedure TDdeMgr.PostDataChange(const Topic: string; Item: string);
var
  Conv: PDdeSrvrConv;
  Itm: PDdeSrvrItem;
begin
  Conv := PDdeSrvrConv(GetSrvrConv(Topic));
  If Conv <> nil then
  begin
    Itm := Conv.GetItem(Item);
    if Itm <> nil then Itm.PostDataChange;
  end;
end;

procedure TDdeMgr.InsertServerConv(SConv: PDdeServerConv);
begin
  FConvCtrls.Add(SConv);
end;

procedure TDdeMgr.RemoveServerConv(SConv: PDdeServerConv);
begin
  FConvCtrls.delete(FConvCtrls.IndexOf(SConv));
end;

function NewDdeClientConv(AOwner: PControl): PDdeClientConv;
begin
   new(result, create);
   result.FItems      := NewList;
   result.DDEType     := 'TDdeClientConv';
   result.ConnectMode := ddeManual;
end;

destructor TDdeClientConv.Destroy;
begin
  CloseLink;
  FItems.Free;
  FItems := nil;
  inherited Destroy;
end;

function NewDdeCliItem(ADS: PDdeClientConv): PDdeCliItem; forward;

procedure TDdeClientConv.OnAttach(aCtrl: PDdeClientItem);
var
  ItemLnk: PDdeCliItem;
begin
  ItemLnk := NewDdeCliItem(@Self);
  FItems.Add(ItemLnk);
  ItemLnk.Control := aCtrl;
  ItemLnk.SetItem('');
end;

procedure TDdeClientConv.OnDetach(aCtrl: PDdeClientItem);
var
  ItemLnk: PDdeCliItem;
begin
  ItemLnk := PDdeCliItem(GetCliItemByCtrl(aCtrl));
  if ItemLnk <> nil then
  begin
    ItemLnk.SetItem('');
    FItems.delete(FItems.IndexOf(ItemLnk));
    ItemLnk.Free;
  end;
end;

function TDdeClientConv.OnSetItem(aCtrl: PDdeClientItem; const S: string): Boolean;
var
  ItemLnk: PDdeCliItem;
begin
  Result := True;
  ItemLnk := PDdeCliItem(GetCliItemByCtrl(aCtrl));

  if (ItemLnk = nil) and (Length(S) > 0) then
  begin
    OnAttach (aCtrl);
    ItemLnk := PDdeCliItem(GetCliItemByCtrl(aCtrl));
  end;

  if (ItemLnk <> nil) and (Length(S) = 0) then
  begin
    OnDetach (aCtrl);
  end
  else if ItemLnk <> nil then
  begin
    Result := ItemLnk.SetItem(S);
    if Not (Result) then
      OnDetach (aCtrl);  {error occurred, do cleanup}
  end;
end;

function TDdeClientConv.GetCliItemByCtrl(ACtrl: PDdeClientItem): PDDEObj;
var
  ItemLnk: PDdeCliItem;
  I: word;
begin
  Result := nil;
  I := 0;
  while I < FItems.Count do
  begin
    ItemLnk := FItems.Items[I];
    if ItemLnk.Control = aCtrl then
    begin
      Result := ItemLnk;
      Exit;
    end;
    Inc(I);
  end;
end;

function TDdeClientConv.ChangeLink(const App, Topic, Item: string): Boolean;
begin
  CloseLink;
  SetService(App);
  SetTopic(Topic);
  Result := OpenLink;
  if Not Result then
  begin
    SetService('');
    SetTopic('');
  end;
end;

function TDdeClientConv.OpenLink: Boolean;
var
  CharVal: array[0..255] of Char;
  Res: Boolean;
begin
  Result := False;
  if FConv <> 0 then Exit;

  if (Length(DdeService) = 0) and (Length(DdeTopic) = 0) then
  begin
    ClearItems;
    Exit;
  end;

  if FHszApp = 0 then
  begin
    StrPCopy(CharVal, DdeService);
    FHszApp := DdeCreateStringHandle(ddeMgr.DdeInstId, CharVal, CP_WINANSI);
  end;
  if FHszTopic = 0 then
  begin
    StrPCopy(CharVal, DdeTopic);
    FHszTopic := DdeCreateStringHandle(ddeMgr.DdeInstId, CharVal, CP_WINANSI);
  end;
  Res := CreateDdeConv(FHszApp, FHszTopic);
  if Not Res then
  begin
    if Not((Length(DdeService) = 0) and
      (Length(ServiceApplication) = 0)) then
    begin
      if Length(ServiceApplication) <> 0 then
        StrPCopy(CharVal, ServiceApplication)
      else
        StrPCopy(CharVal, DdeService + ' ' + DdeTopic);
      if WinExec(CharVal, SW_SHOWMINNOACTIVE) >= 32 then
        Res := CreateDdeConv(FHszApp, FHszTopic);
    end;
  end;
  if Not Res then
  begin
    ClearItems;
    Exit;
  end;
  if FCnvInfo.wFmt <> 0 then FDdeFmt := FCnvInfo.wFmt
  else FDdeFmt := CF_TEXT;
  if StartAdvise = False then Exit;
  Open;
  DataChange(0, 0);
  Result := True;
end;

procedure TDdeClientConv.CloseLink;
var
  OldConv: HConv;
begin
  if FConv <> 0 then
  begin
    OldConv := FConv;
    SrvrDisconnect;
    FConv := 0;
    DdeSetUserHandle(OldConv, QID_SYNC, 0);
    DdeDisconnect(OldConv);
  end;

  if FHszApp <> 0 then
  begin
    DdeFreeStringHandle(ddeMgr.DdeInstId, FHszApp);
    FHszApp := 0;
  end;

  if FHszTopic <> 0 then
  begin
    DdeFreeStringHandle(ddeMgr.DdeInstId, FHszTopic);
    FHszTopic := 0;
  end;
  SetService('');
  SetTopic('');
end;

procedure TDdeClientConv.ClearItems;
var
  ItemLnk: PDdeCliItem;
  i: word;
begin
  if FItems.Count = 0 then Exit;

  for I := 0 to FItems.Count - 1 do
  begin
    ItemLnk := PDdeCliItem(FItems.Items[0]);
    ItemLnk.Control.DdeItem := '';
  end;
end;

function TDdeClientConv.CreateDdeConv(FHszAp: HSZ; FHszTop: HSZ): Boolean;
var
  Context: TConvContext;
begin
  FillChar(Context, SizeOf(Context), 0);
  with Context do
  begin
    cb := SizeOf(TConvConText);
    iCodePage := CP_WINANSI;
  end;
  FConv := DdeConnect(ddeMgr.DdeInstId, FHszAp, FHszTop, @Context);
  Result := FConv <> 0;
  if Result then
  begin
    FCnvInfo.cb := sizeof(TConvInfo);
    DdeQueryConvInfo(FConv, QID_SYNC, @FCnvInfo);
    DdeSetUserHandle(FConv, QID_SYNC, LongInt(@Self));
  end;
end;

function TDdeClientConv.StartAdvise: Boolean;
var
  ItemLnk: PDdeCliItem;
  i: word;
begin
  Result := False;
  if FConv = 0 then Exit;

  i := 0;
  while i < FItems.Count do
  begin
    ItemLnk := PDdeCliItem(FItems.Items[i]);
    if Not ItemLnk.StartAdvise then
    begin
      ItemLnk.Control.DdeItem := '';
    end else
      Inc(i);
    if i >= FItems.Count then
      break;
  end;
  Result := True;
end;

function TDdeClientConv.ExecuteMacroLines(Cmd: PStrList; waitFlg: Boolean): Boolean;
begin
  Result := False;
  if (FConv = 0) or FWaitStat then Exit;
  Result := ExecuteMacro(PChar(Cmd.Text), waitFlg);
end;

function TDdeClientConv.ExecuteMacro(Cmd: PChar; waitFlg: Boolean): Boolean;
var
  hszCmd: HDDEData;
  hdata: HDDEData;
  ddeRslt: LongInt;
begin
  Result := False;
  if (FConv = 0) or FWaitStat then Exit;
  hszCmd := DdeCreateDataHandle(ddeMgr.DdeInstId, Cmd, StrLen(Cmd) + 1,
    0, 0, FDdeFmt, 0);
  if hszCmd = 0 then Exit;
  if waitFlg = True then FWaitStat := True;
  hdata := DdeClientTransaction(Pointer(hszCmd), DWORD(-1), FConv, 0, FDdeFmt,
     XTYP_EXECUTE, TIMEOUT_ASYNC, @ddeRslt);
  if hdata = 0 then FWaitStat := False
  else Result := True;
end;

function TDdeClientConv.PokeDataLines(const Item: string; Data: PStrList): Boolean;
begin
  Result := False;
  if (FConv = 0) or FWaitStat then Exit;
  Result := PokeData(Item, PChar(Data.Text));
end;

function TDdeClientConv.PokeData(const Item: string; Data: PChar): Boolean;
var
  hszDat: HDDEData;
  hdata: HDDEData;
  hszItem: HSZ;
begin
  Result := False;
  if (FConv = 0) or FWaitStat then Exit;
  hszItem := DdeCreateStringHandle(ddeMgr.DdeInstId, PChar(Item), CP_WINANSI);
  if hszItem = 0 then Exit;
  hszDat := DdeCreateDataHandle (ddeMgr.DdeInstId, Data, StrLen(Data) + 1,
    0, hszItem, FDdeFmt, 0);
  if hszDat <> 0 then
  begin
    hdata := DdeClientTransaction(Pointer(hszDat), DWORD(-1), FConv, hszItem,
      FDdeFmt, XTYP_POKE, TIMEOUT_ASYNC, nil);
    Result := hdata <> 0;
  end;
  DdeFreeStringHandle (ddeMgr.DdeInstId, hszItem);
end;

function TDdeClientConv.RequestData(const Item: string): PChar;
var
  hData: HDDEData;
  ddeRslt: LongInt;
  hItem: HSZ;
  pData: Pointer;
  Len: Integer;
begin
  Result := nil;
  if (FConv = 0) or FWaitStat then Exit;
  hItem := DdeCreateStringHandle(ddeMgr.DdeInstId, PChar(Item), CP_WINANSI);
  if hItem <> 0 then
  begin
    hData := DdeClientTransaction(nil, 0, FConv, hItem, FDdeFmt,
      XTYP_REQUEST, 10000, @ddeRslt);
    DdeFreeStringHandle(ddeMgr.DdeInstId, hItem);
    if hData <> 0 then
    try
      pData := DdeAccessData(hData, @Len);
      if pData <> nil then
      try
        GetMem(Result, Len + 1);
        Move(pData^, Result^, len);    // data is binary, may contain nulls
        Result[len] := #0;
      finally
        DdeUnaccessData(hData);
      end;
    finally
      DdeFreeDataHandle(hData);
    end;
  end;
end;

function TDdeClientConv.GetCliItemByName(const ItemName: string): PDDEObj;
var
  ItemLnk: PDdeCliItem;
  i: word;
begin
  Result := nil;
  i := 0;
  while i < FItems.Count do
  begin
    ItemLnk := PDdeCliItem(FItems.Items[i]);
    if ItemLnk.Item = ItemName then
    begin
      Result := ItemLnk;
      Exit;
    end;
    Inc(i);
  end;
end;

procedure TDdeClientConv.XactComplete;
begin
   FWaitStat := False;
end;

procedure TDdeClientConv.SrvrDisconnect;
var
  ItemLnk: PDdeCliItem;
  i: word;
begin
  if FConv <> 0 then Close;
  FConv := 0;
  i := 0;
  while i < FItems.Count do
  begin
    ItemLnk := PDdeCliItem(FItems.Items[i]);
    ItemLnk.SrvrDisconnect;
    inc(i);
  end;
end;

procedure TDdeClientConv.DataChange(DdeDat: HDDEData; hszIt: HSZ);
var
  ItemLnk: PDdeCliItem;
  i: word;
begin
  i := 0;
  while i < FItems.Count do
  begin
    ItemLnk := PDdeCliItem(FItems.Items[i]);
    if (hszIt = 0) or (ItemLnk.HszItem = hszIt) then
    begin
        { data has changed and we found a link that might be interested }
      ItemLnk.StoreData(DdeDat);
    end;
    Inc(i);
  end;
end;

function TDdeClientConv.SetLink(const Service, Topic: string): Boolean;
begin
  CloseLink;
{  if FConnectMode = ddeAutomatic then}
  if False then
    Result := ChangeLink(Service, Topic, '')
  else begin
    SetService(Service);
    SetTopic(Topic);
    DataChange(0,0);
    Result := True;
  end;
end;

procedure TDdeClientConv.SetConnectMode(NewMode: TDataMode);
begin
  if FConnectMode <> NewMode then
  begin
{    if (NewMode = ddeAutomatic) and (Length(DdeService) <> 0) and
      (Length(DdeTopic) <> 0) and not OpenLink then
      raise Exception.CreateRes(@SDdeNoConnect);}
    FConnectMode := NewMode;
  end;
end;

procedure TDdeClientConv.SetFormatChars(NewFmt: Boolean);
begin
  if FFormatChars <> NewFmt then
  begin
    FFormatChars := NewFmt;
    if FConv <> 0 then DataChange(0, 0);
  end;
end;

procedure TDdeClientConv.SetDdeService(const Value: string);
begin
   fDDEService := Value;
end;

procedure TDdeClientConv.SetDdeTopic(const Value: string);
begin
   fDDETopic := Value;
end;

procedure TDdeClientConv.SetService(const Value: string);
begin
  FDdeService := Value;
end;

procedure TDdeClientConv.SetTopic(const Value: string);
begin
  FDdeTopic := Value;
end;

procedure TDdeClientConv.Close;
begin
  if Assigned(FOnClose) then FOnClose(@Self);
end;

procedure TDdeClientConv.Open;
begin
  if Assigned(FOnOpen) then FOnOpen(@Self);
end;

function NewDdeClientItem(AOwner: PControl): PDdeClientItem;
begin
   new(result, create);
   result.FLines  := NewStrList;
   result.DDEType := 'TDdeClientItem';
end;

destructor TDdeClientItem.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

procedure TDdeClientItem.SetDdeClientConv(Val: PDdeClientConv);
var
  OldItem: string;
begin
  if Val <> FDdeClientConv then
  begin
    OldItem := DdeItem;
    FDdeClientItem := '';
    if FDdeClientConv <> nil then
      FDdeClientConv.OnDetach (@Self);

    FDdeClientConv := Val;
    if FDdeClientConv <> nil then
    begin
      if Length(OldItem) <> 0 then SetDdeClientItem (OldItem);
    end;
  end;
end;

procedure TDdeClientItem.SetDdeClientItem(const Val: string);
begin
  if FDdeClientConv <> nil then
  begin
    FDdeClientItem := Val;
    if Not FDdeClientConv.OnSetItem (@Self, Val) then
    begin
      if not ((FDdeClientConv.FConv = 0) { and
        (FDdeClientConv.ConnectMode = ddeManual)}) then
        FDdeClientItem := '';
    end;
  end;
end;

procedure TDdeClientItem.OnAdvise;
begin
  if Assigned(FOnChange) then FOnChange(@Self);
end;

function TDdeClientItem.GetText: string;
begin
  if FLines.Count > 0 then
    Result := FLines.Items[0]
  else Result := '';
end;

procedure TDdeClientItem.SetText(const S: string);
begin
end;

procedure TDdeClientItem.SetLines(L: PStrList);
begin
end;

function NewDdeCliItem(ADS: PDdeClientConv): PDdeCliItem;
begin
   new(result, create);
   result.FHszItem := 0;
   result.FCliConv := ADS;
   result.DDEType  := 'TDdeCliItem';
end;

destructor TDdeCliItem.Destroy;
begin
  StopAdvise;
  inherited Destroy;
end;

function TDdeCliItem.SetItem(const S: string): Boolean;
var
  OldItem: string;
begin
  Result := False;
  OldItem := Item;
  if FHszItem <> 0 then StopAdvise;

  FItem := S;
  FCtrl.Lines.Clear;

  if (Length(Item) <> 0) then
  begin
    if (FCliConv.Conv <> 0) then
    begin
      Result := StartAdvise;
      if Not Result then
        FItem := '';
    end
    else {if FCliConv.ConnectMode = ddeManual then} Result := True;
  end;
  RefreshData;
end;

procedure TDdeCliItem.StoreData(DdeDat: HDDEData);
var
  Len: Longint;
  Data: string;
  I: Integer;
begin
  if DdeDat = 0 then
  begin
    RefreshData;
    Exit;
  end;

  Data := PChar(AccessData(DdeDat, @Len));
  if Data <> '' then
  begin
    FCtrl.Lines.Text := Data;
    ReleaseData(DdeDat);
    if FCliConv.FormatChars = False then
    begin
      for I := 1 to Length(Data) do
        if (Data[I] > #0) and (Data[I] < ' ') then Data[I] := ' ';
      FCtrl.Lines.Text := Data;
    end;
  end;
  DataChange;
end;

function TDdeCliItem.RefreshData: Boolean;
var
  ddeRslt: LongInt;
  DdeDat: HDDEData;
       i: integer;
begin
  Result := False;
  if (FCliConv.Conv <> 0) and (FHszItem <> 0) then
  begin
    if FCliConv.WaitStat = True then Exit;
    for i := 1 to 3 do begin
       DdeDat := DdeClientTransaction(nil, DWORD(-1), FCliConv.Conv, FHszItem,
      FCliConv.DdeFmt, XTYP_REQUEST, 1000, @ddeRslt);
      if DdeDat <> 0 then break;
    end;
    if DdeDat = 0 then Exit
    else begin
      StoreData(DdeDat);
      DdeFreeDataHandle(DdeDat);
      Result := True;
      Exit;
    end;
  end;
  DataChange;
end;

function TDdeCliItem.AccessData(DdeDat: HDDEData; pDataLen: PDWORD): Pointer;
begin
  Result := DdeAccessData(DdeDat, pDataLen);
end;

procedure TDdeCliItem.ReleaseData(DdeDat: HDDEData);
begin
  DdeUnaccessData(DdeDat);
end;

function TDdeCliItem.StartAdvise: Boolean;
var
  ddeRslt: LongInt;
  hdata: HDDEData;
begin
  Result := False;
  if FCliConv.Conv = 0 then Exit;
  if Length(Item) = 0 then Exit;
  if FHszItem = 0 then
    FHszItem := DdeCreateStringHandle(ddeMgr.DdeInstId, PChar(Item), CP_WINANSI);
  hdata := DdeClientTransaction(nil, DWORD(-1), FCliConv.Conv, FHszItem,
    FCliConv.DdeFmt, XTYP_ADVSTART or XTYPF_NODATA, 1000, @ddeRslt);
  if hdata = 0 then
  begin
    DdeGetLastError(ddeMgr.DdeInstId);
    DdeFreeStringHandle(ddeMgr.DdeInstId, FHszItem);
    FHszItem := 0;
    FCtrl.Lines.Clear;
  end else
    Result := True;
end;

function TDdeCliItem.StopAdvise: Boolean;
var
  ddeRslt: LongInt;
begin
  if FCliConv.Conv <> 0 then
    if FHszItem <> 0 then
      DdeClientTransaction(nil, DWORD(-1), FCliConv.Conv, FHszItem,
        FCliConv.DdeFmt, XTYP_ADVSTOP, 1000, @ddeRslt);
  SrvrDisconnect;
  Result := True;
end;

procedure TDdeCliItem.SrvrDisconnect;
begin
  if FHszItem <> 0 then
  begin
    DdeFreeStringHandle(ddeMgr.DdeInstId, FHszItem);
    FHszItem := 0;
  end;
end;

procedure TDdeCliItem.DataChange;
begin
  FCtrl.OnAdvise;
end;

function NewDdeServerItem(AOwner: PControl): PDdeServerItem;
begin
   new(result, create);
   result.FFmt    := CF_TEXT;
   result.FLines  := NewStrList;
   result.DDEType := 'TDdeServerItem';
end;

destructor TDdeServerItem.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

procedure TDdeServerItem.SetServerConv(SConv: PDdeServerConv);
var i: integer;
begin
  FServerConv := SConv;
  i := SConv.FItems.IndexOf(@self);
  if i = -1 then SConv.FItems.Add(@self);
end;

function TDdeServerItem.GetText: string;
begin
  if FLines.Count > 0 then
    Result := FLines.Items[0]
  else Result := '';
end;

procedure TDdeServerItem.SetText(const Item: string);
begin
  FFmt := CF_TEXT;
  FLines.Clear;
  FLines.Add(Item);
  ValueChanged;
end;

procedure TDdeServerItem.SetLines(Value: PStrList);
begin
  if AnsiCompareStr(Value.Text, FLines.Text) <> 0 then
  begin
    FFmt := CF_TEXT;
    FLines.Assign(Value);
    ValueChanged;
  end;
end;

procedure TDdeServerItem.ValueChanged;
begin
  if Assigned(FOnChange) then FOnChange(@Self);
  if FServerConv <> nil then
    ddeMgr.PostDataChange(FServerConv.Name, Name)
  else
    ddeMgr.PostDataChange(Name, Name);
end;

function TDdeServerItem.PokeData(Data: HDdeData): LongInt;
var
  Len: Integer;
  pData: Pointer;
begin
  Result := dde_FNotProcessed;
  pData := DdeAccessData(Data, @Len);
  if pData <> nil then
  begin
    Lines.Text := PChar(pData);
    DdeUnaccessData(Data);
    ValueChanged;
    if Assigned(FOnPokeData) then FOnPokeData(@Self);
    Result := dde_FAck;
  end;
end;

procedure TDdeServerItem.Change;
begin
  if Assigned(FOnChange) then FOnChange(@Self);
end;

function NewDdeServerConv(AOwner: PControl): PDdeServerConv;
begin
   new(result, create);
   result.FItems  := NewList;
   result.DDEType := 'TDdeServerConv';
   ddeMgr.InsertServerConv(result);
end;

destructor TDdeServerConv.Destroy;
begin
  FItems.Free;
  ddeMgr.RemoveServerConv(@Self);
  inherited Destroy;
end;

function TDdeServerConv.ExecuteMacro(Data: HDdeData): LongInt;
var
  Len: Integer;
  pData: Pointer;
  MacroLines: PStrList;
begin
  Result := dde_FNotProcessed;
  pData := DdeAccessData(Data, @Len);
  if pData <> nil then
  begin
    if Assigned(FOnExecuteMacro) then
    begin
      MacroLines := NewStrList;
      MacroLines.Text := PChar(pData);
      FOnExecuteMacro(Self, MacroLines);
      MacroLines.Free;
    end;
    Result := dde_FAck;
  end;
end;

procedure TDdeServerConv.Connect;
begin
  if Assigned(FOnOpen) then FOnOpen(@Self);
end;

procedure TDdeServerConv.Disconnect;
begin
  if Assigned(FOnClose) then FOnClose(@Self);
end;

function NewDdeSrvrConv(AOwner: PDDEObj): PDdeSrvrConv;
begin
   new(result, create);
   result.FItems  := NewList;
   result.DDEType := 'TDdeSrvrConv';
end;

destructor TDdeSrvrConv.Destroy;
var
  I: Integer;
begin
  if FItems <> nil then
  begin
    for I := 0 to FItems.Count - 1 do
      PDdeSrvrItem(FItems.Items[I]).Free;
    FItems.Free;
    FItems := nil;
  end;
  if FConv <> 0 then DdeDisconnect(FConv);
  if FHszTopic <> 0 then
  begin
    DdeFreeStringHandle(ddeMgr.DdeInstId, FHszTopic);
    FHszTopic := 0;
  end;
  inherited Destroy;
end;

function NewDdeSrvrItem(AOwner: PDDEObj): PDdeSrvrItem; forward;

function TDdeSrvrConv.AdvStart(_Conv: HConv; hszTop: HSZ; hszItem: HSZ;
  Fmt: Word): Boolean;
var
  Srvr: PDdeServerItem;
  Buffer: array[0..4095] of Char;
  SrvrItem: PDdeSrvrItem;
begin
  Result := False;
  if Fmt <> CF_TEXT then Exit;
  DdeQueryString(ddeMgr.DdeInstId, hszItem, Buffer, SizeOf(Buffer), CP_WINANSI);
  Srvr := GetControl(FSConv, Buffer);
  if Srvr = nil then Exit;
  SrvrItem := NewDdeSrvrItem(@Self);
  SrvrItem.Srvr  := Srvr;
  SrvrItem.Item  := Buffer;
  SrvrItem.FConv := @self;
  FItems.Add(SrvrItem);
  if FHszTopic = 0 then
    FHszTopic := DdeCreateStringHandle(ddeMgr.DdeInstId, PChar(Topic), CP_WINANSI);
  Result := True;
end;

procedure TDdeSrvrConv.AdvStop(_Conv: HConv; hszTop: HSZ; hszItem :HSZ);
var
  SrvrItem: PDdeSrvrItem;
begin
  SrvrItem := GetSrvrItem(hszItem);
  if SrvrItem <> nil then
  begin
    FItems.delete(FItems.IndexOf(SrvrItem));
    SrvrItem.Free;
  end;
end;

function TDdeSrvrConv.PokeData(_Conv: HConv; hszTop: HSZ; hszItem: HSZ;
  Data: HDdeData; Fmt: Integer): LongInt;
var
  Srvr: PDdeServerItem;
  Buffer: array[0..4095] of Char;
begin
  Result := dde_FNotProcessed;
  if Fmt <> CF_TEXT then Exit;
  DdeQueryString(ddeMgr.DdeInstId, hszItem, Buffer, SizeOf(Buffer), CP_WINANSI);
  Srvr := GetControl(FSConv, Buffer);
  if Srvr <> nil then Result := Srvr.PokeData(Data);
end;

function TDdeSrvrConv.ExecuteMacro(_Conv: HConv; hszTop: HSZ;
  Data: HDdeData): Integer;
begin
  Result := dde_FNotProcessed;
  if (FSConv <> nil)  then
    Result := FSConv.ExecuteMacro(Data);
end;

function TDdeSrvrConv.RequestData(_Conv: HConv; hszTop: HSZ; hszItem :HSZ;
  Fmt: Word): HDdeData;
var
  Data: string;
  Buffer: array[0..4095] of Char;
  SrvrIt: PDdeSrvrItem;
  Srvr: PDdeServerItem;
begin
  Result := 0;
  SrvrIt := GetSrvrItem(hszItem);
  if SrvrIt <> nil then
    Result := SrvrIt.RequestData(Fmt)
  else
  begin
    DdeQueryString(ddeMgr.DdeInstId, hszItem, Buffer, SizeOf(Buffer), CP_WINANSI);
    Srvr := GetControl(FSConv, Buffer);
    if Srvr <> nil then
    begin
      if Fmt = CF_TEXT then
      begin
        Data := Srvr.Lines.Text;
        Result := DdeCreateDataHandle(ddeMgr.DdeInstId, PChar(Data),
          Length(Data) + 1, 0, hszItem, Fmt, 0 );
      end;
    end;
  end;
end;

function TDdeSrvrConv.GetControl(DdeConv: PDdeServerConv; const ItemName: string): PDdeServerItem;
var
  I: Integer;
  Srvr: PDdeServerItem;
begin
  Result := nil;
  for i := 0 to ddeconv.FItems.Count - 1 do begin
     Srvr := ddeconv.FItems.Items[i];
     if Srvr.Name = ItemName then begin
        result := Srvr;
        exit;
     end;
  end;
end;

function TDdeSrvrConv.GetItem(const ItemName: string): PDdeSrvrItem;
var
  I: Integer;
  Item: PDdeSrvrItem;
begin
  Result := nil;
  for I := 0 to FItems.Count - 1 do
  begin
    Item := FItems.Items[I];
    If Item.Item = ItemName then
    begin
      Result := Item;
      Exit;
    end;
  end;
end;

function TDdeSrvrConv.GetSrvrItem(hszItem: HSZ): PDdeSrvrItem;
var
  I: Integer;
  Item: PDdeSrvrItem;
begin
  Result := nil;
  for I := 0 to FItems.Count - 1 do
  begin
    Item := FItems.Items[I];
    If DdeCmpStringHandles(Item.HszItem, hszItem) = 0 then
    begin
      Result := Item;
      Exit;
    end;
  end;
end;

function NewDdeSrvrItem(AOwner: PDDEObj): PDdeSrvrItem;
begin
   new(result, create);
   result.DDEType := 'TDdeSrvrItem';
{   FConv := AOwner;}
end;

destructor TDdeSrvrItem.Destroy;
begin
  if FHszItem <> 0 then
  begin
    DdeFreeStringHandle(ddeMgr.DdeInstId, FHszItem);
    FHszItem := 0;
  end;
  inherited Destroy;
end;

function TDdeSrvrItem.RequestData(Fmt: Word): HDdeData;
var
  Data: string;
  Buffer: array[0..4095] of Char;
begin
  Result := 0;
  SetString(FItem, Buffer, DdeQueryString(ddeMgr.DdeInstId, FHszItem, Buffer,
    SizeOf(Buffer), CP_WINANSI));
  if Fmt = CF_TEXT then
  begin
    Data := FSrvr.Lines.Text;
    Result := DdeCreateDataHandle(ddeMgr.DdeInstId, PChar(Data), Length(Data) + 1,
      0, FHszItem, Fmt, 0 );
  end;
end;

procedure TDdeSrvrItem.PostDataChange;
begin
  DdePostAdvise(ddeMgr.DdeInstId, FConv.HszTopic, FHszItem);
end;

procedure TDdeSrvrItem.SetItem(const Value: string);
begin
  FItem := Value;
  if FHszItem <> 0 then
  begin
    DdeFreeStringHandle(ddeMgr.DdeInstId, FHszItem);
    FHszItem := 0;
  end;
  if Length(FItem) > 0 then
    FHszItem := DdeCreateStringHandle(ddeMgr.DdeInstId, PChar(FItem), CP_WINANSI);
end;

initialization
  ddeMgr := NewDdeMgr;
finalization
  ddeMgr.Free;
end.

