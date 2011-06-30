unit MCKDirTreeView;

interface

uses windows, KOL, Classes, Forms, Dialogs, mirror, mckObjs, mckCtrls,
     DirTreeView;

type
  TKOLDirTreeView = class( TKOLTreeView )
  private
    FIconOptions: TIconOptions;
    FInitialRootPath: String;
    fNotAvailable: Boolean;
    procedure SetIconOptions(const Value: TIconOptions);
    procedure SetInitialRootPath(const Value: String);
  protected
    function TypeName: String; override;
    function SetupParams( const AName, AParent: String ): String; override;
    function AdditionalUnits: String; override;
  public
  published
    constructor Create( AOwner: TComponent ); override;
    property IconOptions: TIconOptions read FIconOptions write SetIconOptions;
    property InitialRootPath: String read FInitialRootPath write SetInitialRootPath;
    property ImageListNormal: Boolean read fNotAvailable;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents( 'KOL', [ TKOLDirTreeView ] );
end;

{ TKOLDirTreeView }

function TKOLDirTreeView.AdditionalUnits: String;
begin
  Result := ', DirTreeView';
end;

constructor TKOLDirTreeView.Create(AOwner: TComponent);
begin
  inherited;
  FInitialRootPath := '*';
end;

procedure TKOLDirTreeView.SetIconOptions(const Value: TIconOptions);
begin
  FIconOptions := Value;
  Change;
end;

procedure TKOLDirTreeView.SetInitialRootPath(const Value: String);
begin
  FInitialRootPath := Value;
  Change;
end;

function TKOLDirTreeView.SetupParams(const AName, AParent: String): String;
const IconOptionsStrings: array[ TIconOptions ] of String
      = ( 'ioReal', 'ioOffline', 'ioNone' );
var S: String;
begin
  S := inherited SetupParams( AName, AParent );
  Result := Parse( S, ',' ) + ', ';
  Result := Result + Parse( S, ']' ) + '], ' + IconOptionsStrings[ IconOptions ] +
         ', ' + String2PascalStrExpr( InitialRootPath );
end;

function TKOLDirTreeView.TypeName: String;
begin
  Result := 'DirTreeView';
end;

end.
