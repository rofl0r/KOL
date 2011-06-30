unit mckmdvGliphLabel;

interface

uses
  Windows, Messages, Classes, Controls, mckCtrls, KOL, mirror, Graphics, KOLmdvGliphLabel, mckObjs;

type

  TKOLmdvGliphLabel = class(TKOLControl)
  private
    FGlyphBitmap: TBitmap;
    FAlphabet: String;
    FTransparentLabel: Boolean;
    FTransparentColor: TColor;
    procedure SetGlyphBitmap(const Value: TBitmap);
    procedure SetAlphabet(const Value: String);
    procedure SetTransparentColor(const Value: TColor);
    procedure SetTransparentLabel(const Value: Boolean);
    // fNotAvailable: Boolean;

    // fOnMyEvent: TOnMyEvent;
    // procedure SetOnMyEvent(Value: TOnMyEvent);

  protected
    function AdditionalUnits: String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function SetupParams(const AName, AParent: String): String; override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure AssignEvents(SL: TStringList; const AName: String); override;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;

    procedure Paint; override;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

  published

    property GlyphBitmap: TBitmap read FGlyphBitmap write SetGlyphBitmap;
    property Alphabet: String read FAlphabet write SetAlphabet;
    property TransparentLabel: Boolean read FTransparentLabel write SetTransparentLabel;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor;

    property Transparent;
    property VerticalAlign;
    property TextAlign;
    // property OnMyEvent: TOnMyEvent read fOnMyEvent write SetOnMyEvent;

    { ÑÊÐÛÒÈÅ ÑÂÎÉÑÒÂ Â <ÈÍÑÏÅÊÒÎÐÅ ÎÁÚÅÊÒÎÂ> }
    // property Options: Boolean read fNotAvailable;
  end;

procedure Register;

{$R *.dcr}

implementation

procedure Register;
begin
    RegisterComponents('KOL Additional', [TKOLmdvGliphLabel]);
end;

{ ÄÎÁÀÂËÅÍÈÅ ÌÎÄÓËß }
function TKOLmdvGliphLabel.AdditionalUnits;
begin
    Result := ', KOLmdvGliphLabel';
end;

procedure TKOLmdvGliphLabel.SetupConstruct;
begin
    SL.Add( Prefix + AName + ' := PmdvGliphLabel( New' + TypeName + '( ' + SetupParams( AName, AParent ) + ' )' + GenerateTransparentInits + ');');
end;

function TKOLmdvGliphLabel.SetupParams;
const _Boolean: array[Boolean] of String =('False', 'True');
var S: String;
begin
    if Assigned( GlyphBitmap ) and not GlyphBitmap.Empty then
      S := 'LoadBmp( hInstance, ' + String2Pascal(UpperCase( Name + '_BITMAP' )) + ', Result )'
    else S := '0';
    Result := AParent + ', ''' + Caption + ''', ''' + Alphabet + ''', ' + _Boolean[FTransparentLabel] + ', $' + Int2Hex(FTransparentColor, 8) + ', ' + S;
end;

procedure TKOLmdvGliphLabel.AssignEvents;
begin
    inherited;
// DoAssignEvents(SL, AName, ['OnMyEvent'], [@OnMyEvent]);
// DoAssignEvents(SL, AName, ['OnEvent1', 'OnEvent2'], [@OnEvent1, @OnEvent2]);
end;

constructor TKOLmdvGliphLabel.Create;
begin
    inherited;
    FGlyphBitmap:= TBitmap.Create;
end;

destructor TKOLmdvGliphLabel.Destroy;
begin
    FGlyphBitmap.Free;
    inherited;
end;

procedure TKOLmdvGliphLabel.SetupFirst(SL: TStringList; const AName, AParent, Prefix: String);
var RName: String;
begin
    if Assigned( GlyphBitmap ) and not GlyphBitmap.Empty then begin
      RName := ParentKOLForm.FormName + '_' + Name;
      Rpt( 'Prepare resource ' + RName + ' (' + UpperCase( Name + 'BITMAP' ) + ')' );
      GenerateBitmapResource( GlyphBitmap, UpperCase( Name + '_BITMAP' ), RName, fUpdated);
      SL.Add( Prefix + '{$R ' + RName + '.res}' );
    end;
    inherited;
end;

procedure TKOLmdvGliphLabel.SetGlyphBitmap(const Value: TBitmap);
begin
    FGlyphBitmap.Assign(Value);
    if (FGlyphBitmap.Width>0)and(FGlyphBitmap.Height>0) then FTransparentColor:= FGlyphBitmap.Canvas.Pixels[0, 0];
    Invalidate;
    Change;
end;

procedure TKOLmdvGliphLabel.SetAlphabet(const Value: String);
begin
    FAlphabet:= Value;
    Invalidate;
    Change;
end;

procedure TKOLmdvGliphLabel.SetTransparentColor(const Value: TColor);
begin
    FTransparentColor:= Value;
    Invalidate;
    Change;
end;

procedure TKOLmdvGliphLabel.SetTransparentLabel(const Value: Boolean);
begin
    FTransparentLabel:= Value;
    Invalidate;
    Change;
end;

const TextAligns: array[ TTextAlign ] of String = ( 'taLeft', 'taRight', 'taCenter' );
      VertAligns: array[ TVerticalAlign ] of String = ( 'vaTop', 'vaCenter', 'vaBottom' );
procedure TKOLmdvGliphLabel.SetupTextAlign(SL: TStrings; const AName: String);
begin
  if TextAlign <> taLeft then
    SL.Add( '    ' + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
  if VerticalAlign <> vaTop then
    SL.Add( '    ' + AName + '.VerticalAlign := ' + VertAligns[ VerticalAlign ] + ';' );
end;

procedure TKOLmdvGliphLabel.Paint;
var X, Y, i, k, bmWidth: Integer;
begin
    inherited;
    if not Transparent then begin
      Canvas.Brush.Style:= bsSolid; Canvas.Brush.Color:= Color;
      Canvas.FillRect(ClientRect);
    end;
    if Length(FAlphabet) = 0 then Exit;
    if Length(Caption) = 0 then Exit;

    bmWidth:= GlyphBitmap.Width div Length(FAlphabet);

    case fVerticalAlign of
      vaCenter: Y:= (Height - GlyphBitmap.Height) div 2;
      vaBottom: Y:= (Height - GlyphBitmap.Height);
      else Y:= 0;
    end;
    case TextAlign of
      taCenter: X:= (Width - Length(Caption)*bmWidth) div 2;
      taRight: X:= (Width - Length(Caption)*bmWidth);
      else X:= 0;
    end;

    for i:= 1 to Length(Caption) do begin
      k:= Pos(Caption[i], FAlphabet);
      if k > 0 then begin
        if FTransparentLabel then begin
//          tBmp.Canvas.CopyRect(Bounds(0, 0, tBmp.Width, tBmp.Height), FGlyphBitmap.Canvas, Bounds(bmWidth*(k-1), 0, bmWidth, tBmp.Height));
          Canvas.BrushCopy(Bounds(X+bmWidth*(i-1), Y, bmWidth, FGlyphBitmap.Height), FGlyphBitmap, Bounds(bmWidth*(k-1), 0, bmWidth, FGlyphBitmap.Height), FTransparentColor);
        end
        else Canvas.CopyRect(Bounds(X+bmWidth*(i-1), Y, bmWidth, FGlyphBitmap.Height), FGlyphBitmap.Canvas, Bounds(bmWidth*(k-1), 0, bmWidth, FGlyphBitmap.Height));
      end;
    end;
end;

end.
