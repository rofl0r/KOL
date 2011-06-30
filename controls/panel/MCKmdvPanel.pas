unit MCKmdvPanel;

interface

uses Windows, Messages, Classes, mckCtrls, KOL, Controls, mirror, KOLmdvPanel, Graphics;

type

  TKOLmdvPanel = class(TKOLPanel)
  private
    FBevelOuter: TBevelCut;
    FBevelInner: TBevelCut;
    FBevelWidth: Word;
    FBorderWidth: Word;
    FBorderStyle: TBorderStyle;
    FNone: Boolean;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure SetBevelInner(const Value: TBevelCut);
    procedure SetBevelOuter(const Value: TBevelCut);
    procedure SetBevelWidth(const Value: Word);
    procedure SetBorderWidth(const Value: Word);
    procedure SetBorderStyle(const Value: TBorderStyle);

    procedure UpdateBorder;
  protected
    procedure Set_VA(const Value: TVerticalAlign); override;
    function AdditionalUnits: string; override;
    procedure SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function SetupParams( const AName, AParent: String ): String; override;

    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property BevelOuter: TBevelCut read FBevelOuter write SetBevelOuter;
    property BevelInner: TBevelCut read FBevelInner write SetBevelInner;
    property BevelWidth: Word read FBevelWidth write SetBevelWidth;
    property BorderWidth: Word read FBorderWidth write SetBorderWidth;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;

    property edgeStyle: Boolean read FNone;
    property Border: Boolean read FNone;
  end;

procedure Register;

implementation

{$R *.dcr}

procedure Register;
begin
  RegisterComponents( 'KOL Additional', [TKOLmdvPanel]);
end;

{ TKOLmdvPanel }

function TKOLmdvPanel.AdditionalUnits: string;
begin
    Result := ', KOLmdvPanel';
end;

constructor TKOLmdvPanel.Create(AOwner: TComponent);
begin
    inherited;
    BevelOuter:= bvRaised;
    BevelInner:= bvNone;
    BevelWidth:= 1;
    BorderWidth:= 0;
    BorderStyle:= bsNone;
    Width:= 105; Height:= 105;
    inherited edgeStyle:= esNone;
end;

procedure TKOLmdvPanel.CreateParams(var Params: TCreateParams);
const BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
    with Params do
    begin
      Style := Style and (not WS_BORDER); ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
      Style := Style or BorderStyles[FBorderStyle];
      if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
      begin
        Style := Style and not WS_BORDER;
        ExStyle := ExStyle or WS_EX_CLIENTEDGE;
      end;
      WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
    end;
end;

destructor TKOLmdvPanel.Destroy;
begin

  inherited;
end;

procedure Frame3D(Canvas: TCanvas; var Rect: TRect; TopColor, BottomColor: TColor; Width: Integer);
  procedure DoRect;
  var
    TopRight, BottomLeft: TPoint;
  begin
    with Canvas, Rect do
    begin
      TopRight.X := Right;
      TopRight.Y := Top;
      BottomLeft.X := Left;
      BottomLeft.Y := Bottom;
      Pen.Color := TopColor;
      PolyLine([BottomLeft, TopLeft, TopRight]);
      Pen.Color := BottomColor;
      Dec(BottomLeft.X);
      PolyLine([TopRight, BottomRight, BottomLeft]);
    end;
  end;

begin
  Canvas.Pen.Width := 1;
  Dec(Rect.Bottom); Dec(Rect.Right);
  while Width > 0 do
  begin
    Dec(Width);
    DoRect;
    InflateRect(Rect, -1, -1);
  end;
  Inc(Rect.Bottom); Inc(Rect.Right);
end;

procedure TKOLmdvPanel.Paint;
const Alignments: array[TTextAlign] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
      VAlignments: array[TVerticalAlign] of Longint = (DT_TOP, DT_VCENTER, DT_BOTTOM);
var           
  Rect: TRect;
  TopColor, BottomColor: TColor;
  Flags: Longint;

  procedure AdjustColors(Bevel: KOLmdvPanel.TBevelCut);
  begin
    TopColor := clBtnHighlight;
    if Bevel = KOLmdvPanel.bvLowered then TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = KOLmdvPanel.bvLowered then BottomColor := clBtnHighlight;
  end;

begin
    Rect := GetClientRect;
    if BevelOuter <> KOLmdvPanel.bvNone then
    begin
      AdjustColors(BevelOuter);
      Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
    end;
    Frame3D(Canvas, Rect, Color, Color, BorderWidth);
    if BevelInner <> KOLmdvPanel.bvNone then
    begin
      AdjustColors(BevelInner);
      Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
    end;
    with Canvas do
    begin
      Brush.Color := Color;
      FillRect(Rect);
      Brush.Style := bsClear;
      PrepareCanvasFontForWYSIWIGPaint(Canvas);
      Flags := DT_EXPANDTABS or DT_SINGLELINE or VAlignments[VerticalAlign] or Alignments[TextAlign];
      DrawText(Handle, PChar(Caption), -1, Rect, Flags);
    end;
end;

procedure TKOLmdvPanel.SetBevelInner(const Value: KOLmdvPanel.TBevelCut);
begin
    FBevelInner := Value;
    UpdateBorder;
    Invalidate;
    Change;
end;

procedure TKOLmdvPanel.SetBevelOuter(const Value: KOLmdvPanel.TBevelCut);
begin
    FBevelOuter := Value;
    UpdateBorder;
    Invalidate;
    Change;
end;

procedure TKOLmdvPanel.SetBevelWidth(const Value: Word);
begin
    FBevelWidth := Value;
    UpdateBorder;
    Invalidate;
    Change;
end;

procedure TKOLmdvPanel.SetBorderStyle(const Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    UpdateBorder;
    RecreateWnd;
  end;
  Change;
end;

procedure TKOLmdvPanel.SetBorderWidth(const Value: Word);
begin
    FBorderWidth := Value;
    UpdateBorder;
    Invalidate;
    Change;
end;

procedure TKOLmdvPanel.SetupConstruct(SL: TStringList; const AName, AParent, Prefix: String);
begin
    SL.Add( Prefix + AName + ' := PmdvPanel( New' + TypeName + '( ' + SetupParams( AName, AParent ) + ' )' + GenerateTransparentInits + ');');
end;

function TKOLmdvPanel.SetupParams(const AName, AParent: String): String;
const  EdgeStyles: array[TEdgeStyle] of String =('esRaised', 'esLowered', 'esNone');
       BevelCuts: array[TBevelCut] of String =('bvNone', 'bvLowered', 'bvRaised', 'bvSpace');
       BorderStyles: array[TBorderStyle] of String =('bsNone', 'bsSingle');
begin
    Result := AParent + ', ' + BevelCuts[BevelOuter] + ', ' +
                               BevelCuts[BevelInner] + ', ' + Int2Str(BevelWidth) + ', ' +
                               BorderStyles[BorderStyle] + ', ' + Int2Str(BorderWidth);
end;

procedure TKOLmdvPanel.Set_VA(const Value: TVerticalAlign);
begin
    FVerticalAlign:= Value;
    Invalidate;
    Change;
end;

procedure TKOLmdvPanel.UpdateBorder;
begin
    inherited Border:= FBorderWidth + BevelWidth*Ord(BevelOuter <> bvNone) + BevelWidth*Ord(BevelInner <> bvNone);
    Invalidate;
end;

procedure TKOLmdvPanel.WMSize(var Message: TWMSize);
begin
    inherited;
    Invalidate;
end;

end.
