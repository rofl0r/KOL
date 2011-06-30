unit MCKSoundCtl;

interface

uses KOL, Windows, Messages, Classes, Dialogs, Forms, Mirror, mckCtrls, SysUtils;

type
  TKOLSoundCtl = class( TKOLControl )
  private
    FPosition: Integer;
    FMaxPos: Integer;
    FMinPos: Integer;
    FThumbWidth: Integer;
    FDrawFade: Boolean;
    FOnScroll: TOnEvent;
    FControlSound: Boolean;
    procedure SetPosition(const Value: Integer);
    procedure SetMaxPos(const Value: Integer);
    procedure SetMinPos(const Value: Integer);
    procedure SetThumbWidth(const Value: Integer);
    procedure SetDrawFade(const Value: Boolean);
    procedure SetOnScroll(const Value: TOnEvent);
    procedure SetControlSound(const Value: Boolean);
  protected
    procedure SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function SetupParams( const AName, AParent: String ): String; override;
    function AdditionalUnits: String; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property Position: Integer read FPosition write SetPosition;
    property MinPos: Integer read FMinPos write SetMinPos;
    property MaxPos: Integer read FMaxPos write SetMaxPos;
    property ThumbWidth: Integer read FThumbWidth write SetThumbWidth;
    property DrawFade: Boolean read FDrawFade write SetDrawFade;
    property OnScroll: TOnEvent read FOnScroll write SetOnScroll;
    property ControlSound: Boolean read FControlSound write SetControlSound;
  end;

procedure Register;

{$R *.DCR}

implementation

procedure Register;
begin
  RegisterComponents( 'KOL', [ TKOLSoundCtl ] );
end;

{ TKOLSoundCtl }

function TKOLSoundCtl.AdditionalUnits: String;
begin
  Result := ', KOLSoundCtl';
end;

procedure TKOLSoundCtl.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnScroll' ], [ @ OnScroll ] );
end;

constructor TKOLSoundCtl.Create(AOwner: TComponent);
begin
  inherited;
  FPosition := -1;
  FMaxPos := 65535;
  FDrawFade := TRUE;
  FControlSound := TRUE;
  Width := 100; DefaultWidth := Width;
  Height := 40; DefaultHeight := Height;
end;

procedure TKOLSoundCtl.SetControlSound(const Value: Boolean);
begin
  FControlSound := Value;
  Change;
end;

procedure TKOLSoundCtl.SetDrawFade(const Value: Boolean);
begin
  FDrawFade := Value;
  Change;
end;

procedure TKOLSoundCtl.SetMaxPos(const Value: Integer);
begin
  FMaxPos := Value;
  Change;
end;

procedure TKOLSoundCtl.SetMinPos(const Value: Integer);
begin
  FMinPos := Value;
  Change;
end;

procedure TKOLSoundCtl.SetOnScroll(const Value: TOnEvent);
begin
  FOnScroll := Value;
  Change;
end;

procedure TKOLSoundCtl.SetPosition(const Value: Integer);
begin
  if FPosition = Value then Exit;
  FPosition := Value;
  Change;
end;

procedure TKOLSoundCtl.SetThumbWidth(const Value: Integer);
begin
  FThumbWidth := Value;
  Change;
end;

procedure TKOLSoundCtl.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: String);
var S: String;
begin
  S := GenerateTransparentInits;
  SL.Add( Prefix + AName + ' := NewSoundCtl( '
          + SetupParams( AName, AParent ) + ' );' );
  if S <> '' then
    SL.Add( Prefix + AName + S + ';' );
end;

procedure TKOLSoundCtl.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  inherited;
  if ControlSound then
    SL.Add( Prefix + AName + '.ControlSound( TRUE );' );
  if MinPos <> 0 then
    SL.Add( Prefix + AName + '.MinPos := ' + IntToStr( MinPos ) + ';' );
  if MaxPos <> 65535 then
    SL.Add( Prefix + AName + '.MaxPos := ' + IntToStr( MaxPos ) + ';' );
  if ThumbWidth > 0 then
    SL.Add( Prefix + AName + '.ThumbWidth := ' + IntToStr( ThumbWidth ) + ';' );
  if not DrawFade then
    SL.Add( Prefix + AName + '.DrawFade := FALSE;' );
end;

function TKOLSoundCtl.SetupParams(const AName, AParent: String): String;
begin
  Result := AParent;
end;

end.
