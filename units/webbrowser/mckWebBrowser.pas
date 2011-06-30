//////////////////////////////////////////////////////////////////////////////////
//										//
//										//
//		TKOLWebBrowser v1.0						//
//										//
//	Author: Dimaxx (dimaxx@atnet.ru)					//
//										//
//										//
//////////////////////////////////////////////////////////////////////////////////

unit mckWebBrowser;

interface

uses Classes, Kol, Mirror;

type
  TWebBrowserStatusTextChange = procedure(Sender: TObject; const Text: WideString) of object;
  TWebBrowserProgressChange = procedure(Sender: TObject; Progress: Integer; ProgressMax: Integer) of object;
  TWebBrowserCommandStateChange = procedure(Sender: TObject; Command: Integer; Enable: WordBool) of object;
  TWebBrowserTitleChange = procedure(Sender: TObject; const Text: WideString) of object;
  TWebBrowserPropertyChange = procedure(Sender: TObject; const szProperty: WideString) of object;
  TWebBrowserBeforeNavigate2 = procedure(Sender: TObject; const pDisp: IDispatch;
                                                          var URL: OleVariant;
                                                          var Flags: OleVariant;
                                                          var TargetFrameName: OleVariant;
                                                          var PostData: OleVariant;
                                                          var Headers: OleVariant;
                                                          var Cancel: WordBool) of object;
  TWebBrowserNewWindow2 = procedure(Sender: TObject; var ppDisp: IDispatch; var Cancel: WordBool) of object;
  TWebBrowserNavigateComplete2 = procedure(Sender: TObject; const pDisp: IDispatch;
                                                            var URL: OleVariant) of object;
  TWebBrowserDocumentComplete = procedure(Sender: TObject; const pDisp: IDispatch;
                                                           var URL: OleVariant) of object;
  TWebBrowserOnVisible = procedure(Sender: TObject; Visible: WordBool) of object;
  TWebBrowserOnToolBar = procedure(Sender: TObject; ToolBar: WordBool) of object;
  TWebBrowserOnMenuBar = procedure(Sender: TObject; MenuBar: WordBool) of object;
  TWebBrowserOnStatusBar = procedure(Sender: TObject; StatusBar: WordBool) of object;
  TWebBrowserOnFullScreen = procedure(Sender: TObject; FullScreen: WordBool) of object;
  TWebBrowserOnTheaterMode = procedure(Sender: TObject; TheaterMode: WordBool) of object;

  TKOLWebBrowser = class(TKOLCustomControl)
  private
    FOnStatusTextChange: TWebBrowserStatusTextChange;
    FOnProgressChange: TWebBrowserProgressChange;
    FOnCommandStateChange: TWebBrowserCommandStateChange;
    FOnTitleChange: TWebBrowserTitleChange;
    FOnPropertyChange: TWebBrowserPropertyChange;
    FOnBeforeNavigate2: TWebBrowserBeforeNavigate2;
    FOnNewWindow2: TWebBrowserNewWindow2;
    FOnNavigateComplete2: TWebBrowserNavigateComplete2;
    FOnDocumentComplete: TWebBrowserDocumentComplete;
    FOnVisible: TWebBrowserOnVisible;
    FOnToolBar: TWebBrowserOnToolBar;
    FOnMenuBar: TWebBrowserOnMenuBar;
    FOnStatusBar: TWebBrowserOnStatusBar;
    FOnFullScreen: TWebBrowserOnFullScreen;
    FOnTheaterMode: TWebBrowserOnTheaterMode;

    FOffline: boolean;
    FSilent: boolean;
    FRegisterAsBrowser: boolean;
    FRegisterAsDropTarget: boolean;
  protected
    function AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName,AParent,Prefix: string); override;
    procedure AssignEvents(SL: TStringList; const AName: string); override;
    procedure SetOnStatusTextChange(E: TWebBrowserStatusTextChange);
    procedure SetOnProgressChange(E: TWebBrowserProgressChange);
    procedure SetOnCommandStateChange(E: TWebBrowserCommandStateChange);
    procedure SetOnTitleChange(E: TWebBrowserTitleChange);
    procedure SetOnPropertyChange(E: TWebBrowserPropertyChange);
    procedure SetOnBeforeNavigate2(E: TWebBrowserBeforeNavigate2);
    procedure SetOnNewWindow2(E: TWebBrowserNewWindow2);
    procedure SetOnNavigateComplete2(E: TWebBrowserNavigateComplete2);
    procedure SetOnDocumentComplete(E: TWebBrowserDocumentComplete);
    procedure SetOnVisible(E: TWebBrowserOnVisible);
    procedure SetOnToolBar(E: TWebBrowserOnToolBar);
    procedure SetOnMenuBar(E: TWebBrowserOnMenuBar);
    procedure SetOnStatusBar(E: TWebBrowserOnStatusBar);
    procedure SetOnFullScreen(E: TWebBrowserOnFullScreen);
    procedure SetOnTheaterMode(E: TWebBrowserOnTheaterMode);

    procedure SetOffline(V: boolean);
    procedure SetSilent(V: boolean);
    procedure SetRegisterAsBrowser(V: boolean);
    procedure SetRegisterAsDropTarget(V: boolean);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Visible;
    property TabStop;
    property TabOrder;
    property OnEnter;
    property OnExit;

    property Offline: boolean read FOffline write SetOffline default True;
    property Silent: boolean read FSilent write SetSilent default False;
    property RegisterAsBrowser: boolean read FRegisterAsBrowser write SetRegisterAsBrowser default True;
    property RegisterAsDropTarget: boolean read FRegisterAsDropTarget write SetRegisterAsDropTarget default False;

    property OnStatusTextChange: TWebBrowserStatusTextChange read FOnStatusTextChange write SetOnStatusTextChange;
    property OnProgressChange: TWebBrowserProgressChange read FOnProgressChange write SetOnProgressChange;
    property OnCommandStateChange: TWebBrowserCommandStateChange read FOnCommandStateChange write SetOnCommandStateChange;
    property OnTitleChange: TWebBrowserTitleChange read FOnTitleChange write SetOnTitleChange;
    property OnPropertyChange: TWebBrowserPropertyChange read FOnPropertyChange write SetOnPropertyChange;
    property OnBeforeNavigate2: TWebBrowserBeforeNavigate2 read FOnBeforeNavigate2 write SetOnBeforeNavigate2;
    property OnNewWindow2: TWebBrowserNewWindow2 read FOnNewWindow2 write SetOnNewWindow2;
    property OnNavigateComplete2: TWebBrowserNavigateComplete2 read FOnNavigateComplete2 write SetOnNavigateComplete2;
    property OnDocumentComplete: TWebBrowserDocumentComplete read FOnDocumentComplete write SetOnDocumentComplete;
    property OnVisible: TWebBrowserOnVisible read FOnVisible write SetOnVisible;
    property OnToolBar: TWebBrowserOnToolBar read FOnToolBar write SetOnToolBar;
    property OnMenuBar: TWebBrowserOnMenuBar read FOnMenuBar write SetOnMenuBar;
    property OnStatusBar: TWebBrowserOnStatusBar read FOnStatusBar write SetOnStatusBar;
    property OnFullScreen: TWebBrowserOnFullScreen read FOnFullScreen write SetOnFullScreen;
    property OnTheaterMode: TWebBrowserOnTheaterMode read FOnTheaterMode write SetOnTheaterMode;
  end;

  procedure Register;

{$R *.dcr}

implementation

const
  AlignValues: array[TKOLAlign] of string = ('caNone','caLeft','caTop','caRight','caBottom','caClient');
  Bool2Str: array [Boolean] of string = ('False','True');

procedure Register;
begin
  RegisterComponents('KOL',[TKOLWebBrowser]);
end;

constructor TKOLWebBrowser.Create;
begin
  inherited;
  FOffline:=True;
  FSilent:=True;
  FRegisterAsBrowser:=True;
  FRegisterAsDropTarget:=False;
end;

function TKOLWebBrowser.AdditionalUnits;
begin
  Result:=', KOLWebBrowser';
end;

procedure TKOLWebBrowser.SetupFirst;
begin
  SL.Add(Prefix+AName+' := NewKOLWebBrowser(Result.Form); ');
  if Align<>caNone then
    begin
      SL.Add(Prefix+AName+'.SetAlign( '+AlignValues[Align]+'); ');
    end
  else
    begin
      SL.Add(Prefix+AName+'.SetPosition(' +int2str(Left)+', '+int2str(Top)+' );');
      SL.Add(Prefix+AName+'.SetSize(' +int2str(Width)+', '+int2str(Height)+' );');
    end;
  SL.Add(Prefix+AName+'.Offline := '+Bool2Str[FOffline]+';');
  SL.Add(Prefix+AName+'.Silent := '+Bool2Str[FSilent]+';');
  SL.Add(Prefix+AName+'.RegisterAsBrowser := '+Bool2Str[FRegisterAsBrowser]+';');
  SL.Add(Prefix+AName+'.RegisterAsDropTarget := '+Bool2Str[FRegisterAsDropTarget]+';');
  AssignEvents(SL,AName);
end;

procedure TKOLWebBrowser.AssignEvents;
begin
  inherited;
  DoAssignEvents(SL,AName,
    ['OnStatusTextChange','OnProgressChange','OnCommandStateChange',
     'OnTitleChange','OnPropertyChange','OnBeforeNavigate2','OnNewWindow2',
     'OnNavigateComplete2','OnDocumentComplete','OnVisible','OnToolBar',
     'OnMenuBar','OnStatusBar','OnFullScreen','OnTheaterMode'],
    [@OnStatusTextChange,@OnProgressChange,@OnCommandStateChange,
     @OnTitleChange,@OnPropertyChange,@OnBeforeNavigate2,@OnNewWindow2,
     @OnNavigateComplete2,@OnDocumentComplete,@OnVisible,@OnToolBar,
     @OnMenuBar,@OnStatusBar,@OnFullScreen,@OnTheaterMode]);
end;

procedure TKOLWebBrowser.SetOffline;
begin
  FOffline:=V;
  Change;
end;

procedure TKOLWebBrowser.SetSilent;
begin
  FSilent:=V;
  Change;
end;

procedure TKOLWebBrowser.SetRegisterAsBrowser;
begin
  FRegisterAsBrowser:=V;
  Change;
end;

procedure TKOLWebBrowser.SetRegisterAsDropTarget;
begin
  FRegisterAsDropTarget:=V;
  Change;
end;

procedure TKOLWebBrowser.SetOnStatusTextChange;
begin
  FOnStatusTextChange:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnProgressChange;
begin
  FOnProgressChange:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnCommandStateChange;
begin
  FOnCommandStateChange:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnTitleChange;
begin
  FOnTitleChange:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnPropertyChange;
begin
  FOnPropertyChange:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnBeforeNavigate2;
begin
  FOnBeforeNavigate2:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnNewWindow2;
begin
  FOnNewWindow2:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnNavigateComplete2;
begin
  FOnNavigateComplete2:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnDocumentComplete;
begin
  FOnDocumentComplete:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnVisible;
begin
  FOnVisible:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnToolBar;
begin
  FOnToolBar:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnMenuBar;
begin
  FOnMenuBar:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnStatusBar;
begin
  FOnStatusBar:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnFullScreen;
begin
  FOnFullScreen:=E;
  Change;
end;

procedure TKOLWebBrowser.SetOnTheaterMode;
begin
  FOnTheaterMode:=E;
  Change;
end;

end.

