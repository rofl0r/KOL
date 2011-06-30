unit KOLLed;

// просто лампочка, т.е светодиод
//  Проверялся на 98/ХР. Версия КОЛ/МСК - 1.56}
// автор - Пивко Василий. 2002 г.

interface
{$I KOLDEF.INC}

uses KOL, Windows, Messages, MAPI;

type
  TShapeLed = (lsCircle,lsRectangle);

  PLed = ^TLed;
  TKOLLed = PLed;
  L_D = record
          PenGray,PenWhite : HPen;
          FColors : array[0..2] of TColor;
          FValue : boolean;
          FShape : TShapeLed;
          FBlick : boolean;
        end;
  TLed = object(TControl)
  private
    { Private declarations }
    function GetColor(Ind : integer) : TColor;
    procedure SetColor(Ind : integer; AColor : TColor);
    function  GetLedValue(Ind : integer) : boolean;
    procedure SetLedValue(Ind : integer; AValue : boolean);
    function  GetLedShape : TShapeLed;
    procedure SetLedShape(AShape : TShapeLed);
  public
    { Public declarations }
    procedure Free;
    property Transparent;
    property ColorOn : TColor index 0 read GetColor write SetColor;
    property ColorOff : TColor index 1 read GetColor write SetColor;
    property ColorBlick : TColor index 2 read GetColor write SetColor;
    property Shape:TShapeLed read GetLedShape write SetLedShape;
    property Blick:boolean index 0 read GetLedValue write SetLedValue;
    property Value:boolean index 1 read GetLedValue write SetLedValue;
    property Visible;
    property OnChange: TOnEvent read fOnChange write fOnChange;
  end;

const
  LED_CLASS = 'led32';
  Visible2Style:array [Boolean] of DWord = ($0,WS_VISIBLE);

function NewKOLLed(AParent:PControl; Visible:Boolean) : PLed;
function WndPaintLed(Sender: PControl;
                          var Msg: TMsg; var Rslt: Integer ): Boolean;

implementation

function WndPaintLed(Sender: PControl;
                          var Msg: TMsg; var Rslt: Integer ): Boolean;
var
  DC : HDC;
  dX,dY : integer;
  Br: HBrush;
  Rgn: HRgn;
  Pen1,Pen2,Pen3 : HPen;
  R0: TRect;
begin
  Result := False;
  case Msg.message of
    WM_PAINT :
      begin
        DC := GetDC(PLed(Sender).Handle);
        R0 := PLed(Sender).ClientRect;
        PLed(Sender).PaintBackGround(DC,@R0);
        Rgn := 0;
        case L_D(PLed(Sender).CustomData^).FShape of
          lsCircle : Rgn := CreateEllipticRgnIndirect(R0);
          lsRectangle : Rgn := CreateRectRgn(R0.Left,R0.Top,R0.Right,R0.Bottom);
        end;
        if L_D(PLed(Sender).CustomData^).FValue
         then Br := CreateSolidBrush(L_D(PLed(Sender).CustomData^).FColors[0])
         else Br := CreateSolidBrush(L_D(PLed(Sender).CustomData^).FColors[1]);
        if Rgn <> 0 then begin
          Windows.FillRgn(DC,Rgn,Br);
          DeleteObject(Rgn);
        end;
        DeleteObject(Br);
        if L_D(PLed(Sender).CustomData^).FBlick then begin
          SelectObject(DC,L_D(PLed(Sender).CustomData^).PenGray);
          Pen1 := CreatePen(ps_Solid,1,L_D(PLed(Sender).CustomData^).FColors[1]);
          if L_D(PLed(Sender).CustomData^).FValue
           then begin
             Pen2 := CreatePen(ps_Solid,1,L_D(PLed(Sender).CustomData^).FColors[2]);
             Pen3 := CreatePen(ps_Solid,2,clWhite);
           end
           else begin
             Pen2 := CreatePen(ps_Solid,1,L_D(PLed(Sender).CustomData^).FColors[1]);
             Pen3 := CreatePen(ps_Solid,2,L_D(PLed(Sender).CustomData^).FColors[0]);
           end;
          case L_D(PLed(Sender).CustomData^).FShape of
            lsCircle :
              begin
                dX := (R0.Right - R0.Left) div 8;
                dY := (R0.Bottom - R0.Top) div 8;
                Windows.Arc(DC,R0.Left,R0.Top,R0.Right,R0.Bottom,
                               R0.Right,R0.Top,R0.Left,R0.Bottom);
                SelectObject(DC,L_D(PLed(Sender).CustomData^).PenWhite);
                Windows.Arc(DC,R0.Left,R0.Top,R0.Right,R0.Bottom,
                               R0.Left,R0.Bottom,R0.Right,R0.Top);
                if L_D(PLed(Sender).CustomData^).FValue then begin
                  SelectObject(DC,Pen1);
                  Windows.Arc(DC,R0.Left+1,R0.Top+1,R0.Right-1,R0.Bottom-1,
                                 R0.Left+dX-1,R0.Bottom-1,R0.Right-1,R0.Top+dY-1);
                end;
                R0.Left := R0.Right div 5; R0.Right := R0.Right - R0.Left;
                R0.Top := R0.Bottom div 5; R0.Bottom := R0.Bottom - R0.Top;
                SelectObject(DC,Pen2);
                dX := Round((R0.Right - R0.Left) * 0.52);
                dY := Round((R0.Bottom - R0.Top) * 0.52);
                Windows.Arc(DC,R0.Left,R0.Top,R0.Right,R0.Bottom,
                               R0.Left + dX,R0.Top,R0.Left,R0.Top + dY);
                SelectObject(DC,Pen3);
                dX := Round((R0.Right - R0.Left) * 0.24);
                dY := Round((R0.Bottom - R0.Top) * 0.24);
                Windows.Arc(DC,R0.Left,R0.Top,R0.Right,R0.Bottom,
                               R0.Left+dX,R0.Top,R0.Left,R0.Top+dY);
              end;
            lsRectangle :
              begin
                Windows.MoveToEx(DC,R0.Left,R0.Bottom,nil);
                Windows.LineTo(DC,R0.Left,R0.Top);
                Windows.LineTo(DC,R0.Right,R0.Top);
                SelectObject(DC,L_D(PLed(Sender).CustomData^).PenWhite);
                Windows.MoveToEx(DC,R0.Right-1,R0.Top,nil);
                Windows.LineTo(DC,R0.Right-1,R0.Bottom-1);
                Windows.LineTo(DC,R0.Left,R0.Bottom-1);
                if L_D(PLed(Sender).CustomData^).FValue then begin
                  SelectObject(DC,Pen1);
                  Windows.MoveToEx(DC,R0.Right-2,R0.Top+1,nil);
                  Windows.LineTo(DC,R0.Right-2,R0.Bottom-2);
                  Windows.LineTo(DC,R0.Left,R0.Bottom-2);
                end;
                R0.Left := R0.Right div 12; R0.Right := R0.Right - R0.Left;
                R0.Top := R0.Bottom div 8; R0.Bottom := R0.Bottom - R0.Top;
                SelectObject(DC,Pen2);
                Windows.MoveToEx(DC,R0.Left+1,R0.Bottom-2,nil);
                Windows.LineTo(DC,R0.Left+1,R0.Top+1);
                Windows.LineTo(DC,R0.Right-2,R0.Top+1);
                SelectObject(DC,Pen3);
                Windows.MoveToEx(DC,R0.Left+1,R0.Top+2,nil);
                Windows.LineTo(DC,R0.Left+1,R0.Top+1);
                Windows.LineTo(DC,R0.Left+2,R0.Top+1);
                Windows.LineTo(DC,R0.Left+1,R0.Top+2);
              end;
          end;
          DeleteObject(Pen1);
          DeleteObject(Pen2);
          DeleteObject(Pen3);
        end;
        ReleaseDC(PLed(Sender).Handle,DC);
      end;
  end;
end;

function NewKOLLed(AParent:PControl; Visible:Boolean) : PLed;
var
  Proc : TObjectMethod;
  D : ^L_D;
begin
  Result := PLed(_NewControl(AParent,LED_CLASS,WS_CHILD or Visible2Style[Visible],False,nil));
  GetMem(D,sizeof(L_D));
  D^.PenGray := CreatePen(ps_Solid,1,clGray);
  D^.PenWhite := CreatePen(ps_Solid,1,clWhite);
  D^.FValue := False;
  D^.FShape := lsCircle;
  D^.FBlick := False;
  Result.CustomData := D;
  Result.FCtl3D := False;
  TMethod(Proc).Data := Result;
  TMethod(Proc).Code := @TLed.Free;
  AParent.Add2AutoFreeEx(Proc);
  Result.AttachProc(WndPaintLed);
end;

function TLed.GetColor(Ind : integer) : TColor;
begin
  Result := L_D(CustomData^).FColors[Ind];
end;

procedure TLed.SetColor(Ind : integer; AColor : TColor);
begin
  L_D(CustomData^).FColors[Ind] := AColor;
  Perform(WM_PAINT,0,0);
  if assigned(FOnChange) then FOnChange(@Self);
end;

procedure TLed.Free;
begin
  DeleteObject(L_D(CustomData^).PenGray);
  DeleteObject(L_D(CustomData^).PenWhite);
  inherited Free;
end;

function TLed.GetLedShape : TShapeLed;
begin
  Result := L_D(CustomData^).FShape;
end;

procedure TLed.SetLedShape(AShape : TShapeLed);
begin
  L_D(CustomData^).FShape := AShape;
  Perform(WM_PAINT,0,0);
  if assigned(FOnChange) then FOnChange(@Self);
end;

function TLed.GetLedValue(Ind : integer) : boolean;
begin
  if Ind = 0
   then Result := L_D(CustomData^).FBlick
   else Result := L_D(CustomData^).FValue;
end;

procedure TLed.SetLedValue(Ind : integer; AValue : boolean);
begin
  if Ind = 0
   then L_D(CustomData^).FBlick := AValue
   else L_D(CustomData^).FValue := AValue;
  Perform(WM_PAINT,0,0);
  if assigned(FOnChange) then FOnChange(@Self);
end;

end.

