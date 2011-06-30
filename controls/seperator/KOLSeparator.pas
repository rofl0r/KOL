unit KOLSeparator;

interface

uses Windows, Messages, KOL;

type
  PSeparator = ^TSeparator;
  TSeparator = object( TControl )
  private
    function GetCtl( const Index: Integer ): PControl;
    procedure SetCtl(const Index: Integer; const Value: PControl);
    function GetVertical: Boolean;
    function GetSize: Integer;
    procedure SetSize(const Value: Integer);
    function GetMinSz( const Index: Integer ): Integer;
    procedure SetMinSz(const Index, Value: Integer);
  protected
    procedure AdjustCtl1( const NewTopLeft: TPoint );
    procedure AdjustCtl2( const NewTopLeft: TPoint );
  public
    property Ctl1: PControl index 0 read GetCtl write SetCtl;
    property Ctl2: PControl index 4 read GetCtl write SetCtl;
    property MinSz1: Integer index 8 read GetMinSz write SetMinSz;
    property MinSz2: Integer index 12 read GetMinSz write SetMinSz;
    property Vertical: Boolean read GetVertical;
    property PnlSize: Integer read GetSize write SetSize;
  end;

  TKOLSeparator = PSeparator;

function NewSeparator( AOwner: PControl; AVertical: Boolean; EdgeStyle: TEdgeStyle;
         ASize: Integer ): PSeparator;

implementation

type
  PSepData = ^TSepData;
  TSepData = packed record
    Ctl1, Ctl2: PControl;
    MinSz1, MinSz2: Integer;
    Vertical: Boolean;
    Size: Integer;
    FLeftPressed: Boolean;
    FPosPressed: TPoint;
    FCtlPosWhenPressed: TPoint;
  end;

function WndProcSeparator( Sender: PControl; var Msg: TMsg; var Rslt: Integer ): Boolean;
var D: PSepData;
    NewTopLeft: TPoint;
begin
  Result := FALSE;
  D := Sender.CustomData;
  case Msg.message of
  WM_LBUTTONDOWN:
    begin
      D.FLeftPressed := TRUE;
      GetCursorPos( D.FPosPressed );
      D.FCtlPosWhenPressed := Sender.BoundsRect.TopLeft;
      SetCapture( Sender.Handle );
    end;
  WM_LBUTTONUP:
    begin
      D.FLeftPressed := FALSE;
      ReleaseCapture;
    end;
  WM_MOUSEMOVE:
    begin
      if D.FLeftPressed then
      begin
        GetCursorPos( NewTopLeft );
        NewTopLeft := MakePoint( D.FCtlPosWhenPressed.X + NewTopLeft.X - D.FPosPressed.X,
                                 D.FCtlPosWhenPressed.Y + NewTopLeft.Y - D.FPosPressed.Y );
        if D.Vertical then
          NewTopLeft.Y := D.FCtlPosWhenPressed.Y
        else
          NewTopLeft.X := D.FCtlPosWhenPressed.X;
        if D.Ctl1 <> nil then
        begin
          PSeparator( Sender ).AdjustCtl1( NewTopLeft );
          if D.Vertical then
          begin
            if NewTopLeft.x < D.Ctl1.Left + D.Ctl1.Width + D.Ctl1.Parent.Border  then
              NewTopLeft.x := D.Ctl1.Left + D.Ctl1.Width + D.Ctl1.Parent.Border;
          end
            else // Horizontal
          begin
            if NewTopLeft.y < D.Ctl1.Top + D.Ctl1.Height + D.Ctl1.Parent.Border  then
              NewTopLeft.y := D.Ctl1.Top + D.Ctl1.Height + D.Ctl1.Parent.Border;
          end;
        end;
        if D.Ctl2 <> nil then
        begin
          PSeparator( Sender ).AdjustCtl2( NewTopLeft );
          if D.Vertical then
          begin
            if NewTopLeft.x + Sender.Width > D.Ctl2.Left - D.Ctl1.Parent.Border  then
              NewTopLeft.x := D.Ctl2.Left - D.Ctl2.Parent.Border - Sender.Width;
          end
            else // Horizontal
          begin
            if NewTopLeft.y + Sender.Height > D.Ctl2.Top - D.Ctl1.Parent.Border  then
              NewTopLeft.y := D.Ctl2.Top - D.Ctl2.Parent.Border - Sender.Height;
          end;
        end;
        //PSeparator( Sender ).AdjustCtl2( NewTopLeft );
        Sender.Left := NewTopLeft.X;
        Sender.Top := NewTopLeft.Y;
      end;
    end;
  end;
end;

function NewSeparator( AOwner: PControl; AVertical: Boolean; EdgeStyle: TEdgeStyle;
         ASize: Integer ): PSeparator;
var W, H: Integer;
    D: PSepData;
begin
  Result := PSeparator( NewPanel( AOwner, EdgeStyle ) );
  GetMem( D, Sizeof( D^ ) );
  FillChar( D^, Sizeof( D^ ), 0 );
  Result.CustomData := D;
  D.Vertical := AVertical;
  D.Size := ASize;
  W := 20;
  H := 20;
  if AVertical then
  begin
    W := ASize;
    Result.Cursor := LoadCursor( 0, IDC_SIZEWE );
  end
  else
  begin
    H := ASize;
    Result.Cursor := LoadCursor( 0, IDC_SIZENS );
  end;
  Result.Width := W;
  Result.Height := H;
  Result.AttachProc( WndProcSeparator );
end;

{ TSeparator }

procedure TSeparator.AdjustCtl1( const NewTopLeft: TPoint );
var D: PSepData;
    R: TRect;
begin
  D := CustomData;
  if D.Ctl1 = nil then Exit;
  R := D.Ctl1.BoundsRect;
  if D.Vertical then
  begin
    R.Right := NewTopLeft.x - Parent.Border;
    if R.Right - R.Left < D.MinSz1 then
      R.Right := R.Left + D.MinSz1
    else if D.Ctl2 <> nil then
    if R.Right + Width + Parent.Border * 2 > D.Ctl2.Left + D.Ctl2.Width - D.MinSz2 then
      R.Right := D.Ctl2.Left + D.Ctl2.Width - D.MinSz2 - Width - Parent.Border * 2;
  end
    else
  begin
    R.Bottom := NewTopLeft.y - Parent.Border;
    if R.Bottom - R.Top < D.MinSz1 then
      R.Bottom := R.Top + D.MinSz1
    else if D.Ctl2 <> nil then
    if R.Bottom + Height + Parent.Border * 2 > D.Ctl2.Top + D.Ctl2.Height - D.MinSz2 then
      R.Bottom := D.Ctl2.Top + D.Ctl2.Height - D.MinSz2 - Height - Parent.Border * 2;
  end;
  D.Ctl1.BoundsRect := R;
end;

procedure TSeparator.AdjustCtl2( const NewTopLeft: TPoint );
var D: PSepData;
    R: TRect;
begin
  D := CustomData;
  if D.Ctl2 = nil then Exit;
  R := D.Ctl2.BoundsRect;
  if D.Vertical then
  begin
    R.Left := NewTopLeft.x + Width + Parent.Border;
    if R.Right - R.Left < D.MinSz2  then
      R.Left := R.Right - D.MinSz2;
  end
    else
  begin
    R.Top := NewTopLeft.y + Height + Parent.Border;
    if R.Bottom - R.Top < D.MinSz2  then
      R.Top := R.Bottom - D.MinSz2;
  end;
  D.Ctl2.BoundsRect := R;
end;

function TSeparator.GetCtl( const Index: Integer ): PControl;
var D: PSepData;
begin
  D := CustomData;
  Result := PControl( PDWORD( Integer( D ) + Index )^ );
end;

function TSeparator.GetMinSz( const Index: Integer ): Integer;
var D: PSepData;
begin
  D := CustomData;
  Result := PInteger( Integer( D ) + Index )^;
end;

function TSeparator.GetSize: Integer;
var D: PSepData;
begin
  D := CustomData;
  if D.Vertical then
    Result := Width
  else
    Result := Height;
end;

function TSeparator.GetVertical: Boolean;
var D: PSepData;
begin
  D := CustomData;
  Result := D.Vertical;
end;

procedure TSeparator.SetCtl(const Index: Integer; const Value: PControl);
var D: PSepData;
begin
  D := CustomData;
  PDWORD( Integer( D ) + Index )^ := DWORD( Value );
  if Value = nil then Exit;
  Assert( Value.Parent = Parent, 'Parent control must be the same for a ' +
          'separator and separated controls' );
  if Index = 0 then
  begin
    if D.Vertical then
    begin
      Left := Value.Left + Value.Width + Parent.Border;
      Top := Value.Top;
      Height := Value.Height;
    end
    else
    begin
      Left := Value.Left;
      Top := Value.Top + Value.Height + Parent.Border;
      Width := Value.Width;
    end
  end;
  AdjustCtl2( BoundsRect.TopLeft );
end;

procedure TSeparator.SetMinSz(const Index, Value: Integer);
var D: PSepData;
begin
  D := CustomData;
  PInteger( Integer( D ) + Index )^ := Value;
end;

procedure TSeparator.SetSize(const Value: Integer);
var D: PSepData;
begin
  D := CustomData;
  if D.Size = Value then Exit;
  D.Size := Value;
  if D.Vertical then
    Width := Value
  else
    Height := Value;
  AdjustCtl2( BoundsRect.TopLeft );
end;

end.
