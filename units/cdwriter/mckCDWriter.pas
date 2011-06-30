//////////////////////////////////////////////////////////////////
//								//
//								//
//			TKOLCDWriter v1.0			//
//								//
//	ActiveX: Vision Factory	(www.vision-factory.com)	//
//	Converted: Dimaxx (dimaxx@atnet.ru)			//
//								//
//								//
//////////////////////////////////////////////////////////////////
unit mckCDWriter;

interface

uses Classes, Kol, Mirror;

type
  TCDWriterOnError = procedure(Sender: TObject; ErrorCode: smallint; const ErrMsg: WideString) of object;
  TCDWriterOnSCSIScan = procedure(Sender: TObject; Adapter: smallint; ID: smallint; Lun: smallint; 
                                  const Product: WideString; const ProductIdent: WideString; 
                                  const ProductRevision: WideString; devType: smallint) of object;
  TCDWriterOnWritingProcess = procedure(Sender: TObject; Track: smallint; BytesWritten: integer; 
                                        TotalAmount: integer) of object;
  TCDWriterOnStatus = procedure(Sender: TObject; Code: smallint; const Message: WideString) of object;

  TKOLCDWriter = class(TKOLObj)
  private
    FOnError: TCDWriterOnError;
    FOnSCSIScan: TCDWriterOnSCSIScan;
    FOnWritingProcess: TCDWriterOnWritingProcess;
    FOnStatus: TCDWriterOnStatus;
    FOnCommandDone: TOnEvent;
    procedure SetOnError(E: TCDWriterOnError);
    procedure SetOnSCSIScan(E: TCDWriterOnSCSIScan);
    procedure SetOnWritingProcess(E: TCDWriterOnWritingProcess);
    procedure SetOnStatus(E: TCDWriterOnStatus);
    procedure SetOnCommandDone(E: TOnEvent);
  public
    constructor Create(Owner: TComponent); override;
  protected
    function AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName,AParent,Prefix: string); override;
    procedure AssignEvents(SL: TStringList; const AName: string); override;
  published
    property OnError: TCDWriterOnError read FOnError write SetOnError;
    property OnSCSIScan: TCDWriterOnSCSIScan read FOnSCSIScan write SetOnSCSIScan;
    property OnWritingProcess: TCDWriterOnWritingProcess read FOnWritingProcess write SetOnWritingProcess;
    property OnStatus: TCDWriterOnStatus read FOnStatus write SetOnStatus;
    property OnCommandDone: TOnEvent read FOnCommandDone write SetOnCommandDone;
  end;

  procedure Register;

{$R mckCDWriter.dcr}

implementation

procedure Register;
begin
  RegisterComponents('KOL', [TKOLCDWriter]);
end;

constructor TKOLCDWriter.Create;
begin
  inherited Create(Owner);
end;

function TKOLCDWriter.AdditionalUnits;
begin
   Result:=', KOLCDWriter';
end;

procedure TKOLCDWriter.SetupFirst;
begin
  SL.Add(Prefix+AName+' := NewCDWriter(Result.Form); ');
  AssignEvents(SL,AName);
end;

procedure TKOLCDWriter.AssignEvents;
begin
  inherited;
  DoAssignEvents(SL,AName,
    ['OnError','OnSCSIScan','OnWritingProcess','OnStatus','OnCommandDone'],
    [@OnError,@OnSCSIScan,@OnWritingProcess,@OnStatus,@OnCommandDone]);
end;

procedure TKOLCDWriter.SetOnError(E: TCDWriterOnError);
begin
  FOnError:=E;
  Change;
end;

procedure TKOLCDWriter.SetOnSCSIScan(E: TCDWriterOnSCSIScan);
begin
  FOnSCSIScan:=E;
  Change;
end;

procedure TKOLCDWriter.SetOnWritingProcess(E: TCDWriterOnWritingProcess);
begin
  FOnWritingProcess:=E;
  Change;
end;

procedure TKOLCDWriter.SetOnStatus(E: TCDWriterOnStatus);
begin
  FOnStatus:=E;
  Change;
end;

procedure TKOLCDWriter.SetOnCommandDone(E: TOnEvent);
begin
  FOnCommandDone:=E;
  Change;
end;

end.

