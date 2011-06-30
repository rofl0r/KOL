unit mckPlotter;

interface

uses
  Windows, Messages, SysUtils, KOL, mirror, Calculus,
  Graphics, Classes, Parser;

type
  TKOLPlotter = class(TKOLCustomControl)
  private
    Mformula:String;
    FOnChange: TOnEvent;
    parser: TParser;
    FCalc: TCalculus;
    fx,fy,
    tx,ty: double;
    fStep: double;
    varX : TVarDef;
    fpen : TPen;
    spen : TPen;
    Dummy: boolean;
    fPop : TKOLPopupMenu;
    fDraw: TOnEvent;
    procedure setFormula(value: String);
    procedure setMinX(value: double);
    procedure setMinY(value: double);
    procedure setMaxX(value: double);
    procedure setMaxY(value: double);
    procedure setStep(value: double);
    Function coordX(x:double):integer;
    Function coordY(y:double):integer;
    function  getPen: TPen;
    procedure SetPen(Value: TPen);
    procedure SetPop(m: TKOLPopupMenu);
  protected
    procedure Paint; override;
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure zoomIn;
    procedure zoomOut;
    procedure translate(dx,dy:integer);
    procedure centerIn(x,y:integer);
  published
    property formula:String read Mformula write setFormula;
    property minX: double read fx write setMinX;
    property minY: double read fy write setMinY;
    property maxX: double read tx write setMaxX;
    property maxY: double read ty write setMaxY;
    property step: double read fStep write setStep;
    property pen:  TPen read getPen write setPen;

    property Align;
    property Color;
    property ParentColor;
    property PopupMenu: TKOLPopupMenu read fPop write SetPop;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
    property OnShow;
    property OnHide;
    property OnDestroy;

    property Cursor: boolean read Dummy;
    property HelpContext: boolean read Dummy;
    property HelpKeyword: boolean read Dummy;
    property HelpType: boolean read Dummy;
    property Hint: boolean read Dummy;
    property IgnoreDefault: boolean read Dummy;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('KOLUtil', [TKOLPlotter]);
end;

procedure TKOLPlotter.SetFormula(Value: String);
var
   e:byte;
begin
  if MFormula <> Value then begin
     MFormula := Value;
     FCalc := Parser.compile(MFormula, e);
     Invalidate;
{    if assigned(FOnChange) then FOnChange(self);}
     Change;
  end;
end;

procedure TKOLPlotter.SetMinX(Value: Double);

begin
  if fx <> Value then begin
     fx := Value;
     Invalidate;
     Change;
  end;
end;

procedure TKOLPlotter.SetMinY(Value: Double);

begin
  if fy <> Value then begin
     fy := Value;
     Invalidate;
     Change;
  end;
end;

procedure TKOLPlotter.SetMaxX(Value: Double);

begin
  if tx <> Value then begin
     tx := Value;
     Invalidate;
     Change;
  end;
end;

procedure TKOLPlotter.SetMaxY(Value: Double);

begin
  if ty <> Value then begin
     ty := Value;
     Invalidate;
     Change;
  end;
end;

procedure TKOLPlotter.SetStep(Value: Double);

begin
  if fStep <> Value then begin
     fStep := Value;
     Invalidate;
     Change;
  end;
end;

function TKOLPlotter.getPen;
begin
   Result := FPen;
   if (spen.Color <> fpen.Color) or
      (spen.Width <> fpen.Width) or
      (spen.Style <> fpen.Style) or
      (spen.Mode  <> fpen.Mode) then begin
      Invalidate;
      Change;
      spen.Assign(fpen);
   end;
end;

procedure TKOLPlotter.SetPen(Value: TPen);
begin
   FPen.Assign(Value);
   Invalidate;
   Change;
end;

procedure TKOLPlotter.SetPOP;
begin
   fPop := m;
   Change;
end;

constructor TKOLPlotter.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  Width  := 100;
  Height := 100;
  fX     := -10;
  fY     := -10;
  tX     :=  10;
  ty     :=  10;
  fstep  := 0.002;
  Parser := TParser.Create;
  Parser.standardFunctions;
  varX := TVarDef.Create;
  varX.name := 'x';
  Parser.addVar(varX);
  fCalc := nil;
  fPen  := TPen.Create;
  sPen  := TPen.Create;
end;

destructor TKOLPlotter.Destroy;

begin
  Parser.Free;
  fpen.Free;
  sPen.Free;
  inherited Destroy;
end;

procedure TKOLPlotter.zoomIn;
var
   mx,my:double;
begin
   mx   := (minX + maxX) / 2;
   my   := (miny + maxY) / 2;
   minx := mX + 3 * (minX -mX) / 2;
   maxx := mX + 3 * (maxX -mX) / 2;
   miny := my + 3 * (miny -my) / 2;
   maxy := my + 3 * (maxy -my) / 2;
   step := 3 * step / 2;
end;

procedure TKOLPlotter.zoomOut;
var
   mx,my:double;
begin
   mx   := (minX + maxX) / 2;
   my   := (miny + maxY) / 2;
   minx := mX + 2 * (minX - mX) / 3;
   maxx := mX + 2 * (maxX - mX) / 3;
   miny := my + 2 * (miny - my) / 3;
   maxy := my + 2 * (maxy - my) / 3;
   step := 2 * step / 3;
end;

procedure TKOLPlotter.translate(dx,dy:integer);
var
   ddx,ddy:double;
begin
   ddx  := dx * (maxX - minX) / width;
   ddy  := dy * (maxY - minY) / height;
   minx := minx - ddx;
   miny := miny + ddy;
   maxx := maxx - ddx;
   maxy := maxy + ddy;
end;

procedure TKOLPlotter.centerIn(x, y: integer);
var
   dx,dy:Integer;
begin
   dx := CoordX((maxX +minX) / 2) - x;
   dy := CoordY((maxY +minY) / 2) - y;
   translate(dx, dy);
end;

Function TKOLPlotter.coordX(x: double): integer;
begin
  coordX := round((x - fx) / (tx - fx) * width);
end;

Function TKOLPlotter.coordY(y: double): integer;
begin
   coordY := height - round((y - fy) / (ty - fy) * height);
end;


procedure TKOLPlotter.Paint;
Var
   x,y:double;
   err:Boolean;

begin
with Canvas do
begin
     Pen:=self.Pen;
     if (fy<0) and (ty>0) then  {draws y-axis}
       begin
            PenPos:=Point(0,coordY(0));
            LineTo(Width,coordY(0));
       end;

     if (fx<0) and (tx>0) then  {draws x-axis}
       begin
            PenPos:=Point(coordX(0),0);
            LineTo(coordX(0),Height);
       end;

     if fCalc=nil then exit;
     x:=fx;
      try
         varX.value:=x;
         y:=FCalc.eval;
         PenPos:=Point(coordX(x),coordY(y));
         err:=False;
      except
         err:=True;
      end;
     While x<tx do   {draws lines}
     begin
          try
             varX.value:=x;
             y:=FCalc.eval;
             if err then
                penPos:=Point(coordX(x),coordY(y))
             else
                LineTo(coordX(x),coordY(y));
             err:=False;
          except
             err:=True;
          end;
          x:=x+fStep;
     end;
end; {with canvas}
end;

function TKOLPlotter.AdditionalUnits;
begin
   Result := ', KOLPlotter';
end;

procedure TKOLPlotter.SetupFirst;
begin
   inherited;
   if MFormula <> '' then begin
      SL.Add( Prefix + AName + '.Formula      := ''' + MFormula + ''';');
   end;
   if fx <> -10 then begin
      SL.Add( Prefix + AName + '.minX         := ' + Double2Str(fx) + ';');
   end;
   if fy <> -10 then begin
      SL.Add( Prefix + AName + '.minY         := ' + Double2Str(fy) + ';');
   end;
   if tx <> 10 then begin
      SL.Add( Prefix + AName + '.maxX         := ' + Double2Str(tx) + ';');
   end;
   if ty <> 10 then begin
      SL.Add( Prefix + AName + '.maxY         := ' + Double2Str(ty) + ';');
   end;
   if fStep <> 0.002 then begin
      SL.Add( Prefix + AName + '.Step         := ' + Double2Str(fStep) + ';');
   end;
   if fPen.Color <> clBlack then begin
      SL.Add( Prefix + AName + '.Pen.Color    := ' + color2str(fPen.Color) + ';');
   end;
   if fPen.width <> 1 then begin
      SL.Add( Prefix + AName + '.Pen.PenWidth := ' + int2str(fPen.Width) + ';');
   end;
   if fPop <> nil then begin
      SL.Add( Prefix + AName + '.SetAutoPopupMenu(Result.' + fPop.Name + ');');
   end;
end;

end.
