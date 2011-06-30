//////////////////////////////////////////////////
//						//
//						//
//		TKOLFlash v1.0			//
//						//
//	Author: Dimaxx (dimaxx@atnet.ru)	//
//						//
//						//
//////////////////////////////////////////////////
unit mckFlash;

interface

uses Classes, Kol, Mirror;

type
  TShockwaveFlashOnReadyStateChange = procedure(Sender: TObject; newState: Integer) of object;
  TShockwaveFlashOnProgress = procedure(Sender: TObject; percentDone: Integer) of object;
  TShockwaveFlashFSCommand = procedure(Sender: TObject; const command: WideString; const args: WideString) of object;

  TKOLFlash = class(TKOLCustomControl)
  private
    FOnFlashReadyStateChange: TShockwaveFlashOnReadyStateChange;
    FOnFlashProgress: TShockwaveFlashOnProgress;
    FOnFlashFSCommand: TShockwaveFlashFSCommand;
  public
    constructor Create(Owner: TComponent); override;
  protected
    function AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName,AParent,Prefix: string); override;
    procedure AssignEvents(SL: TStringList; const AName: string); override;
    procedure SetOnFlashReadyStateChange(E: TShockwaveFlashOnReadyStateChange);
    procedure SetOnFlashProgress(E: TShockwaveFlashOnProgress);
    procedure SetOnFlashFSCommand(E: TShockwaveFlashFSCommand);
  published
    property Align;
    property Visible;
    property OnEnter;
    property OnExit;
    property OnFlashReadyStateChange: TShockwaveFlashOnReadyStateChange read FOnFlashReadyStateChange write SetOnFlashReadyStateChange;
    property OnFlashProgress: TShockwaveFlashOnProgress read FOnFlashProgress write SetOnFlashProgress;
    property OnFlashFSCommand: TShockwaveFlashFSCommand read FOnFlashFSCommand write SetOnFlashFSCommand;
  end;

  procedure Register;

{$R mckFlash.dcr}

implementation

procedure Register;
begin
  RegisterComponents('KOL', [TKOLFlash]);
end;

constructor TKOLFlash.Create;
begin
  inherited Create(Owner);
end;

function TKOLFlash.AdditionalUnits;
begin
   Result:=', KOLFlash';
end;

procedure TKOLFlash.SetupFirst;
begin
  SL.Add(Prefix+AName+' := NewKOLFlash(Result.Form); ');
  AssignEvents(SL,AName);
end;

procedure TKOLFlash.AssignEvents;
begin
  inherited;
  DoAssignEvents(SL,AName,
    ['OnFlashReadyStateChange','OnFlashProgress','OnFlashFSCommand'],
    [@OnFlashReadyStateChange,@OnFlashProgress,@OnFlashFSCommand]);
end;

procedure TKOLFlash.SetOnFlashReadyStateChange;
begin
  FOnFlashReadyStateChange:=E;
  Change;
end;

procedure TKOLFlash.SetOnFlashProgress;
begin
  FOnFlashProgress:=E;
  Change;
end;

procedure TKOLFlash.SetOnFlashFSCommand;
begin
  FOnFlashFSCommand:=E;
  Change;
end;

end.

