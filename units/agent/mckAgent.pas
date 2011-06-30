//////////////////////////////////////////////////
//						//
//						//
//		TKOLAgent v1.0			//
//						//
//	Author: Dimaxx (dimaxx@atnet.ru)	//
//						//
//						//
//////////////////////////////////////////////////
unit mckAgent;

interface

uses Classes, Kol, Mirror;

type
  TAgentActivateInput = procedure(Sender: TObject; const CharacterID: WideString) of object;
  TAgentDeactivateInput = procedure(Sender: TObject; const CharacterID: WideString) of object;
  TAgentClick = procedure(Sender: TObject; const CharacterID: WideString; Button: Smallint; Shift: Smallint; x: Smallint; y: Smallint) of object;
  TAgentDblClick = procedure(Sender: TObject; const CharacterID: WideString; Button: Smallint; Shift: Smallint; x: Smallint; y: Smallint) of object;
  TAgentDragStart = procedure(Sender: TObject; const CharacterID: WideString; Button: Smallint; Shift: Smallint; x: Smallint; y: Smallint) of object;
  TAgentDragComplete = procedure(Sender: TObject; const CharacterID: WideString; Button: Smallint; Shift: Smallint; x: Smallint; y: Smallint) of object;
  TAgentShow = procedure(Sender: TObject; const CharacterID: WideString; Cause: Smallint) of object;
  TAgentHide = procedure(Sender: TObject; const CharacterID: WideString; Cause: Smallint) of object;
  TAgentRequestStart = procedure(Sender: TObject; const Request: IDispatch) of object;
  TAgentRequestComplete = procedure(Sender: TObject; const Request: IDispatch) of object;
  TAgentBookmark = procedure(Sender: TObject; BookmarkID: Integer) of object;
  TAgentCommand = procedure(Sender: TObject; const UserInput: IDispatch) of object;
  TAgentIdleStart = procedure(Sender: TObject; const CharacterID: WideString) of object;
  TAgentIdleComplete = procedure(Sender: TObject; const CharacterID: WideString) of object;
  TAgentMove = procedure(Sender: TObject; const CharacterID: WideString; x: Smallint; y: Smallint; Cause: Smallint) of object;
  TAgentSize = procedure(Sender: TObject; const CharacterID: WideString; Width: Smallint; Height: Smallint) of object;
  TAgentBalloonShow = procedure(Sender: TObject; const CharacterID: WideString) of object;
  TAgentBalloonHide = procedure(Sender: TObject; const CharacterID: WideString) of object;
  TAgentHelpComplete = procedure(Sender: TObject; const CharacterID: WideString; const Name: WideString; Cause: Smallint) of object;
  TAgentListenStart = procedure(Sender: TObject; const CharacterID: WideString) of object;
  TAgentListenComplete = procedure(Sender: TObject; const CharacterID: WideString; Cause: Smallint) of object;
  TAgentDefaultCharacterChange = procedure(Sender: TObject; const GUID: WideString) of object;
  TAgentActiveClientChange = procedure(Sender: TObject; const CharacterID: WideString; Active: WordBool) of object;

  TKOLAgent = class(TKOLObj)
  private
    FOnActivateInput: TAgentActivateInput;
    FOnDeactivateInput: TAgentDeactivateInput;
    FOnAClick: TAgentClick;
    FOnDblClick: TAgentDblClick;
    FOnDragStart: TAgentDragStart;
    FOnDragComplete: TAgentDragComplete;
    FOnAShow: TAgentShow;
    FOnAHide: TAgentHide;
    FOnRequestStart: TAgentRequestStart;
    FOnRequestComplete: TAgentRequestComplete;
    FOnRestart: TOnEvent;
    FOnShutdown: TOnEvent;
    FOnBookmark: TAgentBookmark;
    FOnCommand: TAgentCommand;
    FOnIdleStart: TAgentIdleStart;
    FOnIdleComplete: TAgentIdleComplete;
    FOnAMove: TAgentMove;
    FOnSize: TAgentSize;
    FOnBalloonShow: TAgentBalloonShow;
    FOnBalloonHide: TAgentBalloonHide;
    FOnHelpComplete: TAgentHelpComplete;
    FOnListenStart: TAgentListenStart;
    FOnListenComplete: TAgentListenComplete;
    FOnDefaultCharacterChange: TAgentDefaultCharacterChange;
    FOnPropertyChange: TOnEvent;
    FOnActiveClientChange: TAgentActiveClientChange;
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName,AParent,Prefix: string); override;
    procedure AssignEvents(SL: TStringList; const AName: string); override;
    procedure SetActivateInput(E: TAgentActivateInput);
    procedure SetDeactivateInput(E: TAgentDeactivateInput);
    procedure SetAClick(E: TAgentClick);
    procedure SetDblClick(E: TAgentDblClick);
    procedure SetDragStart(E: TAgentDragStart);
    procedure SetDragComplete(E: TAgentDragComplete);
    procedure SetAShow(E: TAgentShow);
    procedure SetAHide(E: TAgentHide);
    procedure SetRequestStart(E: TAgentRequestStart);
    procedure SetRequestComplete(E: TAgentRequestComplete);
    procedure SetRestart(E: TOnEvent);
    procedure SetShutdown(E: TOnEvent);
    procedure SetBookmark(E: TAgentBookmark);
    procedure SetCommand(E: TAgentCommand);
    procedure SetIdleStart(E: TAgentIdleStart);
    procedure SetIdleComplete(E: TAgentIdleComplete);
    procedure SetAMove(E: TAgentMove);
    procedure SetSize(E: TAgentSize);
    procedure SetBalloonShow(E: TAgentBalloonShow);
    procedure SetBalloonHide(E: TAgentBalloonHide);
    procedure SetHelpComplete(E: TAgentHelpComplete);
    procedure SetListenStart(E: TAgentListenStart);
    procedure SetListenComplete(E: TAgentListenComplete);
    procedure SetDefaultCharacterChange(E: TAgentDefaultCharacterChange);
    procedure SetPropertyChange(E: TOnEvent);
    procedure SetActiveClientChange(E: TAgentActiveClientChange);
  published
    property OnActivateInput: TAgentActivateInput read FOnActivateInput write SetActivateInput;
    property OnDeactivateInput: TAgentDeactivateInput read FOnDeactivateInput write SetDeactivateInput;
    property OnClick: TAgentClick read FOnAClick write SetAClick;
    property OnDblClick: TAgentDblClick read FOnDblClick write SetDblClick;
    property OnDragStart: TAgentDragStart read FOnDragStart write SetDragStart;
    property OnDragComplete: TAgentDragComplete read FOnDragComplete write SetDragComplete;
    property OnShow: TAgentShow read FOnAShow write SetAShow;
    property OnHide: TAgentHide read FOnAHide write SetAHide;
    property OnRequestStart: TAgentRequestStart read FOnRequestStart write SetRequestStart;
    property OnRequestComplete: TAgentRequestComplete read FOnRequestComplete write SetRequestComplete;
    property OnRestart: TOnEvent read FOnRestart write SetRestart;
    property OnShutdown: TOnEvent read FOnShutdown write SetShutdown;
    property OnBookmark: TAgentBookmark read FOnBookmark write SetBookmark;
    property OnCommand: TAgentCommand read FOnCommand write SetCommand;
    property OnIdleStart: TAgentIdleStart read FOnIdleStart write SetIdleStart;
    property OnIdleComplete: TAgentIdleComplete read FOnIdleComplete write SetIdleComplete;
    property OnMove: TAgentMove read FOnAMove write SetAMove;
    property OnSize: TAgentSize read FOnSize write SetSize;
    property OnBalloonShow: TAgentBalloonShow read FOnBalloonShow write SetBalloonShow;
    property OnBalloonHide: TAgentBalloonHide read FOnBalloonHide write SetBalloonHide;
    property OnHelpComplete: TAgentHelpComplete read FOnHelpComplete write SetHelpComplete;
    property OnListenStart: TAgentListenStart read FOnListenStart write SetListenStart;
    property OnListenComplete: TAgentListenComplete read FOnListenComplete write SetListenComplete;
    property OnDefaultCharacterChange: TAgentDefaultCharacterChange read FOnDefaultCharacterChange write SetDefaultCharacterChange;
    property OnPropertyChange: TOnEvent read FOnPropertyChange write SetPropertyChange;
    property OnActiveClientChange: TAgentActiveClientChange read FOnActiveClientChange write SetActiveClientChange;
  end;

  procedure Register;

{$R mckAgent.dcr}

implementation

procedure Register;
begin
  RegisterComponents('KOL', [TKOLAgent]);
end;

function TKOLAgent.AdditionalUnits;
begin
   Result:=', KOLAgent';
end;

procedure TKOLAgent.SetupFirst;
begin
  SL.Add(Prefix+AName+' := NewKOLAgent(Result.Form);');
  AssignEvents(SL,AName);
end;

procedure TKOLAgent.AssignEvents;
begin
  inherited;
  DoAssignEvents(SL,AName,
    ['OnActivateInput','OnDeactivateInput','OnClick','OnDblClick','OnDragStart',
     'OnDragComplete','OnShow','OnHide','OnRequestStart','OnRequestComplete',
     'OnRestart','OnShutdown','OnBookmark','OnCommand','OnIdleStart','OnIdleComplete',
     'OnMove','OnSize','OnBalloonShow','OnBalloonHide','OnHelpComplete','OnListenStart',
     'OnListenComplete','OnDefaultCharacterChange','OnPropertyChange','OnActiveClientChange'],
    [@OnActivateInput,@OnDeactivateInput,@OnClick,@OnDblClick,@OnDragStart,
     @OnDragComplete,@OnShow,@OnHide,@OnRequestStart,@OnRequestComplete,
     @OnRestart,@OnShutdown,@OnBookmark,@OnCommand,@OnIdleStart,@OnIdleComplete,
     @OnMove,@OnSize,@OnBalloonShow,@OnBalloonHide,@OnHelpComplete,@OnListenStart,
     @OnListenComplete,@OnDefaultCharacterChange,@OnPropertyChange,@OnActiveClientChange]);
end;

procedure TKOLAgent.SetActivateInput(E: TAgentActivateInput);
begin
   fOnActivateInput:=E;
   Change;
end;

procedure TKOLAgent.SetDeactivateInput(E: TAgentDeactivateInput);
begin
   fOnDeactivateInput:=E;
   Change;
end;

procedure TKOLAgent.SetAClick(E: TAgentClick);
begin
   fOnAClick:=E;
   Change;
end;

procedure TKOLAgent.SetDblClick(E: TAgentDblClick);
begin
   fOnDblClick:=E;
   Change;
end;

procedure TKOLAgent.SetDragStart(E: TAgentDragStart);
begin
   fOnDragStart:=E;
   Change;
end;

procedure TKOLAgent.SetDragComplete(E: TAgentDragComplete);
begin
   fOnDragComplete:=E;
   Change;
end;

procedure TKOLAgent.SetAShow(E: TAgentShow);
begin
   fOnAShow:=E;
   Change;
end;

procedure TKOLAgent.SetAHide(E: TAgentHide);
begin
   fOnAHide:=E;
   Change;
end;

procedure TKOLAgent.SetRequestStart(E: TAgentRequestStart);
begin
   fOnRequestStart:=E;
   Change;
end;

procedure TKOLAgent.SetRequestComplete(E: TAgentRequestComplete);
begin
   fOnRequestComplete:=E;
   Change;
end;

procedure TKOLAgent.SetRestart(E: TOnEvent);
begin
   fOnRestart:=E;
   Change;
end;

procedure TKOLAgent.SetShutdown(E: TOnEvent);
begin
   fOnShutdown:=E;
   Change;
end;

procedure TKOLAgent.SetBookmark(E: TAgentBookmark);
begin
   fOnBookmark:=E;
   Change;
end;

procedure TKOLAgent.SetCommand(E: TAgentCommand);
begin
   fOnCommand:=E;
   Change;
end;

procedure TKOLAgent.SetIdleStart(E: TAgentIdleStart);
begin
   fOnIdleStart:=E;
   Change;
end;

procedure TKOLAgent.SetIdleComplete(E: TAgentIdleComplete);
begin
   fOnIdleComplete:=E;
   Change;
end;

procedure TKOLAgent.SetAMove(E: TAgentMove);
begin
   fOnAMove:=E;
   Change;
end;

procedure TKOLAgent.SetSize(E: TAgentSize);
begin
   fOnSize:=E;
   Change;
end;

procedure TKOLAgent.SetBalloonShow(E: TAgentBalloonShow);
begin
   fOnBalloonShow:=E;
   Change;
end;

procedure TKOLAgent.SetBalloonHide(E: TAgentBalloonHide);
begin
   fOnBalloonHide:=E;
   Change;
end;

procedure TKOLAgent.SetHelpComplete(E: TAgentHelpComplete);
begin
   fOnHelpComplete:=E;
   Change;
end;

procedure TKOLAgent.SetListenStart(E: TAgentListenStart);
begin
   fOnListenStart:=E;
   Change;
end;

procedure TKOLAgent.SetListenComplete(E: TAgentListenComplete);
begin
   fOnListenComplete:=E;
   Change;
end;

procedure TKOLAgent.SetDefaultCharacterChange(E: TAgentDefaultCharacterChange);
begin
   fOnDefaultCharacterChange:=E;
   Change;
end;

procedure TKOLAgent.SetPropertyChange(E: TOnEvent);
begin
   fOnPropertyChange:=E;
   Change;
end;

procedure TKOLAgent.SetActiveClientChange(E: TAgentActiveClientChange);
begin
   fOnActiveClientChange:=E;
   Change;
end;

end.

