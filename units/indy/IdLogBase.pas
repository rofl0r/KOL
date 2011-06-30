// 26-nov-2002
unit IdLogBase;

interface

uses KOL { , 
  Classes } ,
  IdIntercept,
  IdSocketHandle;

const
  ID_LOGBASE_Active = False;
  ID_LOGBASE_LogTime = True;

type
  TIdLogBase = object(TIdConnectionIntercept)
  protected
    FActive: Boolean;
    FLogTime: Boolean;

    procedure Log(AText: string); virtual; abstract;
    procedure SetActive(const AValue: Boolean); virtual;
  public
    procedure Init; virtual;
    procedure Connect(ABinding: PIdSocketHandle{TIdSocketHandle}); virtual;//override;
     { constructor Create(AOwner: TComponent); override;
     } procedure DataReceived(var ABuffer; const AByteCount: integer);virtual;// override;
    procedure DataSent(var ABuffer; const AByteCount: integer);virtual;// override;
    procedure Disconnect; virtual;//override;
    procedure DoLog(AText: string); virtual;
   { published } 
    property Active: Boolean read FActive write SetActive default
      ID_LOGBASE_Active;
    property LogTime: Boolean read FLogTime write FLogTime default
      ID_LOGBASE_LogTime;
  end;
PIdLogBase=^TIdLogBase;
function NewIdLogBase(AOwner: PControl):PIdLogBase;

implementation

uses
  IdGlobal,
  IdResourceStrings,
  SysUtils;

procedure TIdLogBase.Connect(ABinding: PIdSocketHandle{TIdSocketHandle});
begin
  inherited;
  DoLog(RSLogConnected);
end;

function NewIdLogBase(AOwner: PControl):PIdLogBase;
//constructor TIdLogBase.Create(AOwner: TComponent);
begin
//  inherited;
  New( Result, Create );
  Result.Init;
{with Result^ do
begin
  FActive := ID_LOGBASE_Active;
  FLogTime := ID_LOGBASE_LogTime;
end;}
end;

procedure TIdLogBase.Init;
begin
    inherited;
//  New( Result, Create );
//with Result^ do
begin
  FActive := ID_LOGBASE_Active;
  FLogTime := ID_LOGBASE_LogTime;
end;
end;

procedure TIdLogBase.DataReceived(var ABuffer; const AByteCount: integer);
var
  s: string;
begin
  inherited;
  SetString(s, PChar(@ABuffer), AByteCount);
  DoLog(RSLogRecV + s);
end;

procedure TIdLogBase.DataSent(var ABuffer; const AByteCount: integer);
var
  s: string;
begin
  inherited;
  SetString(s, PChar(@ABuffer), AByteCount);
  DoLog(RSLogSent + s);
end;

procedure TIdLogBase.Disconnect;
begin
  DoLog(RSLogDisconnected);
  inherited;
end;

procedure TIdLogBase.DoLog(AText: string);
begin
  if Active then
  begin
    if LogTime then
    begin
      AText := DateTimeToStr(Now) + ': ' + AText; {Do not localize}
    end;
    Log(StringReplace(AText, EOL, RSLogEOL, [rfReplaceAll]));
  end;
end;

procedure TIdLogBase.SetActive(const AValue: Boolean);
begin
  FActive := AValue;
end;

end.
