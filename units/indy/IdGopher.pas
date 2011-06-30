// 29-nov-2002
unit IdGopher;

interface

uses KOL { , 
  Classes } ,KOLClasses,
  IdEMailAddress, IdGlobal,
  IdHeaderList, IdTCPClient;

type
  TIdGopherMenuItem = object(TCollectionItem)
  protected
    FTitle: string;
    FItemType: Char;
    FSelector: string;
    FServer: string;
    FPort: Integer;
    FGopherPlusItem: Boolean;
    FGopherBlock: TIdHeaderList;
    FViews: PStrList;
    FURL: string;
    FAbstract: PStrList;
    FAsk: TIdHeaderList;
    fAdminEmail: TIdEMailAddressItem;
    function GetLastModified: string;
    function GetOrganization: string;
    function GetLocation: string;
    function GetGeog: string;
  public
     { constructor Create(ACollection: TCollection); override;
     } destructor Destroy; 
     virtual; procedure DoneSettingInfoBlock; virtual;
    property Title: string read FTitle write FTitle;
    property ItemType: Char read FItemType write FItemType;
    property Selector: string read FSelector write FSelector;
    property Server: string read FServer write FServer;
    property Port: Integer read FPort write FPort;
    property GopherPlusItem: Boolean read FGopherPlusItem
    write FGopherPlusItem;
    property GopherBlock: TIdHeaderList read FGopherBlock;
    property URL: string read FURL;
    property Views: PStrList read FViews;
    property AAbstract: PStrList read FAbstract;
    property LastModified: string read GetLastModified;
    property AdminEMail: TIdEMailAddressItem read fAdminEmail;
    property Organization: string read GetOrganization;
    property Location: string read GetLocation;
    property Geog: string read GetGeog;
    property Ask: TIdHeaderList read FAsk;
  end;
PIdGopherMenuItem=^TIdGopherMenuItem;
function NewIdGopherMenuItem(ACollection: TCollection):PIdGopherMenuItem;
type 
  TIdGopherMenu = object(TCollection)
  protected
    function GetItem(Index: Integer): TIdGopherMenuItem;
    procedure SetItem(Index: Integer; const Value: TIdGopherMenuItem);
  public
     { constructor Create;  }// reintroduce;
    function Add: TIdGopherMenuItem;
    property Items[Index: Integer]: TIdGopherMenuItem read GetItem
    write SetItem; default;
  end;
PIdGopherMenu=^TIdGopherMenu;
function NewIdGopherMenu:PIdGopherMenu;
type
  TIdGopherMenuEvent = procedure(Sender: TObject;
    MenuItem: TIdGopherMenuItem) of object;

  TIdGopher = object(TIdTCPClient)
  private
  protected
    FOnMenuItem: TIdGopherMenuEvent;
    procedure DoMenu(MenuItem: TIdGopherMenuItem);
    procedure ProcessGopherError;
    function MenuItemFromString(stLine: string; Menu: TIdGopherMenu)
      : TIdGopherMenuItem;
    function ProcessDirectory(PreviousData: string = '';
      const ExpectedLength: Integer = 0): TIdGopherMenu;
    function LoadExtendedDirectory(PreviousData: string = '';
      const ExpectedLength: Integer = 0): TIdGopherMenu;
    procedure ProcessFile(ADestStream: TStream; APreviousData: string = '';
      const ExpectedLength: Integer = 0);
    procedure ProcessTextFile(ADestStream: TStream;
      APreviousData: string = ''; const ExpectedLength: Integer = 0);
  public
//    constructor Create(AOwner: TComponent); override;
    function GetMenu(ASelector: string; IsGopherPlus: Boolean = False; AView:
      string = ''):
    TIdGopherMenu;
    function Search(ASelector, AQuery: string): TIdGopherMenu;
    procedure GetFile(ASelector: string; ADestStream: TStream; IsGopherPlus:
      Boolean = False; AView: string = '');
    procedure GetTextFile(ASelector: string; ADestStream: TStream; IsGopherPlus:
      Boolean = False; AView: string = '');
    function GetExtendedMenu(ASelector: string; AView: string = ''):
      TIdGopherMenu;
//  published
    property OnMenuItem: TIdGopherMenuEvent read FOnMenuItem write FOnMenuItem;
    property Port default IdPORT_GOPHER;
  end;

PIdGopher=^TIdGopher;
function NewIdGopher(AOwner: PControl):PIdGopher;

implementation

uses
  IdComponent,{ IdException,}
  IdGopherConsts,
  IdTCPConnection,
  SysUtils;

procedure WriteToStream(AStream: TStream; AString: string);
begin
  if Length(AString) > 0 then
    AStream.Write(AString[1], Length(AString));
end;
 

function NewIdGopher(AOwner: PControl):PIdGopher;
// constructor TIdGopher.Create(AOwner: TComponent);
begin
//  inherited;
New( Result, Create );
with Result^ do
begin
//  Port := IdPORT_GOPHER;
end;
end;

procedure TIdGopher.DoMenu(MenuItem: TIdGopherMenuItem);
begin
//  if Assigned(FOnMenuItem) then
//    FOnMenuItem(Self, MenuItem);
end;

procedure TIdGopher.ProcessGopherError;
var
  ErrorNo: Integer;
  ErrMsg: string;
begin
  ErrMsg := AllData;
  ErrorNo := StrToInt(Fetch(ErrMsg));
//  raise EIdProtocolReplyError.CreateError(ErrorNo, Copy(ErrMsg, 1, Length(ErrMsg)
//    - 5));
end;

function TIdGopher.MenuItemFromString(stLine: string;
  Menu: TIdGopherMenu): TIdGopherMenuItem;
begin
{  stLine := Trim(stLine);
  if Assigned(Menu) then
  begin
    Result := Menu.Add;
  end
  else
  begin
    Result := TIdGopherMenuItem.Create(nil);
  end;
  Result.Title := IdGlobal.Fetch(stLine, TAB);
  if Length(Result.Title) > 0 then
  begin
    Result.ItemType := Result.Title[1];
  end
  else
  begin
    Result.ItemType := IdGopherItem_Error;
  end;
  Result.Title := Copy(Result.Title, 2, Length(Result.Title));
  Result.Selector := Fetch(stLine, TAB);
  Result.Server := Fetch(stLine, TAB);
  Result.Port := StrToInt(Fetch(stLine, TAB));
  stLine := Fetch(stLine, TAB);
  Result.GopherPlusItem := ((Length(stLine) > 0) and
    (stLine[1] = '+'));}
end;

function TIdGopher.LoadExtendedDirectory(PreviousData: string = '';
  const ExpectedLength: Integer = 0): TIdGopherMenu;
var
  stLine: string;
  gmnu: TIdGopherMenuItem;
begin
{  BeginWork(wmRead, ExpectedLength);
  try
    Result := TIdGopherMenu.Create;
    gmnu := nil;
    repeat
      stLine := PreviousData + ReadLn;
      PreviousData := '';
      if (stLine <> '.') then
      begin
        if (Copy(stLine, 1, Length(IdGopherPlusInfo)) = IdGopherPlusInfo) then
        begin
          if (gmnu <> nil) then
          begin
            gmnu.DoneSettingInfoBlock;
            DoMenu(gmnu);
          end;
          gmnu := MenuItemFromString(RightStr(stLine,
            Length(stLine) - Length(IdGopherPlusInfo)), Result);
          gmnu.GopherBlock.Add(stLine);
        end
        else
        begin
          if Assigned(gmnu) and (stLine <> '') then
          begin
            gmnu.GopherBlock.Add(stLine);
          end;
        end;
      end
      else
      begin
        if (gmnu <> nil) then
        begin
          DoMenu(gmnu);
        end;
      end;
    until (stLine = '.') or not Connected;
  finally EndWork(wmRead);
  end;}
end;

function TIdGopher.ProcessDirectory(PreviousData: string = '';
  const ExpectedLength: Integer = 0): TIdGopherMenu;
var
  stLine: string;

begin
{  BeginWork(wmRead, ExpectedLength);
  try
    Result := TIdGopherMenu.Create;
    repeat
      stLine := PreviousData + ReadLn;
      PreviousData := '';
      if (stLine <> '.') then
      begin
        DoMenu(MenuItemFromString(stLine, Result));
      end;
    until (stLine = '.') or not Connected;
  finally
    EndWork(wmRead);
  end;}
end;

procedure TIdGopher.ProcessTextFile(ADestStream: TStream; APreviousData: string =
  '';
  const ExpectedLength: Integer = 0);
begin
  WriteToStream(ADestStream, APreviousData);
  BeginWork(wmRead, ExpectedLength);
  try
//    Capture(ADestStream, '.', True);
  finally
    EndWork(wmRead);
  end;
end;

procedure TIdGopher.ProcessFile(ADestStream: TStream; APreviousData: string =
  '';
  const ExpectedLength: Integer = 0);
begin
  BeginWork(wmRead, ExpectedLength);
  try
    WriteToStream(ADestStream, APreviousData);
    ReadStream(ADestStream, -1, True);
    ADestStream.Position := 0;
  finally
    EndWork(wmRead);
  end;
end;

function TIdGopher.Search(ASelector, AQuery: string): TIdGopherMenu;
begin
  Connect;
  try
    WriteLn(ASelector + TAB + AQuery);
    Result := ProcessDirectory;
  finally
    Disconnect;
  end;
end;

procedure TIdGopher.GetFile(ASelector: string; ADestStream: TStream;
  IsGopherPlus: Boolean = False;
  AView: string = '');
var
  Reply: Char;
  LengthBytes: Integer;

begin
  Connect;
  try
    if not IsGopherPlus then
    begin
      WriteLn(ASelector);
      ProcessFile(ADestStream);
    end
    else
    begin
      AView := Trim(Fetch(AView, ':'));
      WriteLn(ASelector + TAB + '+' + AView);
      ReadBuffer(Reply, 1);
      case Reply of
        '-':
          begin
            ReadLn;
            ProcessGopherError;
          end;
        '+':
          begin
            LengthBytes := StrToInt(ReadLn);
            case LengthBytes of
              -1: ProcessTextFile(ADestStream);
              -2: ProcessFile(ADestStream);
            else
              ProcessFile(ADestStream, '', LengthBytes);
            end;
          end;
      else
        begin
          ProcessFile(ADestStream, Reply);
        end;
      end;
    end;
  finally
    Disconnect;
  end;
end;

function TIdGopher.GetMenu(ASelector: string; IsGopherPlus: Boolean = False;
  AView: string = ''):
TIdGopherMenu;
var
  Reply: Char;
  LengthBytes: Integer;
begin
//  Result := nil;
  Connect;
  try
    if not IsGopherPlus then
    begin
      WriteLn(ASelector);
      Result := ProcessDirectory;
    end
    else
    begin
      WriteLn(ASelector + TAB + '+' + AView);
      ReadBuffer(Reply, 1);
      case Reply of
        '-':
          begin
            ReadLn;
            ProcessGopherError;
          end;
        '+':
          begin
            LengthBytes := StrToInt(ReadLn);
            Result := ProcessDirectory('', LengthBytes);
          end;
      else
        begin
          Result := ProcessDirectory(Reply);
        end;
      end;
    end;
  finally
    Disconnect;
  end;
end;

function TIdGopher.GetExtendedMenu(ASelector, AView: string): TIdGopherMenu;
var
  Reply: Char;
  LengthBytes: Integer;
begin
//  Result := nil;
  Connect;
  try
    WriteLn(ASelector + TAB + '$' + AView);
    ReadBuffer(Reply, 1);
    case Reply of
      '-':
        begin
          ReadLn;
          ProcessGopherError;
        end;
      '+':
        begin
          LengthBytes := StrToInt(ReadLn);
          Result := LoadExtendedDirectory('', LengthBytes);
        end;
    else
      Result := ProcessDirectory(Reply);
    end;
  finally
    Disconnect;
  end;
end;

procedure TIdGopher.GetTextFile(ASelector: string; ADestStream: TStream;
  IsGopherPlus: Boolean; AView: string);
var
  Reply: Char;
  LengthBytes: Integer;

begin
  Connect;
  try
    if not IsGopherPlus then
    begin
      WriteLn(ASelector);
      ProcessTextFile(ADestStream);
    end
    else
    begin
      AView := Trim(Fetch(AView, ':'));
      WriteLn(ASelector + TAB + '+' + AView);
      ReadBuffer(Reply, 1);
      case Reply of
        '-':
          begin
            ReadLn;
            ProcessGopherError;
          end;
        '+':
          begin
            LengthBytes := StrToInt(ReadLn);
            case LengthBytes of
              -1: ProcessTextFile(ADestStream);
              -2: ProcessFile(ADestStream);
            else
              ProcessTextFile(ADestStream, '', LengthBytes);
            end;
          end;
      else
        begin
          ProcessTextFile(ADestStream, Reply);
        end;
      end;
    end;
  finally
    Disconnect;
  end;
end;

function TIdGopherMenu.Add: TIdGopherMenuItem;
begin
//  Result := TIdGopherMenuItem(inherited Add);
end;

//constructor TIdGopherMenu.Create;
function NewIdGopherMenu:PIdGopherMenu;
begin
New( Result, Create );
//  inherited Create(TIdGopherMenuItem);
end;

function TIdGopherMenu.GetItem(Index: Integer): TIdGopherMenuItem;
begin
//  result := TIdGopherMenuItem(inherited Items[index]);
end;

procedure TIdGopherMenu.SetItem(Index: Integer;
  const Value: TIdGopherMenuItem);
begin
//  inherited SetItem(Index, Value);
end;

//constructor TIdGopherMenuItem.Create(ACollection: TCollection);
function NewIdGopherMenuItem(ACollection: TCollection):PIdGopherMenuItem;
begin
New( Result, Create );
with Result^ do
begin
//  inherited;
{  FGopherBlock := TIdHeaderList.Create;
  FGopherBlock.Sorted := False;
  FGopherBlock.Duplicates := dupAccept;
  FGopherBlock.UnfoldLines := False;
  FGopherBlock.FoldLines := False;
  FViews := PStrList.Create;
  FAbstract := PStrList.Create;
  FAsk := TIdHeaderList.Create;
  fAdminEmail := TIdEMailAddressItem.Create(nil);
  FAbstract.Sorted := False;}
end;
end;

destructor TIdGopherMenuItem.Destroy;
begin
  FreeAndNil(fAdminEmail);
  FreeAndNil(FAsk);
  FreeAndNil(FAbstract);
  FreeAndNil(FGopherBlock);
  FreeAndNil(FViews);
  inherited;
end;

procedure TIdGopherMenuItem.DoneSettingInfoBlock;
const
  BlockTypes: array[1..3] of string = ('+VIEWS', '+ABSTRACT', '+ASK');
var
  idx: Integer;
  line: string;

  procedure ParseBlock(Block: PStrList);
  begin
{    Inc(idx);
    while (idx < FGopherBlock.Count) and
      (FGopherBlock[idx][1] = ' ') do
    begin
      Block.Add(TrimLeft(FGopherBlock[idx]));
      Inc(idx);
    end;
    Dec(idx);}
  end;

begin
(*  idx := 0;
  while (idx < FGopherBlock.Count) do
  begin
    Line := FGopherBlock[idx];
    Line := UpperCase(Fetch(Line, ':'));
    case PosInStrArray(Line, BlockTypes) of
      {+VIEWS:}
      0: ParseBlock(FViews);
      {+ABSTRACT:}
      1: ParseBlock(FAbstract);
      {+ASK:}
      2: ParseBlock(FAsk);
    end;
    Inc(idx);
  end;
  fAdminEmail.Text := FGopherBlock.Values[' Admin'];*)
end;

function TIdGopherMenuItem.GetGeog: string;
begin
  Result := FGopherBlock.Values[' Geog'];
end;

function TIdGopherMenuItem.GetLastModified: string;
begin
  Result := FGopherBlock.Values[' Mod-Date'];
end;

function TIdGopherMenuItem.GetLocation: string;
begin
  Result := FGopherBlock.Values[' Loc'];
end;

function TIdGopherMenuItem.GetOrganization: string;
begin
  Result := FGopherBlock.Values[' Org'];
end;

end.
