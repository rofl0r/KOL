// 25-nov-2002
unit IdIntercept;

interface

uses KOL { , 
  Classes } ,
  IdBaseComponent, IdSocketHandle;

type
  PIdConnectionIntercept=^TIdConnectionIntercept;
  PIdServerIntercept=^TIdServerIntercept;
  TIdConnectionIntercept = object(TIdBaseComponent)
  protected
    FBinding: PIdSocketHandle;//TIdSocketHandle;
    FOnConnect: TOnEvent;//TNotifyEvent;
    FRecvHandling: Boolean;
    FSendHandling: Boolean;
    FIsClient: Boolean;
  public
    procedure Connect(ABinding: PIdSocketHandle{TIdSocketHandle}); virtual;
    procedure DataReceived(var ABuffer; const AByteCount: integer); virtual;
    procedure DataSent(var ABuffer; const AByteCount: integer); virtual;
    procedure Disconnect; virtual;
    function Recv(var ABuf; ALen: Integer): Integer; virtual;
    function Send(var ABuf; ALen: Integer): Integer; virtual;

    property Binding: PIdSocketHandle{TIdSocketHandle} read FBinding;
    property IsClient: Boolean read FIsClient;
    property RecvHandling: boolean read FRecvHandling;
    property SendHandling: boolean read FSendHandling;
   { published }
    property OnConnect: TOnEvent{TNotifyEvent} read FOnConnect write FOnConnect;
  end;
//PIdConnectionIntercept=^TIdConnectionIntercept;

  TIdServerIntercept = object(TIdBaseComponent)
  public
    procedure _Init; virtual; abstract;
    function Accept(ABinding: PIdSocketHandle{TIdSocketHandle}): PIdConnectionIntercept{TIdConnectionIntercept}; virtual;
      abstract;
  end;
//PdConnectionIntercept=^IdConnectionIntercept;
//PIdServerIntercept^=TIdServerIntercept;

function NewIdConnectionIntercept:PIdConnectionIntercept;
function NewIdServerIntercept:PIdServerIntercept;

implementation

function NewIdConnectionIntercept:PIdConnectionIntercept;
begin
  New( Result, Create );
end;

function NewIdServerIntercept:PIdServerIntercept;
begin
  New( Result, Create );
end;

procedure TIdConnectionIntercept.Disconnect;
begin
  FBinding := nil;
end;

procedure TIdConnectionIntercept.DataReceived(var ABuffer; const AByteCount:
  integer);
begin
end;

function TIdConnectionIntercept.Recv(var ABuf; ALen: Integer): Integer;
begin
  result := 0;
end;

function TIdConnectionIntercept.Send(var ABuf; ALen: Integer): Integer;
begin
  result := 0;
end;

procedure TIdConnectionIntercept.DataSent(var ABuffer; const AByteCount:
  integer);
begin
end;

procedure TIdConnectionIntercept.Connect(ABinding: PIdSocketHandle{TIdSocketHandle});
begin
  FBinding := ABinding;
  if assigned(FOnConnect) then
  begin
    FOnConnect(@Self);
  end;
end;

end.
