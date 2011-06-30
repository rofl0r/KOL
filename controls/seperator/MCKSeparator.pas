unit MCKSeparator;

interface

uses KOL, Windows, Messages, Classes, Dialogs, Mirror, mckCtrls, SysUtils, KOLSeparator;

type
  TKOLSeparator = class( TKOLPanel )
  private
    FVertical: Boolean;
    FCtl1: TKOLControl;
    FCtl2: TKOLControl;
    FMinSz1: Integer;
    FMinSz2: Integer;
    procedure SetCtl1(const Value: TKOLControl);
    procedure SetCtl2(const Value: TKOLControl);
    procedure SetVertical(const Value: Boolean);
    procedure SetMinSz1(const Value: Integer);
    procedure SetMinSz2(const Value: Integer);
    procedure AdjustControls;
  protected
    FSettingBounds: Boolean;
    procedure SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function SetupParams( const AName, AParent: String ): String; override;
    function AdditionalUnits: String; override;
    function IsCursorDefault: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function ParentBorder: Integer;
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation ); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property Vertical: Boolean read FVertical write SetVertical;
    property Ctl1: TKOLControl read FCtl1 write SetCtl1;
    property Ctl2: TKOLControl read FCtl2 write SetCtl2;
    property MinSz1: Integer read FMinSz1 write SetMinSz1;
    property MinSz2: Integer read FMinSz2 write SetMinSz2;
  end;

procedure Register;

{$R *.DCR}

implementation

procedure Register;
begin
  RegisterComponents( 'KOL', [ TKOLSeparator ] );
end;

{ TKOLSeparator }

function TKOLSeparator.AdditionalUnits: String;
begin
  Result := ', KOLSeparator';
end;

procedure TKOLSeparator.AdjustControls;
var PB: Integer;
    New1, New2, H2: Integer;
begin
  PB := ParentBorder;
  if Vertical then
  begin
    New1 := 0;
    if Ctl1 <> nil then
    begin
      Top := Ctl1.Top;
      Height := Ctl1.Height;
      New1 := Left - Ctl1.Left - PB;
      if New1 < MinSz1 then
      begin
        New1 := MinSz1;
        Left := Ctl1.Left + New1 + PB;
      end;
    end;
    if Ctl2 <> nil then
    begin
      New2 := Left + Width + PB;
      if Ctl2.Left + Ctl2.Width - New2 < MinSz2 then
      begin
        New2 := Ctl2.Left + Ctl2.Width - MinSz2;
        Left := New2 - Width - PB;
      end;
      H2 := Ctl2.Left + Ctl2.Width - New2;
      Ctl2.Left := New2;
      Ctl2.Width := H2;
    end;
    if Ctl1 <> nil then
    begin
      if New1 + Ctl1.Left + PB > Left then
      begin
        New1 := Left - Ctl1.Left - PB;
        if New1 < MinSz1 then
          New1 := MinSz1;
      end;
      Ctl1.Width := New1;
    end;
  end
    else // Horizontal
  begin
    New1 := 0;
    if Ctl1 <> nil then
    begin
      Left := Ctl1.Left;
      Width := Ctl1.Width;
      New1 := Top - Ctl1.Top - PB;
      if New1 < MinSz1 then
      begin
        New1 := MinSz1;
        Top := Ctl1.Top + New1 + PB;
      end;
    end;
    if Ctl2 <> nil then
    begin
      New2 := Top + Height + PB;
      if Ctl2.Top + Ctl2.Height - New2 < MinSz2 then
      begin
        New2 := Ctl2.Top + Ctl2.Height - MinSz2;
        Top := New2 - Height - PB;
      end;
      H2 := Ctl2.Top + Ctl2.Height - New2;
      Ctl2.Top := New2;
      Ctl2.Height := H2;
    end;
    if Ctl1 <> nil then
    begin
      if New1 + Ctl1.Top + PB > Top then
      begin
        New1 := Top - Ctl1.Top - PB;
        if New1 < MinSz1 then
          New1 := MinSz1;
      end;
      Ctl1.Height := New1;
    end;
  end;
end;

constructor TKOLSeparator.Create(AOwner: TComponent);
begin
  inherited;
  Vertical := FALSE;
  Width := 20; //DefaultWidth := 20;
  Height := 4; //DefaultHeight := 4;
  EdgeStyle := esLowered;
  MinSz1 := 10;
  MinSz2 := 10;
  //Cursor := crSizeNS;
  Cursor_ := 'IDC_SIZENS';
end;

destructor TKOLSeparator.Destroy;
begin
  if Ctl1 <> nil then
    Ctl1.NotifyLinkedComponent( Self, noRemoved );
  if Ctl2 <> nil then
    Ctl2.NotifyLinkedComponent( Self, noRemoved );
  inherited;
end;

function TKOLSeparator.IsCursorDefault: Boolean;
begin
  Result := Vertical and (Cursor_='IDC_SIZEWE') or
            not Vertical and (Cursor_='IDC_SIZENS');
end;

procedure TKOLSeparator.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  inherited;
  if Operation = noRemoved then
  begin
    if Sender = Ctl1 then
      Ctl1 := nil
    else
    if Sender = Ctl2 then
      Ctl2 := nil;
  end;
  Change;
end;

function TKOLSeparator.ParentBorder: Integer;
var C: TComponent;
begin
  C := ParentKOLControl;
  if C is TKOLControl then
    Result := (C as TKOLControl).Border
  else
  if C is TKOLForm then
    Result := (C as TKOLForm).Border
  else
    Result := 2;
end;

procedure TKOLSeparator.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if not FSettingBounds then
  try
    FSettingBounds := TRUE;
    AdjustControls;
  finally
    FSettingBounds := FALSE;
  end;
end;

procedure TKOLSeparator.SetCtl1(const Value: TKOLControl);
begin
  if FCtl1 = Value then Exit;
  if FCtl1 <> nil then
    FCtl1.NotifyLinkedComponent( Self, noRemoved );
  FCtl1 := Value;
  if FCtl1 <> nil then
    FCtl1.AddToNotifyList( Self );
  AdjustControls;
  Change;
end;

procedure TKOLSeparator.SetCtl2(const Value: TKOLControl);
begin
  if FCtl2 = Value then Exit;
  if FCtl2 <> nil then
    FCtl2.NotifyLinkedComponent( Self, noRemoved );
  FCtl2 := Value;
  if FCtl2 <> nil then
    FCtl2.AddToNotifyList( Self );
  AdjustControls;
  Change;
end;

procedure TKOLSeparator.SetMinSz1(const Value: Integer);
begin
  FMinSz1 := Value;
  Change;
end;

procedure TKOLSeparator.SetMinSz2(const Value: Integer);
begin
  FMinSz2 := Value;
  Change;
end;

procedure TKOLSeparator.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: String);
var S: String;
begin
  S := GenerateTransparentInits;
  SL.Add( Prefix + AName + ' := PSeparator( NewSeparator( '
          + SetupParams( AName, AParent ) + ' ) );' );
  if S <> '' then
    SL.Add( Prefix + AName + S + ';' );
end;

procedure TKOLSeparator.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  inherited;
  if MinSz1 <> 0 then
    SL.Add( Prefix + AName + '.MinSz1 := ' + IntToStr( MinSz1 ) + ';' );
  if MinSz2 <> 0 then
    SL.Add( Prefix + AName + '.MinSz2 := ' + IntToStr( MinSz2 ) + ';' );
end;

procedure TKOLSeparator.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  inherited;
  if Ctl1 <> nil then
    SL.Add( Prefix + AName + '.Ctl1 := Result.' + Ctl1.Name + ';' );
  if Ctl2 <> nil then
    SL.Add( Prefix + AName + '.Ctl2 := Result.' + Ctl2.Name + ';' );
end;

function TKOLSeparator.SetupParams(const AName, AParent: String): String;
const EdgeStyles: array[ TEdgeStyle ] of String = ( 'esRaised', 'esLowered', 'esNone' );
      Booleans: array[ Boolean ] of String = ( 'FALSE', 'TRUE' );
      function SizeValue: Integer;
      begin
        if Vertical then Result := Height else Result := Width;
      end;
begin
  Result := AParent + ', ' + Booleans[ Vertical ] + ', ' +
            EdgeStyles[ EdgeStyle ] + ', ' + IntToStr( SizeValue );
end;

procedure TKOLSeparator.SetVertical(const Value: Boolean);
begin
  if FVertical = Value then Exit;
  FVertical := Value;
  if Value then
    Cursor_ := 'IDC_SIZEWE'
  else
    Cursor_ := 'IDC_SIZENS';
  Change;
end;

end.
