unit MCKReport;

interface

uses KOL, Windows, Messages, Dialogs, Forms, Classes, Controls, Graphics, SysUtils,
     mirror, mckCtrls, KOLReport;

type
  TKOLReport = class( TKOLObj )
  private
    FOnNewBand: TOnEvent;
    FOnPrint: TOnEvent;
    FOnNewPage: TOnEvent;
    FDoubleBufferedPreview: Boolean;
    FDocumentName: String;
    procedure SetOnNewBand(const Value: TOnEvent);
    procedure SetOnNewPage(const Value: TOnEvent);
    procedure SetOnPrint(const Value: TOnEvent);
    procedure SetDoubleBufferedPreview(const Value: Boolean);
    procedure SetDocumentName(const Value: String);
  protected
    function AdditionalUnits: String; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
  published
    property OnPrint: TOnEvent read FOnPrint write SetOnPrint;
    property OnNewPage: TOnEvent read FOnNewPage write SetOnNewPage;
    property OnNewBand: TOnEvent read FOnNewBand write SetOnNewBand;
    property DoubleBufferedPreview: Boolean read FDoubleBufferedPreview write SetDoubleBufferedPreview;
    property DocumentName: String read FDocumentName write SetDocumentName;
  end;

  TKOLBand = class( TKOLPanel )
  private
    FFrames: TFrames;
    procedure SetFrames(const Value: TFrames);
  protected
    function SetupParams( const AName, AParent: String ): String; override;
    function AdditionalUnits: String; override;
    function NoDrawFrame: Boolean; override;
    procedure Set_VA(const Value: TVerticalAlign); override;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure Paint; override;
  published
    property Frames: TFrames read FFrames write SetFrames;
  end;

  TKOLReportLabel = class( TKOLLabel )
  private
    FFrames: TFrames;
    procedure SetFrames(const Value: TFrames);
  protected
    function SetupParams( const AName, AParent: String ): String; override;
    function AdditionalUnits: String; override;
    function TypeName: String; override;
    function NoDrawFrame: Boolean; override;
    function AdjustVerticalAlign( Value: TVerticalAlign ): TVerticalAlign; override;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure Paint; override;
    function BorderNeeded: Boolean; override;
  published
    property Frames: TFrames read FFrames write SetFrames;
    property Border;
  end;

procedure Register;

{$R KOLReport.dcr}

implementation

procedure Register;
begin
  RegisterComponents( 'KOL', [ TKOLReport, TKOLBand, TKOLReportLabel ] );
end;

function CalcFrames( const Frames: TFrames ): String;
begin
  Result := '';
  if frLeft in Frames then
    Result := 'frLeft,';
  if frTop in Frames then
    Result := Result + 'frTop,';
  if frRight in Frames then
    Result := Result + 'frRight,';
  if frBottom in Frames then
    Result := Result + 'frBottom,';
  if Result <> '' then
    Delete( Result, Length( Result ), 1 );
  Result := '[' + Result + ']';
end;

type
  TFakeControl = class( TControl )
  public
    property Color;
  end;

{ TKOLReport }

function TKOLReport.AdditionalUnits: String;
begin
  Result := inherited AdditionalUnits + ', KOLReport';
end;

procedure TKOLReport.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnPrint', 'OnNewPage', 'OnNewBand' ],
                             [ @ OnPrint, @ OnNewPage, @ OnNewBand ] );
end;

procedure TKOLReport.SetDocumentName(const Value: String);
begin
  FDocumentName := Value;
  Change;
end;

procedure TKOLReport.SetDoubleBufferedPreview(const Value: Boolean);
begin
  FDoubleBufferedPreview := Value;
  Change;
end;

procedure TKOLReport.SetOnNewBand(const Value: TOnEvent);
begin
  FOnNewBand := Value;
  Change;
end;

procedure TKOLReport.SetOnNewPage(const Value: TOnEvent);
begin
  FOnNewPage := Value;
  Change;
end;

procedure TKOLReport.SetOnPrint(const Value: TOnEvent);
begin
  FOnPrint := Value;
  Change;
end;

procedure TKOLReport.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  inherited;
  if DoubleBufferedPreview then
    SL.Add( Prefix + AName + '.DoubleBufferedPreview := TRUE;' );
  if Trim( DocumentName ) <> '' then
    SL.Add( Prefix + AName + '.DocumentName := ' + String2PascalStrExpr( DocumentName ) + ';' );
end;

{ TKOLBand }

function TKOLBand.AdditionalUnits: String;
begin
  Result := inherited AdditionalUnits + ', KOLReport';
end;

constructor TKOLBand.Create(AOwner: TComponent);
begin
  inherited;
  EdgeStyle := esNone;
  if (AOwner <> nil) and (AOwner is TControl) and
     (TFakeControl(AOwner).Color = clWhite) then
  else
  begin
    ParentColor := FALSE;
    Color := clWhite;
  end;
  if (AOwner <> nil) and (AOwner is TControl) and
     (TFakeControl(AOwner).Font.Color = clBlack) and
     (TFakeControl(AOwner).Font.Name = 'Arial') then
  else
  begin
    ParentFont := FALSE;
    Font.Color := clBlack;
    Font.FontName := 'Arial';
  end;
  Width := 400;
  Height := 40;
  Border := 1;
end;

function TKOLBand.NoDrawFrame: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLBand.Paint;
var W, H, B: Integer;
begin
  inherited;
  Canvas.Brush.Color := Font.Color;
  W := ClientWidth;
  H := ClientHeight;
  B := Border;
  if frLeft in Frames then
    Canvas.FillRect( Rect( 0, 0, B, H ) );
  if frTop in Frames then
    Canvas.FillRect( Rect( 0, 0, W, B ) );
  if frRight in Frames then
    Canvas.FillRect( Rect( W - B, 0, W, H ) );
  if frBottom in Frames then
    Canvas.FillRect( Rect( 0, H - B, W, H ) );
end;

procedure TKOLBand.SetFrames(const Value: TFrames);
begin
  FFrames := Value;
  Change;
  Invalidate;
end;

function TKOLBand.SetupParams(const AName, AParent: String): String;
begin
  Result := AParent + ', ' + CalcFrames( Frames );
end;

procedure TKOLBand.Set_VA(const Value: TVerticalAlign);
begin
  fVerticalAlign := Value;
  Change;
  Invalidate;
end;

{ TKOLReportLabel }

function TKOLReportLabel.AdditionalUnits: String;
begin
  Result := inherited AdditionalUnits + ', KOLReport';
end;

function TKOLReportLabel.AdjustVerticalAlign(
  Value: TVerticalAlign): TVerticalAlign;
begin
  Result := Value;
end;

function TKOLReportLabel.BorderNeeded: Boolean;
begin
  Result := TRUE;
end;

constructor TKOLReportLabel.Create(AOwner: TComponent);
begin
  inherited;
  if (AOwner <> nil) and (AOwner is TControl) and
     (TFakeControl(AOwner).Color = clWhite) then
  else
  begin
    ParentColor := FALSE;
    Color := clWhite;
  end;
  if (AOwner <> nil) and (AOwner is TControl) and
     (TFakeControl(AOwner).Font.Color = clBlack) and
     (TFakeControl(AOwner).Font.Name = 'Arial') then
  else
  begin
    ParentFont := FALSE;
    Font.Color := clBlack;
    Font.FontName := 'Arial';
  end;
  Border := 1;
  DefaultAutoSize := TRUE;
  AutoSize := TRUE;
end;

function TKOLReportLabel.NoDrawFrame: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLReportLabel.Paint;
var W, H, B: Integer;
begin
  inherited;
  Canvas.Brush.Color := Font.Color;
  W := ClientWidth;
  H := ClientHeight;
  B := Border;
  if frLeft in Frames then
    Canvas.FillRect( Rect( 0, 0, B, H ) );
  if frTop in Frames then
    Canvas.FillRect( Rect( 0, 0, W, B ) );
  if frRight in Frames then
    Canvas.FillRect( Rect( W - B, 0, W, H ) );
  if frBottom in Frames then
    Canvas.FillRect( Rect( 0, H - B, W, H ) );
end;

procedure TKOLReportLabel.SetFrames(const Value: TFrames);
begin
  FFrames := Value;
  Change;
  Invalidate;
end;

function TKOLReportLabel.SetupParams(const AName, AParent: String): String;
begin
  Result := inherited SetupParams( AName, AParent ) + ', ' + CalcFrames( Frames );
end;

function TKOLReportLabel.TypeName: String;
begin
  if WordWrap then
    Result := 'WordWrapReportLabel'
  else
    Result := 'ReportLabel';
end;

end.
