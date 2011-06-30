// 26-nov-2002
unit IdLogDebug;

interface

uses KOL { , 
  Classes } ,
  IdLogBase{,
  IdException,},
  IdSocketHandle;

type
  TIdLogDebugTarget = (ltFile, ltDebugOutput, ltEvent);
const
  ID_TIDLOGDEBUG_TARGET = ltFile;
type
  TLogItemEvent = procedure(ASender: PObj{TComponent}; var AText: string) of object;

  TIdLogDebug = object(TIdLogBase)
  protected
    FFilename: string;
    FFileStream: PStream;//TFileStream;
    FOnLogItem: TLogItemEvent;
    FTarget: TIdLogDebugTarget;

    procedure Log(AText: string); virtual;//override;
    procedure SetActive(const AValue: Boolean);virtual;// override;
    procedure SetTarget(const AValue: TIdLogDebugTarget);
  public
    procedure Init; virtual;
//    constructor Create(AOwner: TComponent); override;
    destructor Destroy; virtual; // override;
//  published
    property Filename: string read FFilename write FFilename;
    property OnLogItem: TLogItemEvent read FOnLogItem write FOnLogItem;
    property Target: TIdLogDebugTarget read FTarget write SetTarget default
      ID_TIDLOGDEBUG_TARGET;
  end;
  PIdLogDebug=^TIdLogDebug;
  function NewIdLogDebug (AOwner: {PControl}PObj):PIdLogDebug;
{  EIdCanNotChangeTarget = class(EIdException);}

implementation

uses
  IdGlobal,
  IdResourceStrings,
  SysUtils;

 { constructor TIdLogDebug.Create(AOwner: TComponent);
 }
function NewIdLogDebug (AOwner: {TComponent}PObj):PIdLogDebug;
begin
//  inherited;
  New( Result, Create );
  Result.Init;
//with Result^ do
//  FTarget := ID_TIDLOGDEBUG_TARGET;
end;

procedure TIdLogDebug.Init;
begin
  inherited;
  FTarget := ID_TIDLOGDEBUG_TARGET;
end;

destructor TIdLogDebug.Destroy;
begin
  Active := False;
  inherited;
end;

procedure TIdLogDebug.Log(AText: string);
var
  s: string;
begin
  if assigned(OnLogItem) then
  begin
    OnLogItem(@Self, AText);
  end;
  case Target of
    ltFile:
      begin
        FFileStream.Write{Buffer}(PChar(AText)^, Length(AText));
        s := EOL;
        FFileStream.Write{Buffer}(PChar(s)^, Length(s));
      end;
    ltDebugOutput:
      begin
        DebugOutput(AText + EOL);
      end;
  end;
end;

procedure TIdLogDebug.SetActive(const AValue: Boolean);
begin
  if AValue then
  begin
    case Target of
      ltFile:
//        if not (csLoading in ComponentState) then
        begin
          if FileExists(Filename) then
          begin
            FFileStream := NewFileStream(Filename,fmOpenReadWrite);//TFileStream.Create(Filename, fmOpenReadWrite);
          end
          else
          begin
            FFileStream := NewFileStream(Filename,fmOpenReadWrite or ofCreateAlways);//TFileStream.Create(Filename, fmCreate);
          end;
          FFileStream.Position := FFileStream.Size;
        end;
    end;
  end
  else
  begin
    case Target of
      ltFile:
        begin
          FreeAndNil(FFileStream);
        end;
    end;
  end;
  inherited;
end;

procedure TIdLogDebug.SetTarget(const AValue: TIdLogDebugTarget);
begin
{  if ([csLoading, csDesigning] * ComponentState = []) and Active then
  begin
    raise EIdCanNotChangeTarget.Create(RSCannotChangeDebugTargetAtWhileActive);
  end;       }
  FTarget := AValue;
end;

end.
