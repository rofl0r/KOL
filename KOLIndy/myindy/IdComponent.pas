// 22-nov-2002
unit IdComponent;

interface

uses KOL { , 
  Classes } ,
  IdAntiFreezeBase, IdBaseComponent, IdGlobal, IdStack, IdResourceStrings;

type
  TIdStatus = (hsResolving,
    hsConnecting,
    hsConnected,
    hsDisconnecting,
    hsDisconnected,
    hsText);

const
  IdStati: array[TIdStatus] of string = (
    RSStatusResolving,
    RSStatusConnecting,
    RSStatusConnected,
    RSStatusDisconnecting,
    RSStatusDisconnected,
    RSStatusText);

type
  TIdStatusEvent = procedure(axSender: PObj{TObject}; const axStatus: TIdStatus;
    const asStatusText: string) of object;

  TWorkMode = (wmRead, wmWrite);
  TWorkInfo = record
    Current: Integer;
    Max: Integer;
    Level: Integer;
  end;

  TWorkBeginEvent = procedure(Sender: {TObject}PObj; AWorkMode: TWorkMode;
    const AWorkCountMax: Integer) of object;
  TWorkEndEvent = procedure(Sender: {TObject}PObj; AWorkMode: TWorkMode) of object;
  TWorkEvent = procedure(Sender: {TObject}PObj; AWorkMode: TWorkMode; const
    AWorkCount: Integer)
    of object;

  TIdComponent = object(TIdBaseComponent)
  protected

    FOnStatus: TIdStatusEvent;
    FOnWork: TWorkEvent;
    FOnWorkBegin: TWorkBeginEvent;
    FOnWorkEnd: TWorkEndEvent;
    FWorkInfos: array[TWorkMode] of TWorkInfo;

    procedure DoStatus(axStatus: TIdStatus); overload;
    procedure DoStatus(axStatus: TIdStatus; const aaArgs: array of const);
      overload;
    function GetLocalName: string;

  {  property OnWork: TWorkEvent read FOnWork write FOnWork;
    property OnWorkBegin: TWorkBeginEvent read FOnWorkBegin write FOnWorkBegin;
    property OnWorkEnd: TWorkEndEvent read FOnWorkEnd write FOnWorkEnd;}
  public
    procedure Init; virtual;
    procedure BeginWork(AWorkMode: TWorkMode; const ASize: Integer = 0);
      virtual;
     { constructor Create(axOwner: TComponent); override;
     } destructor Destroy; 
     virtual; procedure DoWork(AWorkMode: TWorkMode; const ACount: Integer); virtual;
    procedure EndWork(AWorkMode: TWorkMode); virtual;

    property LocalName: string read GetLocalName;
   { published } 
    property OnStatus: TIdStatusEvent read FOnStatus write FOnStatus;

    property OnWork: TWorkEvent read FOnWork write FOnWork;
    property OnWorkBegin: TWorkBeginEvent read FOnWorkBegin write FOnWorkBegin;
    property OnWorkEnd: TWorkEndEvent read FOnWorkEnd write FOnWorkEnd;
  end;
PIdComponent=^TIdComponent;
function NewIdComponent(axOwner: PControl):PIdComponent;

implementation

var
  gnInstanceCount: Integer = 0;

function NewIdComponent(axOwner: PControl):PIdComponent;
  //constructor TIdComponent.Create(axOwner: TComponent);
begin
  New( Result, Create );
  Result.Init;
{  with Result^ do
  begin
//  inherited;
  if GStack = nil then
  begin
    GStack := NewIdStack;//TIdStack.CreateStack;
  end;
  Inc(gnInstanceCount);
  end; }
end;

procedure TIdComponent.Init;
begin
  inherited;
  if GStack = nil then
  begin
    GStack := NewIdStack.CreateStack;//TIdStack.CreateStack;
  end;
  Inc(gnInstanceCount);

{  with Result^ do
  begin
  inherited;
  if GStack = nil then
  begin
    GStack := NewIdStack;//TIdStack.CreateStack;
  end;
  Inc(gnInstanceCount);
  end;          }
end;

destructor TIdComponent.Destroy;
begin
  Dec(gnInstanceCount);
  if gnInstanceCount = 0 then
  begin
    GStack.free;
    GStack := nil;
  end;
  inherited;
end;

procedure TIdComponent.DoStatus(axStatus: TIdStatus);
begin
  DoStatus(axStatus, []);
end;

procedure TIdComponent.DoStatus(axStatus: TIdStatus; const aaArgs: array of
  const);
begin
  if assigned(OnStatus) then
  begin
    OnStatus(@Self, axStatus, Format(IdStati[axStatus], aaArgs));
  end;
end;

function TIdComponent.GetLocalName: string;
begin
  result := GStack.WSGetHostName;
end;

procedure TIdComponent.BeginWork(AWorkMode: TWorkMode; const ASize: Integer =
  0);
begin
  Inc(FWorkInfos[AWorkMode].Level);
  if FWorkInfos[AWorkMode].Level = 1 then
  begin
    FWorkInfos[AWorkMode].Max := ASize;
    FWorkInfos[AWorkMode].Current := 0;
    if assigned(OnWorkBegin) then
    begin
      OnWorkBegin(@Self, AWorkMode, ASize);
    end;
  end;
end;

procedure TIdComponent.DoWork(AWorkMode: TWorkMode; const ACount: Integer);
begin
  if FWorkInfos[AWorkMode].Level > 0 then
  begin
    Inc(FWorkInfos[AWorkMode].Current, ACount);
    if assigned(OnWork) then
    begin
      OnWork(@Self, AWorkMode, FWorkInfos[AWorkMode].Current);
    end;
  end;
end;

procedure TIdComponent.EndWork(AWorkMode: TWorkMode);
begin
  if FWorkInfos[AWorkMode].Level = 1 then
  begin
    if assigned(OnWorkEnd) then
    begin
      OnWorkEnd(@Self, AWorkMode);
    end;
  end;
  Dec(FWorkInfos[AWorkMode].Level);
end;

end.
