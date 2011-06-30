unit KOLPlotter;

interface

uses
  KOL, Windows, Messages, Calculus, Types, Parser;

type

  PData =^TData;
  TData = record
{    FOnChange: TOnEvent;}
    parser: TParser;
    FCalc: TCalculus;
    fx,fy,tx,ty: double;
    fStep: double;
    varX: TVarDef;
    fpen: PGraphicTool;
    fbmp: KOL.PBitmap;
    Mformula: String;
  end;

  PKOLPlotter =^TfunPlotter;
  TKOLPlotter = PKOLPlotter;
  TfunPlotter = object(TControl)
  private
    function  getFormula: String;
    procedure setFormula(value: String);
    function  getMinX: double;
    procedure setMinX(value: double);
    function  getMinY: double;
    procedure setMinY(value: double);
    function  getMaxX: double;
    procedure setMaxX(value: double);
    function  getMaxY: double;
    procedure setMaxY(value: double);
    function  getStep: double;
    procedure setStep(value: double);
    Function coordX(x:double):integer;
    Function coordY(y:double):integer;
    function  GetPen: PGraphicTool;
    procedure SetPen(Value: PGraphicTool);
  protected
    procedure Paint;
  public
    function  SetPosition(X, Y: integer): PKOLPlotter; overload;
    function  SetSize(X, Y: integer): PKOLPlotter; overload;
    function  SetAlign(A: TControlAlign): PKOLPlotter; overload;
    destructor Destroy; virtual;
    procedure zoomIn;
    procedure zoomOut;
    procedure translate(dx,dy:integer);
    procedure centerIn(x,y:integer);
{  published}
    property formula:String read getFormula write setFormula;
    property minX:double read GetMinx write setMinX;
    property minY:double read GetMinY write setMinY;
    property maxX:double read GetMaxX write setMaxX;
    property maxY:double read GetMaxY write setMaxY;
    property step:double read GetStep write setStep;
    property pen: PGraphictool read GetPen write setPen;
    property OnChange: TOnEvent read FOnChange write FOnChange;
  end;

  function NewPlotter(AOwner: PControl): PKOLPlotter;

implementation

function  TfunPlotter.getFormula;
var p: PData;
begin
   p := CustomData;
   Result := p.Mformula;
end;

procedure TfunPlotter.SetFormula(Value: String);
var
   e: byte;
   p: PData;
begin
   p := CustomData;
   if p.MFormula <> Value then begin
      p.MFormula := Value;
      p.FCalc := p.Parser.compile(p.MFormula, e);
      Invalidate;
      if assigned(FOnChange) then FOnChange(@self);
   end;
end;

function TfunPlotter.GetMinX;
var p: PData;
begin
   p := CustomData;
   Result := p.fx;
end;

procedure TfunPlotter.SetMinX(Value: Double);
var p: PData;
begin
   p := CustomData;
   if p.fx <> Value then begin
      p.fx := Value;
      Invalidate;
   end;
end;

function TfunPlotter.GetMinY;
var p: PData;
begin
   p := CustomData;
   Result := p.fy;
end;

procedure TfunPlotter.SetMinY(Value: Double);
var p: PData;
begin
   p := CustomData;
   if p.fy <> Value then begin
      p.fy := Value;
      Invalidate;
   end;
end;

function TfunPlotter.GetMaxX;
var p: PData;
begin
   p := CustomData;
   Result := p.tx;
end;

procedure TfunPlotter.SetMaxX(Value: Double);
var p: PData;
begin
   p := CustomData;
   if p.tx <> Value then begin
      p.tx := Value;
      Invalidate;
   end;
end;

function TfunPlotter.GetMaxY;
var p: PData;
begin
   p := CustomData;
   Result := p.ty;
end;

procedure TfunPlotter.SetMaxY(Value: Double);
var p: PData;
begin
   p := CustomData;
   if p.ty <> Value then begin
      p.ty := Value;
      Invalidate;
   end;
end;

function TfunPlotter.GetStep;
var p: PData;
begin
   p := CustomData;
   Result := p.fStep;
end;

procedure TfunPlotter.SetStep(Value: Double);
var p: PData;
begin
   p := CustomData;
   if p.fStep <> Value then begin
      p.fStep := Value;
      Invalidate;
   end;
end;

function TfunPlotter.GetPen;
var p: PData;
begin
   p := CustomData;
   Result := p.fPen;
end;

procedure TfunPlotter.SetPen(Value: PGraphicTool);
var p: PData;
begin
   p := CustomData;
   p.FPen.Assign(Value);
   Invalidate;
end;

function WndProc( Sender: PControl; var Msg: TMsg; var Rslt: Integer ): Boolean;
var p: TPaintStruct;
begin
   Result := False;
   if Msg.message = WM_PAINT then begin
      BeginPaint(Sender.Handle, p);
      PKOLPlotter(Sender).Paint;
      EndPaint(Sender.Handle, p);
      Result := True;
   end else
   if Msg.message = WM_ERASEBKGND then begin
      Result := True;
      Rslt   := 1;
   end;
end;

{$O+}
function NewPlotter;
label exit;
var p: PData;
begin
  asm
     push EBX
  end;
  Result := pointer(_NewControl( AOwner, 'STATIC', WS_VISIBLE or WS_CHILD or
                 SS_LEFTNOWORDWRAP or SS_NOPREFIX or SS_NOTIFY,
                 False, nil ));
  result.AttachProc(WndProc);
  New(p);
  Result.CustomData := p;
  p.fX := -10;
  p.fY := -10;
  p.tX :=  10;
  p.ty :=  10;
  p.fstep := 0.002;
  p.Parser := TParser.Create;
  p.Parser.standardFunctions;
  p.varX := TVarDef.Create;
  p.varX.name := 'x';
  p.Parser.addVar(p.varX);
  p.fCalc := nil;
  p.fPen := NewPen;
  p.fbmp := NewBitmap(0, 0);
  p.fbmp.PixelFormat := pf24bit;
  Result.formula := 'log(x)';

  asm
    pop   EBX
  end;

  asm
    MOV   EDX, offset @@new_call + 4
    MOV   EDX, [EDX]
    ADD   EDX, 12
    MOV   [EBX], EDX
    jmp   exit
    @@new_call:
  end;

  new(Result, CreateParented(AOwner));
  exit:
end;
{$O-}

destructor TfunPlotter.Destroy;
var p: PData;
begin
   p := CustomData;
   if p <> nil then begin
      p.Parser.Free;
      p.fpen.Free;
      p.fbmp.Free;
   end;
   inherited Destroy;
end;

procedure TfunPlotter.zoomIn;
var
   mx,
   my: double;
begin
   mx   := (minX + maxX) / 2;
   my   := (miny + maxY) / 2;
   minx := mX + 3 * (minX - mX) / 2;
   maxx := mX + 3 * (maxX - mX) / 2;
   miny := my + 3 * (miny - my) / 2;
   maxy := my + 3 * (maxy - my) / 2;
   step := 3 * step/2;
end;

procedure TfunPlotter.zoomOut;
var
   mx,
   my: double;
begin
   mx   := (minX + maxX) / 2;
   my   := (miny + maxY) / 2;
   minx := mX + 2 * (minX - mX) / 3;
   maxx := mX + 2 * (maxX - mX) / 3;
   miny := my + 2 * (miny - my) / 3;
   maxy := my + 2 * (maxy - my) / 3;
   step := 2 * step / 3;
end;

procedure TfunPlotter.translate(dx, dy: integer);
var
   ddx,
   ddy: double;
begin
   ddx  := dx * (maxX - minX) / width;
   ddy  := dy * (maxY - minY) / height;
   minx := minx - ddx;
   miny := miny + ddy;
   maxx := maxx - ddx;
   maxy := maxy + ddy;
end;

procedure TfunPlotter.centerIn(x, y: integer);
var
   dx,
   dy: Integer;
begin
   dx := CoordX((maxX + minX) / 2) - x;
   dy := CoordY((maxY + minY) / 2) - y;
   translate(dx, dy);
end;

Function TfunPlotter.coordX(x: double): integer;
var p: PData;
begin
   p := CustomData;
   coordX := round((x - p.fx) / (p.tx - p.fx) * width);
end;

Function TfunPlotter.coordY(y: double): integer;
var p: PData;
begin
   p := CustomData;
   coordY := height - round((y - p.fy) / (p.ty - p.fy) * height);
end;


procedure TfunPlotter.Paint;
Var
   x,y: double;
   err: Boolean;
   cnv: PCanvas;
     p: PData;
begin
   p := CustomData;
   p.fbmp.Width  := Width;
   p.fbmp.Height := Height;
{cnv := Canvas;}
   cnv := p.fbmp.Canvas;
   with Cnv^ do begin
      Pen.Assign(p.fpen); 
      brush.Color := Color;
      FillRect(ClipRect);

      if (p.fy < 0) and (p.ty > 0) then  {draws y-axis} begin
         PenPos := Point(0, coordY(0));
         LineTo(Width, coordY(0));
      end;

      if (p.fx < 0) and (p.tx > 0) then  {draws x-axis} begin
         PenPos := Point(coordX(0), 0);
         LineTo(coordX(0), Height);
      end;

      if p.fCalc = nil then exit;
      x := p.fx;
      try
         p.varX.value := x;
         y := p.FCalc.eval;
         PenPos := Point(coordX(x), coordY(y));
         err := False;
      except
         err := True;
      end;
      While x < p.tx do   {draws lines} begin
         try
            p.varX.value := x;
            y := p.FCalc.eval;
            if err then penPos := Point(coordX(x), coordY(y))
                   else LineTo(coordX(x), coordY(y));
            err := False;
         except
            err := True;
         end;
         x := x + p.fStep;
      end;
   end; {with canvas}
   bitblt(Canvas.Handle, 0, 0, Width, Height, p.fbmp.Canvas.Handle, 0, 0, SRCCOPY);
end;

function TfunPlotter.SetPosition(X, Y: integer): PKOLPlotter;
begin
   Left := X;
   Top := Y;
   Result := @self;
end;

function TfunPlotter.SetSize(X, Y: integer): PKOLPlotter;
begin
   Width  := X;
   Height := Y;
   Result := @self;
end;

function TfunPlotter.SetAlign(A: TControlAlign): PKOLPlotter;
begin
   Align := A;
   Result := @self;
end;

end.
