// 27-nov-2002
unit IdIPWatch;

interface

uses KOL { , 
  Classes } ,
  IdComponent, IdThread;

const
  IP_WATCH_HIST_MAX = 25;
  IP_WATCH_HIST_FILENAME = 'iphist.dat';
  IP_WATCH_ACTIVE = False;
  IP_WATCH_HIST_ENABLED = True;
  IP_WATCH_INTERVAL = 1000;

type
  TIdIPWatchThread = object(TIdThread)
  protected
    FInterval: Integer;
    FSender: TObject;
//    FTimerEvent: TNotifyEvent;
    //
    procedure Run; virtual;// abstract;// override;
    procedure TimerEvent;
  end;
PIdIPWatchThread=^TIdIPWatchThread;
function NewIdIPWatchThread:PIdIPWatchThread;
type

  TIdIPWatch = object(TIdComponent)
  protected
    FActive: Boolean;
    FCurrentIP: string;
    FHistoryEnabled: Boolean;
    FHistoryFilename: string;
    FIPHistoryList: PStrList;
    FIsOnline: Boolean;
    FLocalIPHuntBusy: Boolean;
    FMaxHistoryEntries: Integer;
    FOnLineCount: Integer;
//    FOnStatusChanged: TNotifyEvent;
    FPreviousIP: string;
    FThread: PIdIPWatchThread;
    FWatchInterval: Cardinal;

    procedure AddToIPHistoryList(Value: string);
    procedure CheckStatus(Sender: TObject);
    procedure SetActive(Value: Boolean);
    procedure SetMaxHistoryEntries(Value: Integer);
    procedure SetWatchInterval(Value: Cardinal);
  public
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 
     virtual; function ForceCheck: Boolean;
    procedure LoadHistory;
    function LocalIP: string;
    procedure SaveHistory;
    //
    property CurrentIP: string read FCurrentIP;
    property IPHistoryList: PStrList read FIPHistoryList;
    property IsOnline: Boolean read FIsOnline;
    property PreviousIP: string read FPreviousIP;
   { published } 
    property Active: Boolean read FActive write SetActive default
      IP_WATCH_ACTIVE;
    property HistoryEnabled: Boolean read FHistoryEnabled write FHistoryEnabled
      default IP_WATCH_HIST_ENABLED;
    property HistoryFilename: string read FHistoryFilename write
      FHistoryFilename;
    property MaxHistoryEntries: Integer read FMaxHistoryEntries write
      SetMaxHistoryEntries
    default IP_WATCH_HIST_MAX;
//    property OnStatusChanged: TNotifyEvent read FOnStatusChanged write
//      FOnStatusChanged;
    property WatchInterval: Cardinal read FWatchInterval write SetWatchInterval
      default IP_WATCH_INTERVAL;
  end;
PIdIPWatch=^TIdIPWatch;
function NewIdIPWatch(AOwner: PControl):PIdIPWatch; 

implementation

uses
  IdGlobal, IdStack;

function NewIdIPWatchThread:PIdIPWatchThread;
begin
  New( Result, Create );
end;

procedure TIdIPWatch.AddToIPHistoryList(Value: string);
begin
  if (Value = '') or (Value = '127.0.0.1') then
  begin
    Exit;
  end;

  if FIPHistoryList.Count > 0 then
  begin
    if FIPHistoryList.Items[FIPHistoryList.Count - 1] = Value then
    begin
      Exit;
    end;
  end;

  FIPHistoryList.Add(Value);
  if FIPHistoryList.Count > MaxHistoryEntries then
  begin
    FIPHistoryList.Delete(0);
  end;
end;

procedure TIdIPWatch.CheckStatus(Sender: TObject);
var
  WasOnLine: Boolean;
  OldIP: string;
begin
  try
    if FLocalIPHuntBusy then
    begin
      Exit;
    end;
    WasOnLine := FIsOnline;
    OldIP := FCurrentIP;
    FCurrentIP := LocalIP;
    FIsOnline := (FCurrentIP <> '127.0.0.1') and (FCurrentIP <> '');

    if (WasOnline) and (not FIsOnline) then
    begin
      if (OldIP <> '127.0.0.1') and (OldIP <> '') then
      begin
        FPreviousIP := OldIP;
      end;
      AddToIPHistoryList(FPreviousIP);
    end;

    if (not WasOnline) and (FIsOnline) then
    begin
      if FOnlineCount = 0 then
      begin
        FOnlineCount := 1;
      end;
      if FOnlineCount = 1 then
      begin
        if FPreviousIP = FCurrentIP then
        begin
          if FIPHistoryList.Count > 0 then
          begin
            FIPHistoryList.Delete(FIPHistoryList.Count - 1);
          end;
          if FIPHistoryList.Count > 0 then
          begin
            FPreviousIP := FIPHistoryList.Items[FIPHistoryList.Count - 1];
          end
          else
          begin
            FPreviousIP := '';
          end;
        end;
      end;
      FOnlineCount := 2;
    end;

    if ((WasOnline) and (not FIsOnline)) or ((not WasOnline) and (FIsOnline))
      then
    begin
//      if (not (csDesigning in ComponentState)) and Assigned(FOnStatusChanged)
//        then
      begin
//        FOnStatusChanged(Self);
      end;
    end;
  except
  end;
end;

//constructor TIdIPWatch.Create(AOwner: TComponent);
function NewIdIPWatch(AOwner: PControl):PIdIPWatch;
begin
//  inherited;
  New( Result, Create );
with Result^ do
begin
  FIPHistoryList := NewStrList;//PStrList.Create;
  FIsOnLine := False;
  FOnLineCount := 0;
  FWatchInterval := 1000;
  FActive := IP_WATCH_ACTIVE;
  FPreviousIP := '';
  FLocalIPHuntBusy := False;
  FHistoryEnabled := IP_WATCH_HIST_ENABLED;
  FHistoryFilename := IP_WATCH_HIST_FILENAME;
  FMaxHistoryEntries := IP_WATCH_HIST_MAX;
end;
end;

destructor TIdIPWatch.Destroy;
begin
  if FIsOnLine then
  begin
    AddToIPHistoryList(FCurrentIP);
  end;
  Active := False;
  SaveHistory;
  FIPHistoryList.Free;
  inherited;
end;

function TIdIPWatch.ForceCheck: Boolean;
begin
  CheckStatus(nil);
  Result := FIsOnline;
end;

procedure TIdIPWatch.LoadHistory;
begin
//  if not (csDesigning in ComponentState) then
  begin
    FIPHistoryList.Clear;
    if (FileExists(FHistoryFilename)) and (FHistoryEnabled) then
    begin
      FIPHistoryList.LoadFromFile(FHistoryFileName);
      if FIPHistoryList.Count > 0 then
      begin
        FPreviousIP := FIPHistoryList.Items[FIPHistoryList.Count - 1];
      end;
    end;
  end;
end;

function TIdIPWatch.LocalIP: string;
begin
  FLocalIpHuntBusy := True;
  try
    Result := GStack.LocalAddress;
  finally
    FLocalIPHuntBusy := False;
  end;
end;

procedure TIdIPWatch.SaveHistory;
begin
//  if (not (csDesigning in ComponentState)) and FHistoryEnabled then
  begin
    FIPHistoryList.SaveToFile(FHistoryFilename);
  end;
end;

procedure TIdIPWatch.SetActive(Value: Boolean);
begin
  if Value <> FActive then
  begin
    FActive := Value;
//    if not (csDesigning in ComponentState) then
    begin
      if FActive then
      begin
        FThread := NewIdIPWatchThread;//TIdIPWatchThread.Create;
        with FThread^ do
        begin
          FSender := @Self;
//          FTimerEvent := CheckStatus;
          FInterval := FWatchInterval;
          Start;
        end;
      end
      else
      begin
        FThread.TerminateAndWaitFor;
        FreeAndNil(FThread);
      end;
    end;
  end;
end;

procedure TIdIPWatch.SetMaxHistoryEntries(Value: Integer);
begin
  FMaxHistoryEntries := Value;
  while FIPHistoryList.Count > MaxHistoryEntries do
    FIPHistoryList.Delete(0);
end;

procedure TIdIPWatch.SetWatchInterval(Value: Cardinal);
begin
  if Value <> FWatchInterval then
  begin
    FThread.FInterval := Value;
  end;
end;

procedure TIdIPWatchThread.Run;
var
  LInterval: Integer;
begin
  LInterval := FInterval;
  while LInterval > 0 do
  begin
    if LInterval > 500 then
    begin
      Sleep(500);
      LInterval := LInterval - 500;
    end
    else
    begin
      Sleep(LInterval);
      LInterval := 0;
    end;
    if Terminated then
    begin
      exit;
    end;
    Synchronize(TimerEvent);
  end;
end;

procedure TIdIPWatchThread.TimerEvent;
begin
//  FTimerEvent(@FSender);
end;

end.
