// 27-nov-2002
unit IdCoder;

interface

uses KOL { ,
  Classes } ,KOLClasses,
  IdBaseComponent, IdGlobal;

const
  CT_Creation = 0;
  CT_Realisation = $80;

  // Coder Priorities
  CP_FALLBACK = 0;
  CP_IMF = 1;
  CP_STANDARD = 8;

  // Notification messages - generic
  CN_CODED_DATA = 0;
  CN_DATA_START_FOUND = 1;
  CN_DATA_END_FOUND = 2;
  CN_CODING_STARTED = 3;
  CN_CODING_ENDED = 4;
  CN_NEW_FILENAME = 5;

  // Notifications messages - IMF coders
  CN_IMF_CODER_START = 20; // Not actually used??
  CN_IMF_BODY_START = CN_IMF_CODER_START + 1;
  CN_IMF_BODY_PART_END = CN_IMF_CODER_START + 2;
  CN_IMF_HEAD_VALUE = CN_IMF_CODER_START + 3;
  CN_IMF_NEW_MULTIPART = CN_IMF_CODER_START + 4; // New boundary found
  CN_IMF_END_MULTIPART = CN_IMF_CODER_START + 5; // Boundary end
  CN_IMF_DATA_END = CN_IMF_CODER_START + 6;
  CN_IMF_NEW_FILENAME = CN_NEW_FILENAME;

  // Notification messages - UU coders
  CN_UU_CODER_START = 40;
  CN_UU_TABLE_FOUND = CN_UU_CODER_START + 1;
  CN_UU_BEGIN_FOUND = CN_UU_CODER_START + 2;
  CN_UU_TABLE_BEGIN_ABORT = CN_UU_CODER_START + 3;
  CN_UU_LAST_CHAR_FOUND = CN_UU_CODER_START + 4;
  CN_UU_END_FOUND = CN_UU_CODER_START + 5;
  CN_UU_TABLE_CHANGED = CN_UU_CODER_START + 6;
  CN_UU_PRIVILEGE_FOUND = CN_UU_CODER_START + 7;
  CN_UU_PRIVILEGE_ERROR = CN_UU_CODER_START + 8;
  CN_UU_NEW_FILENAME = CN_NEW_FILENAME;
type
  TStringEvent = procedure(ASender: {TComponent}PObj; const AOut: string) of object;
  TIntStringEvent = procedure(ASender: {TComponent}PObj; AVal: Integer;
    const AOut: string) of object;

  TQWord = packed record
    L: LongWord;
    H: LongWord;
  end;

//  PIdCoder = ^TIdCoder;
  TIdCoder = object(TIdBaseComponent)
  protected
    FAddCRLF: Boolean;
    FAutoCompleteInput: Boolean;
    FByteCount: TQWord;
    FBytesIn: TQWord;
    FBytesOut: TQWord;
    FCBufferSize: LongWord;
    FCBufferedData: LongWord;
    FCBuffer: string;
    FFileName: string;
    FIgnoreCodedData: Boolean;
    FIgnoreNotification: Boolean;
    FInCompletion: Boolean;
    FKey: string;
    FPriority: Byte;
    FOnCodedData: TStringEvent;
    FOnNotification: TIntStringEvent;
    FOutputStrings: PStrList;//TStringList;
    FTakesFileName: Boolean;
    FTakesKey: Boolean;
    FUseEvent: Boolean;

    procedure Coder; virtual;
    procedure CompleteCoding; virtual;
    procedure IncByteCount(bytes: LongWord);
    procedure InternSetBufferSize(ABufferSize: Integer);
    procedure OutputNotification(AVal: Integer; AStr: string);
    procedure OutputString(s: string);
  public
    procedure Init;virtual;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy;
     virtual; function CodeString(AStr: string): string;
//    procedure CodeStringFromCoder(Sender: TComponent; const sOut: string);
    function CompletedInput: string; virtual;
    function GetCodedData: string; virtual;
    function GetNotification: string; virtual;
    procedure Reset; virtual;
    procedure SetKey(const key: string); virtual;
    procedure SetBufferSize(ASize: LongWord); virtual;
    property AddCRLF: Boolean read FAddCRLF write FAddCRLF;
    property AutoCompleteInput: Boolean read fAutoCompleteInput
    write fAutoCompleteInput;
    property BufferSize: LongWord read FCBufferSize write SetBufferSize;
    property ByteCount: TQWord read FByteCount;
    property BytesIn: TQWord read FBytesIn;
    property BytesOut: TQWord read FBytesOut;
    property FileName: string read FFileName write FFileName;
    property IgnoreCodedData: Boolean read FIgnoreCodedData
    write FIgnoreCodedData;
    property IgnoreNotification: Boolean read FIgnoreNotification
    write FIgnoreNotification;
//    property Key: string read FKey write SetKey;
    property OnCodedData: TStringEvent read FOnCodedData write FOnCodedData;
    property OnNotification: TIntStringEvent read FOnNotification
    write FOnNotification;
    property Priority: Byte read FPriority;
    property TakesFileName: Boolean read FTakesFileName;
    property TakesKey: Boolean read FTakesKey;
    property UseEvent: Boolean read FUseEvent write FUseEvent;
  end;
PIdCoder=^TIdCoder;

//function NewIdCoder(AOwner: {TComponent}PControl):PIdCoder;
function NewIdCoder:PIdCoder;
type

//  CIdCoder = object (TObj)of TIdCoder;

//  PIdCoderItem = ^TIdCoderItem;
  TIdCoderItem = object(TCollectionItem)
  protected
    FCoderType: Byte;
    FCoderPriority: Byte;
    FContentType: string;
    FContentTransferEncoding: string;
    FIdCoderClass: pIdCoder;//{C}TIdCoder;
  public
    property CoderType: Byte read FCoderType;
    property CoderPriority: Byte read FCoderPriority;
    property ContentType: string read FContentType;
    property ContentTransferEncoding: string read FContentTransferEncoding;
    property IdCoderClass: {C}PIdCoder{TIdCoder} read FIdCoderClass
    write FIdCoderClass;
  end;
PIdCoderItem=^TIdCoderItem;
type

  TIdCoderCollection = object(TCollection)
  protected
    FCount: LongWord;

    function GetCoder(Index: LongWord): TIdCoderItem;
    function Add: PIdCoderItem;//TIdCoderItem;
  public
     { constructor Create(ItemClass: TCollectionItemClass);

     } function AddCoder: PIdCoderItem;//TIdCoderItem;
    function GetCoderType(ContentType, ContentTransferEncoding: string;
      CoderType: Byte): TIdCoderItem;
    function GetExactCoderType(ContentType, ContentTransferEncoding: string;
      CoderType: Byte): TIdCoderItem;

    property Items[Index: LongWord]: TIdCoderItem read GetCoder;
    property ItemCount: LongWord read FCount;
  end;
PIdCoderCollection=^TIdCoderCollection;
function NewIdCoderCollection({ItemClass: TCollectionItemClass}):PIdCoderCollection;

procedure RegisterCoderClass(ClassType: PIdCoder{C}{TIdCoder};
  CoderType, CoderPriority: Byte;
  ContentType, ContentTransferEncoding: string);
procedure IncQWord(var QWord: TQWord; IncVal: LongWord);

var
  CoderCollective: PIdCoderCollection;//TIdCoderCollection;

implementation

uses SysUtils;

procedure RegisterCoderClass
(ClassType: PIdCoder{C}{TIdCoder};
  CoderType, CoderPriority: Byte;
  ContentType, ContentTransferEncoding: string);
var
  item: PIdCoderItem;//TIdCoderItem;
begin
  item := CoderCollective.AddCoder;
//  item.IdCoderClass := ClassType;
//  item.FCoderType := CoderType;
  item.FCoderPriority := CoderPriority;
  item.FContentType := ContentType;
  item.FContentTransferEncoding := ContentTransferEncoding;
end;

procedure IncQWord;
var
  i: LongWord;
begin
  if QWord.L > IncVal then
  begin
    i := IncVal;
  end
  else
  begin
    i := QWord.L;
    QWord.L := IncVal;
  end;

  if QWord.L and $80000000 = $80000000 then
  begin
    Inc(QWord.L, i);
    if QWord.L and $80000000 <> $00000000 then
    begin
      if QWord.H and $80000000 = $80000000 then
      begin
        Inc(QWord.H);
        if QWord.H and $80000000 <> $80000000 then
        begin
          QWord.L := 0;
          QWord.H := 0;
        end;
      end
      else
      begin
        Inc(QWord.H);
      end;
    end;
  end
  else
  begin
    Inc(QWord.L, i);
  end;
end;

///////////
// TIdCoder
///////////

 { constructor TIdCoder.Create;
 }
function NewIdCoder:PIdCoder;
begin
//  inherited Create(AOwner);
New( Result, Create );
Result.Init;
{with Result^ do
begin
  FCBufferSize := 4096;
  FAddCRLF := False;
  fAutoCompleteInput := False;
  FByteCount.L := 0;
  FByteCount.H := 0;
  FBytesIn.L := 0;
  FBytesIn.H := 0;
  FBytesOut.L := 0;
  FBytesOut.H := 0;
  FPriority := CP_FALLBACK;
  FInCompletion := False;
  FIgnoreCodedData := False;
  FIgnoreNotification := False;
  FFileName := '';
  FTakesFileName := False;
  FKey := '';
  FTakesKey := False;
  FUseEvent := False;
  FOutputStrings := NewStrList;//TStringList.Create;
  SetLength(FCBuffer, FCBufferSize);
end; }
end;

procedure TIdCoder.Init;
begin
  inherited;
  FCBufferSize := 4096;
  FAddCRLF := False;
  fAutoCompleteInput := False;
  FByteCount.L := 0;
  FByteCount.H := 0;
  FBytesIn.L := 0;
  FBytesIn.H := 0;
  FBytesOut.L := 0;
  FBytesOut.H := 0;
  FPriority := CP_FALLBACK;
  FInCompletion := False;
  FIgnoreCodedData := False;
  FIgnoreNotification := False;
  FFileName := '';
  FTakesFileName := False;
  FKey := '';
  FTakesKey := False;
  FUseEvent := False;
  FOutputStrings := NewStrList;//TStringList.Create;
  SetLength(FCBuffer, FCBufferSize);
end;

procedure TIdCoder.Reset;
begin
  InternSetBufferSize(FCBufferSize);
  FInCompletion := False;
  FOutputStrings.Clear;
end;

procedure TIdCoder.SetBufferSize;
begin
  InternSetBufferSize(ASize);
end;

procedure TIdCoder.Coder;
var
  s: string;
begin
  SetLength(s, FCBufferSize);
  System.Move(FCBuffer[1], s[1], FCBufferSize);
  UniqueString(s);
  OutputString(s);
  FCBufferedData := 0;
end;

procedure TIdCoder.CompleteCoding;
var
  s: string;
begin
  SetLength(s, FCBufferedData);
  UniqueString(s);
  System.Move(FCBuffer[1], s[1], FCBufferedData);
  OutputString(s);
  IncByteCount(FCBufferedData);
  FCBufferedData := 0;
end;

{procedure TIdCoder.CodeStringFromCoder;
begin
  CodeString(sOut);
end;}

function TIdCoder.CodeString;
var
  i: Integer;
  str: string;
begin
  str := AStr;
  IncQWord(FBytesIn, length(str));
  while str <> '' do
  begin
    i := FCBufferSize - FCBufferedData;
    if Length(str) >= i then
    begin
      System.Move(str[1], FCBuffer[FCBufferedData + 1],
        i);

      str := Copy(str, i + 1, length(str));
      FCBufferedData := FCBufferSize;

      Coder;

    end
    else
    begin
      System.Move(str[1], FCBuffer[FCBufferedData + 1],
        Length(str));
      Inc(FCBufferedData, Length(str));
      str := '';
    end;
  end;

  if fAutoCompleteInput then
  begin
    result := CompletedInput;
  end
  else
  begin
    result := GetNotification;
  end;
end;

function TIdCoder.CompletedInput;
begin
  FInCompletion := True;
  CompleteCoding;
  result := GetNotification;
end;

procedure TIdCoder.IncByteCount;
begin
  IncQWord(FByteCount, bytes);
end;

procedure TIdCoder.SetKey;
begin
  FKey := key;
end;

destructor TIdCoder.Destroy;
begin
  FOutputStrings.Free;
  inherited;
end;

procedure TIdCoder.OutputNotification;
begin
  if FUseEvent then
  begin
    if Assigned(FOnNotification) then
    begin
      FOnNotification(@Self, AVal, AStr);
    end;
  end
  else
  begin
    FOutputStrings.Add(IntToStr(AVal) + ';' + AStr);
  end;
end;

procedure TIdCoder.OutputString;
var
  s1: string;
begin
  if FAddCRLF then
  begin
    s1 := s + CR + LF;
  end
  else
  begin
    s1 := s;
  end;

  IncQWord(FBytesOut, length(s1));

  if FUseEvent then
  begin
    if Assigned(FOnCodedData) then
    begin
      OnCodedData(@Self, s1);
    end;
  end
  else
  begin
    FOutputStrings.Add(IntToStr(CN_CODED_DATA) + ';' + s1);
  end;
end;

procedure TIdCoder.InternSetBufferSize(ABufferSize: Integer);
begin
  // ????????????? ABuffer or Buffer ????????????
  if ABufferSize > length(FCBuffer) then
  begin
    SetLength(FCBuffer, ABufferSize);
    UniqueString(FCBuffer);
  end;
  FCBufferSize := ABufferSize;
  FCBufferedData := 0;
end;

function TIdCoder.GetNotification;
var
  s, ent: string;
  exWhile: Boolean;
begin
  if FIgnoreNotification and FIgnoreCodedData then
  begin
    FOutputStrings.Clear;
    result := '';
  end
  else
  begin
    if FOutputStrings.Count > 0 then
    begin
      s := FOutputStrings.Items[0];
      if s[1] <> '0' then
      begin
        FOutputStrings.Delete(0);
        result := s;
      end
      else
      begin
        exWhile := False;
        FOutputStrings.Delete(0);
        Fetch(s, ';');
        while not exWhile do
        begin
          if FOutputStrings.Count > 0 then
          begin
            ent := FOutputStrings.Items[0];
            if ent[1] = '0' then
            begin
              Fetch(ent, ';');
              s := s + ent;
              FOutputStrings.Delete(0);
            end
            else
            begin
              exWhile := True;
            end;
          end
          else
          begin
            exWhile := True;
          end;

          if FOutputStrings.Count = 0 then
          begin
            exWhile := True;
          end;
        end;
        result := '0;' + s;
      end;
    end
    else
    begin
      result := '';
    end;
  end;
end;

function TIdCoder.GetCodedData;
var
  s: string;
  i: Integer;
begin
(*  if FIgnoreNotification and FIgnoreCodedData then
  begin
//    FOutputStrings.Clear;
    result := '';
  end
  else
  begin
//    if FOutputStrings.Count > 0 then
    begin
//      s := FOutputStrings[0];
      if s[1] = '0' then
      begin
//        FOutputStrings.Delete(0);
        result := s;
        Fetch(result, ';');
      end
      else
        if FIgnoreNotification then
      begin
//        i := FOutputStrings.Count;
//        while FOutputStrings[0][1] <> '0' do
        begin
//          FOutputStrings.Delete(0);
          Dec(i);
          if i <= 0 then
            break;
        end;
        result := GetCodedData;
      end
      else
      begin
        result := '';
      end;
    end
{    else
    begin
      result := '';
    end};
    end;
  end;  *)
end;

/////////////////////
// TIdCoderCollection
/////////////////////

 { constructor TIdCoderCollection.Create;
 }
function NewIdCoderCollection:PIdCoderCollection;
begin
//  inherited Create(ItemClass);
  New( Result, Create );
with Result^ do
  FCount := 0;
end;

function TIdCoderCollection.Add;
begin
  Inc(FCount);
  Result:=PIdCoderItem(inherited Add);
// result := TIdCoderItem(inherited Add);
end;

function TIdCoderCollection.GetCoder;
begin
//  result := TIdCoderItem(inherited Items[Index]);
end;

function TIdCoderCollection.AddCoder;
begin
  result := Self.Add;
end;

function TIdCoderCollection.GetExactCoderType;
var
  i: Integer;
  TWCI: TIdCoderItem;
begin
//  result := nil;
  i := 0;
  while i < Count do
  begin
    TWCI := Items[i];
    if CoderType = TWCI.CoderType then
    begin

      if LowerCase(TWCI.ContentTransferEncoding) =
        LowerCase(ContentTransferEncoding) then
      begin
        if LowerCase(TWCI.ContentType) = LowerCase(ContentType) then
        begin
          result := GetCoder(i);
          break;
        end;
      end;
    end;

    Inc(i);
  end;
end;

function TIdCoderCollection.GetCoderType;
var
  i: Integer;
  TWCI: TIdCoderItem;
  found: Boolean;
begin
//  result := nil;
  TWCI := GetExactCoderType(ContentType, ContentTransferEncoding, CoderType);
//  if TWCI = nil then
  begin
    i := 0;
    found := false;
    if ContentTransferEncoding <> '' then
    begin
      while i < Count do
      begin
        TWCI := Items[i];
        if CoderType = TWCI.CoderType then
        begin

          if (LowerCase(TWCI.ContentTransferEncoding) =
            LowerCase(ContentTransferEncoding))
            and (ContentTransferEncoding <> '') then
          begin
            result := TWCI;
            found := True;
            break;
          end;
        end;

        Inc(i);
      end;
    end;
    if (not found) and (ContentType <> '') then
    begin
      while i < Count do
      begin
        TWCI := Items[i];
        if CoderType = TWCI.CoderType then
        begin

          if (LowerCase(TWCI.ContentType) =
            LowerCase(ContentType))
            and (ContentType <> '') then
          begin
            result := TWCI;
            found := True;
            break;
          end;
        end;

        Inc(i);
      end;
    end;
    if not found then
    begin
      result := GetExactCoderType('application/octet-stream', '', CoderType);
    end;
  end
{  else
  begin
    result := TWCI;
  end};
end;

initialization
  CoderCollective :=NewIdCoderCollection();
//  RegisterCoderClass(nil, CT_CREATION, CP_FALLBACK,
//    'application/octet-stream', '');
  {TIdCoderCollection.Create(TIdCoderItem);
  RegisterCoderClass(TIdCoder, CT_CREATION, CP_FALLBACK,
    'application/octet-stream', '');}
{  RegisterCoderClass(TIdCoder, CT_REALISATION, CP_FALLBACK,
    'application/octet-stream', '');}

finalization
  CoderCollective.Free;
end.
