unit MCKLed;

// просто "зеркало" для лампочки, т.е светодиода
//  Проверялся на 98/ХР. Версия КОЛ/МСК - 1.56}
// автор - Пивко Василий. 2002 г.

interface
{$I KOLDEF.INC}

uses KOL, KOLLed, Classes, Forms, Controls, Dialogs, Windows, Messages, extctrls,
     stdctrls, comctrls, SysUtils, Graphics, mirror, ShellAPI,
     mckObjs,mckCtrls, MApi,
//////////////////////////////////////////////////
     {$IFDEF _D6orHigher}                       //
     DesignIntf, DesignEditors, DesignConst,    //
     Variants,                                  //
     {$ELSE}                                    //
//////////////////////////////////////////////////
     DsgnIntf,
//////////////////////////////////////////////////////////
     {$ENDIF}                                           //
     {$IFDEF _D5orHigher} mckToolbarEditor  ,  mckLVColumnsEditor  {$ENDIF}   //
     {$IFDEF _D4}         mckToolbarEditorD4,  mckLVColumnsEditorD4{$ENDIF}
     {$IFDEF _D3}         mckToolbarEditorD3,  mckLVColumnsEditorD3{$ENDIF}
     {$IFDEF _D2}         mckToolbarEditorD2,  mckLVColumnsEditorD2{$ENDIF}
     ;

type
  TKOLLed = class(TKOLControl)
  private
    FColors : array[0..2] of TColor;
    FCtl3D : boolean;
    FValue : boolean;
    FShape : TShapeLed;
    FBlick : boolean;
  protected
    fNotAvailable : boolean;
    function GetColor(Index : integer) : TColor;
    procedure SetColor(Index : integer; AValue : TColor);
    procedure SetBlick(AValue : boolean);
    procedure SetLedValue(AValue : boolean);
    procedure SetLedShape(AShape : TShapeLed);
    procedure Paint; override;
    procedure Resize; override;
    procedure SetupFirst(SL: TStringList; const AName,AParent, Prefix: String); override;
    function  AdditionalUnits: string; override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property Align:boolean read FNotAvailable;
    property Caption:boolean read FNotAvailable;
    property Color:boolean read FNotAvailable;
    property Ctl3D:boolean read FNotAvailable;
    property Cursor:boolean read FNotAvailable;
    property Cursor_:boolean read FNotAvailable;
    property DoubleBuffered:boolean read FNotAvailable;
    property Enabled:boolean read FNotAvailable;
    property MaxWidth:boolean read FNotAvailable;
    property MaxHeight:boolean read FNotAvailable;
    property MinWidth:boolean read FNotAvailable;
    property MinHeight:boolean read FNotAvailable;
    property Font:boolean read FNotAvailable;
    property IgnoreDefault:boolean read FNotAvailable;
    property Localizy:boolean read FNotAvailable;
    property parentColor:boolean read FNotAvailable;
    property parentFont:boolean read FNotAvailable;
    property PlaceDown:boolean read FNotAvailable;
    property PlaceUnder:boolean read FNotAvailable;
    property PlaceRight:boolean read FNotAvailable;
    property CenterOnParent:boolean read FNotAvailable;
    property Blick:boolean read FBlick write SetBlick;
    property ColorOn : TColor index 0 read GetColor write SetColor;
    property ColorOff : TColor index 1 read GetColor write SetColor;
    property ColorBlick : TColor index 2 read GetColor write SetColor;
    property Shape:TShapeLed read FShape write SetLedShape;
    property Value:boolean read FValue write SetLedValue;
    property Visible;
    property OnChange;
    property OnClick:boolean read FNotAvailable;
    property OnDestroy:boolean read FNotAvailable;
    property OnDropFiles:boolean read FNotAvailable;
    property OnEraseBkgnd:boolean read FNotAvailable;
    property OnHide:boolean read FNotAvailable;
    property OnMessage:boolean read FNotAvailable;
    property OnMouseDblClk:boolean read FNotAvailable;
    property OnMouseDown:boolean read FNotAvailable;
    property OnMouseEnter:boolean read FNotAvailable;
    property OnMouseMove:boolean read FNotAvailable;
    property OnMouseLeave:boolean read FNotAvailable;
    property OnMouseUp:boolean read FNotAvailable;
    property OnMouseWheel:boolean read FNotAvailable;
    property OnMove:boolean read FNotAvailable;
    property OnPaint:boolean read FNotAvailable;
    property OnResize:boolean read FNotAvailable;
    property OnShow:boolean read FNotAvailable;
  end;

procedure Register;

implementation
{$R *.RES}

function TKOLLed.AdditionalUnits;
begin
   Result := ', KOLLed';
end;

procedure TKOLLed.SetupFirst(SL: TStringList;const AName, AParent, Prefix: String);
const
  BoolStr:array [Boolean] of String=('False','True');
begin
  SL.Add('');
  SL.Add(Prefix+AName+':=NewKOLLed('+AParent+','+BoolStr[Visible]+');');
  SL.Add(Prefix+AName+'.SetPosition('+IntToStr(Left)+','+IntToStr(Top)+')'+
                      '.SetSize('+IntToStr(Width)+','+IntToStr(Height)+');');
  if FBlick then SL.Add(Prefix+AName+'.Blick:= True;');
  if FShape = lsRectangle then SL.Add(Prefix+AName+'.Shape:= lsRectangle;');
  SL.Add(Prefix+AName+'.ColorOn:='+Int2Str(ColorOn)+';');
  SL.Add(Prefix+AName+'.ColorOff:='+Int2Str(ColorOff)+';');
  SL.Add(Prefix+AName+'.ColorBlick:='+Int2Str(ColorBlick)+';');
  if @OnChange <> nil then
      SL.Add( Prefix + AName + '.OnChange := Result.' +
              ParentForm.MethodName( @OnChange ) + ';' );
end;

constructor TKOLLed.Create(AOwner : TComponent);
begin
  Inherited Create(AOwner);
  FColors[0] := clRed;
  FColors[1] := clMaroon;
  FColors[2] := clFuchsia;
  FValue := False;
  FShape := lsCircle;
  Width := 16;
  Height := 16;
end;

procedure TKOLLed.Resize;
begin
  if FShape = lsRectangle
   then begin
     if Height < 10 then Height := 10;
   end
   else if Height < 16 then Height := 16;
  if Width < 16 then Width := 16;
  if Width > 32 then Width := 32;
  Change;
end;

procedure TKOLLed.SetBlick(AValue : boolean);
begin
  if FBlick <> AValue then begin
    FBlick := AValue;
    Refresh;
    Change;
  end;
end;

function TKOLLed.GetColor(Index : integer) : TColor;
begin
  Result := FColors[Index];
end;

procedure TKOLLed.SetColor(Index : integer; AValue : TColor);
begin
  if FColors[Index] <> AValue then begin
    FColors[Index] := AValue;
    Refresh;
    Change;
  end;
end;

procedure TKOLLed.SetLedShape(AShape : TShapeLed);
begin
  if FShape<>AShape then begin
    FShape := AShape;
    if AShape = lsCircle
     then Height := Width
     else Height := Width div 3 * 2;
    Refresh;
    Change;
  end;
end;

procedure TKOLLed.SetLedValue(AValue : boolean);
begin
  if FValue<>AValue then begin
    FValue := AValue ;
    Refresh;
    Change;
  end;
end;

procedure TKOLLed.Paint;
var
  i,dX,dY,Cnt : integer;
  Br: HBrush;
  Rgn: HRgn;
  R0: TRect;
  tmp1,tmp2 : TColor;
begin
  R0 := ClientRect;
  Rgn := 0;
  case FShape of
    lsCircle : Rgn := CreateEllipticRgnIndirect(R0);
    lsRectangle : Rgn := CreateRectRgn(R0.Left,R0.Top,R0.Right,R0.Bottom);
  end;
  if FValue
   then begin
     Br := CreateSolidBrush(FColors[0]);
     tmp1 := FColors[2]; tmp2 := clWhite;
   end
   else begin
     Br := CreateSolidBrush(FColors[1]);
     tmp1 := FColors[1]; tmp2 := FColors[0];
   end;
  if Rgn <> 0 then begin
    Windows.FillRgn(Canvas.Handle, Rgn, Br );
    DeleteObject(Rgn);
  end;
  DeleteObject(Br);
  if FBlick then begin
    case FShape of
      lsCircle :
        begin
          dX := (R0.Right - R0.Left) div 8;
          dY := (R0.Bottom - R0.Top) div 8;
          Canvas.Pen.Color := clGray;
          Windows.Arc(Canvas.Handle,R0.Left,R0.Top,R0.Right,R0.Bottom,
                                    R0.Right-dX,R0.Top,R0.Left,R0.Bottom-dY);
          Canvas.Pen.Color := clWhite;
          Windows.Arc(Canvas.Handle,R0.Left,R0.Top,R0.Right,R0.Bottom,
                                    R0.Left+dX,R0.Bottom,R0.Right,R0.Top+dY);
          if Value then begin
            Canvas.Pen.Color := FColors[1];
            Windows.Arc(Canvas.Handle,R0.Left-1,R0.Top-1,R0.Right-1,R0.Bottom-1,
                                      R0.Left+dX-1,R0.Bottom-1,R0.Right-1,R0.Top+dY-1);
          end;
          R0.Left := Width div 5;
          R0.Right := Width - R0.Left;
          R0.Top := Height div 5;
          R0.Bottom := Height - R0.Top;
          Canvas.Pen.Color := tmp1;
          dX := Round((R0.Right - R0.Left) * 0.52);
          dY := Round((R0.Bottom - R0.Top) * 0.52);
          Windows.Arc(Canvas.Handle,R0.Left,R0.Top,R0.Right,R0.Bottom,
                                    R0.Left + dX,R0.Top,
                                    R0.Left,R0.Top + dY);
          Canvas.Pen.Color := tmp2;
          dX := Round((R0.Right - R0.Left) * 0.24);
          dY := Round((R0.Bottom - R0.Top) * 0.24);
          for i := 0 to 1 do
            Windows.Arc(Canvas.Handle,R0.Left+i,R0.Top+i,R0.Right+i,R0.Bottom+i,
                                      R0.Left+dX-i,R0.Top,
                                      R0.Left,R0.Top+dY-i);
        end;
      lsRectangle :
        begin
          Canvas.Pen.Color := clGray;
          Windows.MoveToEx(Canvas.Handle,R0.Left,R0.Bottom,nil);
          Windows.LineTo(Canvas.Handle,R0.Left,R0.Top);
          Windows.LineTo(Canvas.Handle,R0.Right,R0.Top);
          Canvas.Pen.Color := clWhite;
          Windows.MoveToEx(Canvas.Handle,R0.Right-1,R0.Top,nil);
          Windows.LineTo(Canvas.Handle,R0.Right-1,R0.Bottom-1);
          Windows.LineTo(Canvas.Handle,R0.Left,R0.Bottom-1);
          if Value then begin
            Canvas.Pen.Color := FColors[1];
            Windows.MoveToEx(Canvas.Handle,R0.Right-2,R0.Top+1,nil);
            Windows.LineTo(Canvas.Handle,R0.Right-2,R0.Bottom-2);
            Windows.LineTo(Canvas.Handle,R0.Left-1,R0.Bottom-2);
          end;
          R0.Left := Width div 12;
          R0.Right := Width - R0.Left;
          R0.Top := Height div 8;
          R0.Bottom := Height - R0.Top;
          Canvas.Pen.Color := tmp1;
          Windows.MoveToEx(Canvas.Handle,R0.Left+1,R0.Bottom-2,nil);
          Windows.LineTo(Canvas.Handle,R0.Left+1,R0.Top+1);
          Windows.LineTo(Canvas.Handle,R0.Right-2,R0.Top+1);
          Canvas.Pen.Color := tmp2;
          Windows.MoveToEx(Canvas.Handle,R0.Left+1,R0.Top+2,nil);
          Windows.LineTo(Canvas.Handle,R0.Left+1,R0.Top+1);
          Windows.LineTo(Canvas.Handle,R0.Left+2,R0.Top+1);
          Windows.LineTo(Canvas.Handle,R0.Left+1,R0.Top+2);
        end;
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('KOL_Additional',[TKOLLed]);
end;

end.
