// 19-nov-2002
unit IdBaseComponent;

interface

uses KOL;

type
  PIdBaseComponent=^TIdBaseComponent;
  TIdBaseComponent = object(TObj)
  protected
    FAOwner:PObj;
    FOwner:PObj;
  public
    procedure Init; virtual;
    function GetVersion: string;
    property Version: string read GetVersion;
  end;

function NewIdBaseComponent(axOwner: PObj):PIdBaseComponent;

implementation

uses
  IdGlobal;

function NewIdBaseComponent(axOwner: PObj):PIdBaseComponent;
begin
  New( Result, Create );
  Result.FAOwner:=axOwner;
  Result.Init;
end;

function TIdBaseComponent.GetVersion: string;
begin
  Result := gsIdVersion;
end;

procedure TIdBaseComponent.Init;
begin
  FAOwner:=FOwner;
  inherited;
end;

end.
