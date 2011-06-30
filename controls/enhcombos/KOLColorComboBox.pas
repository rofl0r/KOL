unit KOLColorComboBox;
{* Color combobox is usefull for selecting default system colors ,
 becouse visually express each default color.
 |<br>
 |<br>
 |<i> Author : Boguslaw Brandys </i>
 |<br> 
 |<i> Email : brandysb@poczta.onet.pl </i>
 
 }



interface
uses
  Windows, Messages, KOL;



type



  PColorCombo =^TColorCombo;
  TKOLColorComboBox = PColorCombo;
  TColorCombo = object(TObj)
  {*}
  private
    { Private declarations }
    fControl : PControl;
    fOnChange: TOnEvent;
    fAOwner: PControl;
    fColorSelected : TColor;
    fCursor : HCURSOR;
  procedure DoChange(Obj : PObj);
  procedure MakeColorList;
  function GetColor : TColor;
  procedure SetColor(const Value : TColor);
  procedure SetColorSelected(const Value : TColor);
  procedure SetCursor(const Value : HCURSOR);
  procedure SetFont(Value : PGraphicTool);
  function GetFont : PGraphicTool;
	function DrawOneItem(Sender: PObj; DC: HDC;
  const Rect: TRect; ItemIdx: Integer; DrawAction: TDrawAction;
  ItemState: TDrawState): Boolean;
  protected
    { Protected declarations }
  public
    { Public declarations }
    destructor Destroy; virtual;
    {*}
    function SetAlign(Value: TControlAlign): PColorCombo; overload;
    {*}
    function SetPosition(X, Y: integer): PColorCombo; overload;
    {*}
    function SetSize(X, Y: integer): PColorCombo; overload;
    {*}
    property Color : TColor read GetColor write SetColor;
    {*}
    property ColorSelected : TColor read fColorSelected write SetColorSelected;
		{* Return selected color , beside when is set combo is positioned to equal color}
    property OnChange: TOnEvent read fOnChange write fOnChange;
    {* Fired when color is changed}
    property Cursor : HCURSOR read fCursor write SetCursor;
    {* To select cursor}
    property Font : PGraphicTool read GetFont write SetFont;
    {* Use this property if You want change any font attribute however
    keep in mind that large font will be cut, and Orientation if useless }
  end;


function NewColorComboBox( AOwner: PControl): PColorCombo;
{* Creates new color combobox which is generally an opaque for KOL combobox
with additional processing of default system color's list}



implementation

uses objects;

const

ColorRange = 16;

ColorValues: array [0..ColorRange - 1] of TColor = (
		clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray,
		clSilver, clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clWhite);
		{* Change this array for internationalization code }
ColorNames: array [0..ColorRange - 1] of String = (
		'Black','Maroon','Green','Olive','Navy','Purple','Teal','Gray','Silver',
		'Red','Lime','Yellow','Blue','Fuchsia','Aqua','White');
		{* Expand this array if more color wanted}





function NewColorComboBox;
var
	 p: PColorCombo;
    c: PControl;
begin
   c:=NewComboBox(AOwner,[coReadOnly,coOwnerDrawVariable]);
   New(p,create);
   AOwner.Add2AutoFree(p);
   p.fControl:= c;
   p.fControl.Font.FontName := 'Tahoma';
   p.fControl.Font.FontHeight := 13;
   p.fAOwner:=AOwner;
   p.fCursor := LoadCursor(0,IDC_ARROW);
   p.Color  := clWindow;
   p.MakeColorList;
   p.fControl.OnDrawItem := p.DrawOneItem;
   p.fControl.OnChange:=p.DoChange;
   p.fControl.CurIndex :=0;
   Result:=p;
end;


procedure TColorCombo.MakeColorList;
var
i : Integer;
begin
    for i:=0 to ColorRange -1 do
        begin
            fControl.Add(ColorNames[i]);
            fControl.ItemData[i] := ColorValues[i];
        end;

end;





procedure TColorCombo.DoChange(Obj : PObj);
begin
  fColorSelected := TColor(fControl.ItemData[fControl.CurIndex]);
  if Assigned(fOnChange) then fOnChange(@Self);
end;


procedure TColorCombo.SetFont(Value : PGraphicTool);
begin
    if (Value <> fControl.Font) then fControl.Font.Assign(Value);
end;


function TColorCombo.GetFont : PGraphicTool;
begin
    Result := PGraphicTool(fControl.Font);
end;



function TColorCombo.SetAlign(Value: TControlAlign): PColorCombo;
begin
  fControl.Align:=Value;
  Result:=@Self;
end;

function TColorCombo.SetPosition(X, Y: integer): PColorCombo;
begin
   fControl.Left := X;
   fControl.Top := Y;
   Result := @self;
end;

function TColorCombo.SetSize(X, Y: integer): PColorCombo;
begin
   fControl.Width  := X;
   fControl.Height := Y;
   Result := @self;
end;


function TColorCombo.GetColor : TColor;
begin
	Result := fControl.Color;
end;


procedure TColorCombo.SetColor(const Value : TColor);
begin
	fControl.Color := Value;
end;

procedure TColorCombo.SetColorSelected(const Value : TColor);
var
i : Integer;
j : LongInt;
col : TColor;
begin
    for i:=0 to fControl.Count -1 do
        begin
            j := fControl.ItemData[i];
            col := TColor(j);
            if col = Value then
             begin
                fColorSelected := Value;
                fControl.BeginUpdate;
                fControl.CurIndex := i;
                fControl.EndUpdate;
                break;
             end;
        end;

    if fColorSelected <> Value then
        begin
            fColorSelected := -1;
            fControl.Text := '???';
        end;

end;


procedure TColorCombo.SetCursor(const Value : HCURSOR);
begin
    fCursor := Value;
	fControl.Cursor := Value;
end;


function TColorCombo.DrawOneItem(Sender: PObj; DC: HDC;
  const Rect: TRect; ItemIdx: Integer; DrawAction: TDrawAction;
  ItemState: TDrawState): Boolean;
var
TextRect  : TRect;
ColorRect : TRect;
begin
if ItemIdx > -1 then begin
     FillRect(DC,Rect,0);
     ColorRect.Top := Rect.Top  + 3 ;
     ColorRect.Left := Rect.Left + 2;
     ColorRect.Right := 25;
     ColorRect.Bottom := Rect.Bottom - 3;
		 PControl(Sender).Canvas.Brush.Color := PControl(Sender).ItemData[ItemIdx];
		 PControl(Sender).Canvas.Pen.Color := clHighlight;
     SelectObject(DC,PControl(Sender).Canvas.Brush.Handle);
     Rectangle(DC,ColorRect.Left,ColorRect.Top,ColorRect.Right,ColorRect.Bottom);
     PControl(Sender).Canvas.Brush.Color := PControl(Sender).Color;
     SelectObject(DC,PControl(Sender).Canvas.Brush.Handle);
     TextRect := Rect;
     TextRect.Left := 28;
		 DrawText(DC,PChar(PControl(Sender).Items[ItemIdx]),Length(PControl(Sender).Items[ItemIdx]),TextRect,DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
		 if (odaSelect in DrawAction) then InvertRect(DC,TextRect);
end;
Result := False;
end;




destructor TColorCombo.Destroy;
begin
        fControl.Clear;
        fControl.Free;
		inherited;
end;






end.
