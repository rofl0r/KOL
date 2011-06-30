unit KOLFontComboBox;
{* Font combobox is usefull for selecting font names ,
 becouse visually express each font (only screen fonts).
 |<br>
 If font is TrueType small TT icon is created before font name.
 |<br>
 |<br>
 |<i> Author : Boguslaw Brandys </i>
 |<br> 
 |<i> Email : brandysb@poczta.onet.pl </i>
 
 }



interface
uses
  Windows, Messages, KOL;

{$R KOLFontComboBox.res}


type


  PFontCombo =^TFontCombo;
  TKOLFontComboBox = PFontCombo;
  TFontCombo = object(TObj)
  {*}
  private
    { Private declarations }
    fControl : PControl;
    fOnChange: TOnEvent;
    fAOwner: PControl;
    fFontName : String;
    fFontHeight : Integer;
    fCursor : HCURSOR;
    TTImage : HICON;
  procedure DoChange(Obj : PObj);
  procedure DestroyFontList;
  procedure MakeFontList;
  function GetColor : TColor;
  procedure SetColor(Value : TColor);
  procedure SetFontHeight(const Value : Integer);
  procedure SetFontName(const Value : String);
  procedure SetCursor(const Value : HCURSOR);
	function DrawOneItem(Sender: PObj; DC: HDC;
	const Rect: TRect; ItemIdx: Integer; DrawAction: TDrawAction;
	ItemState: TDrawState): Boolean;
	protected
		{ Protected declarations }
	public
		{ Public declarations }
		destructor Destroy; virtual;
		{*}
		function SetAlign(Value: TControlAlign): PFontCombo; overload;
		{*}
		function SetPosition(X, Y: integer): PFontCombo; overload;
		{*}
		function SetSize(X, Y: integer): PFontCombo; overload;
		{*}
		property Color : TColor read GetColor write SetColor;
		{*}
		property FontName : String read fFontName write SetFontName;
		{* Return selected font name , beside when is set combo is positioned to equal font name}
		property FontHeight : Integer read fFontHeight write SetFontHeight;
		{* For adjust size of displayed font names}
		property OnChange: TOnEvent read fOnChange write fOnChange;
		{* Fired when font is changed}
		property Cursor : HCURSOR read fCursor write SetCursor;
		{* To select cursor}

	end;


function NewFontComboBox( AOwner: PControl): PFontCombo;
{* Creates new font combobox which is generally an opaque for KOL combobox
with additional processing of font's list}



implementation

//uses objects;

type
	TFontDef = packed record
		Handle: DWORD;
		TrueType: Boolean;
	end;
	PFontDef = ^TFontDef;


function EnumFontsProc(var EnumLogFont: TEnumLogFont;
	var TextMetric: TNewTextMetric; FontType: Integer; Data: LPARAM): Integer;
	export; stdcall;
var
	FaceName: string;
	control : PFontCombo;
	font : HFONT;
	i  : Integer;
	//j  : LongInt;
	FD: PFontDef;
begin
	control  := PFontCombo(Data);
	FaceName := String(EnumLogFont.elfLogFont.lfFaceName);
	with EnumLogFont do begin
	elfLogFont.lfHeight := -control.fFontHeight;
	elfLogFont.lfWidth  := 0;
	end;
	if control.fControl.IndexOf(FaceName) < 0 then
	begin
		if EnumLogFont.elflogfont.lfCharSet = SYMBOL_CHARSET then font :=0
		else
		font := CreateFontIndirect(EnumLogFont.elfLogFont);
		i := control.fcontrol.Add(FaceName);
		//j := LongInt(font);
		{if (FontType and TRUETYPE_FONTTYPE) <> 0 then
			j := -j;}
		GetMem( FD, Sizeof( FD^ ) );
		FD.Handle := font;
		FD.TrueType := (FontType and TRUETYPE_FONTTYPE) <> 0;
		control.fcontrol.ItemData[i] := DWORD( FD );
	end;
	Result := 1;
end;





function NewFontComboBox;
var
	 p: PFontCombo;
		c: PControl;
begin
	 c:=NewComboBox(AOwner,[coReadOnly,coSort,coOwnerDrawVariable]);
	 New(p,create);
	 AOwner.Add2AutoFree(p);
	 p.fControl:= c;
	 p.fAOwner:=AOwner;
	 p.fFontHeight := 11;
	 p.fControl.Font.FontName := 'MS Sans Serif';
	 p.fControl.Font.FontHeight := 11;
	 p.TTImage := LoadIcon(hInstance,'TTICON');
	 p.fCursor := LoadCursor(0,IDC_ARROW);
	 p.Color  := clWindow;
	 p.fControl.OnDrawItem := p.DrawOneItem;
	 p.MakeFontList;
	 p.fControl.OnChange:=p.DoChange;
	 p.fControl.CurIndex :=0;
	 Result:=p;
end;


procedure TFontCombo.DoChange(Obj : PObj);
begin
	fFontName := fControl.Items[fControl.CurIndex];
	if Assigned(fOnChange) then fOnChange(@Self);
end;


function TFontCombo.SetAlign(Value: TControlAlign): PFontCombo;
begin
	fControl.Align:=Value;
	Result:=@Self;
end;

function TFontCombo.SetPosition(X, Y: integer): PFontCombo;
begin
	 fControl.Left := X;
	 fControl.Top := Y;
	 Result := @self;
end;

function TFontCombo.SetSize(X, Y: integer): PFontCombo;
begin
	 fControl.Width  := X;
	 fControl.Height := Y;
	 Result := @self;
end;


function TFontCombo.GetColor : TColor;
begin
	Result := fControl.Color;
end;


procedure TFontCombo.SetColor(Value : TColor);
begin
	fControl.Color := Value;
end;

procedure TFontCombo.SetFontName(const Value : String);
var
i : Integer;
begin
		i:= fControl.IndexOf(Value);
		if i  > 0 then
				begin
						fFontName := Value;
						fControl.BeginUpdate;
						fControl.CurIndex := i;
						fControl.EndUpdate;
					end
				else
				begin
						fFontName := '???';
						fControl.Text := '???';
				end;


end;


procedure TFontCombo.SetFontHeight(const Value : Integer);
begin
		if (Value <> fFontHeight) then
				begin
						fFontHeight := Value;
						MakeFontList;
				end;
end;

procedure TFontCombo.SetCursor(const Value : HCURSOR);
begin
		fCursor := Value;
	fControl.Cursor := Value;
end;


function TFontCombo.DrawOneItem(Sender: PObj; DC: HDC;
	const Rect: TRect; ItemIdx: Integer; DrawAction: TDrawAction;
	ItemState: TDrawState): Boolean;
var
xRect : TRect;
xfont : HFONT;
//j : LongInt;
FD: PFontDef;
begin
if ItemIdx > -1 then begin
//j := Sender.ItemData[ItemIdx];
FD := Pointer( PControl(Sender).ItemData[ItemIdx] );
xRect := Rect;
FillRect(DC,Rect,0);
// if j < 0  then
    if FD.TrueType then
    begin
        DrawIcon(DC,Rect.Left+2,Rect.Top+1,TTImage);
        // j := -j;
        end;
//xfont := HFONT(j);
xfont := FD.Handle;
xRect.Left := xRect.Left + 20;
if xfont <> 0 then SelectObject(DC,xfont)
else
		SelectObject(DC,PControl(Sender).Font.Handle);
DrawText(DC,PChar(PControl(Sender).Items[ItemIdx]),Length(PControl(Sender).Items[ItemIdx]),xRect,DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
if (odaSelect in DrawAction) then InvertRect(DC,Rect);
end;
Result := False;
end;



procedure  TFontCombo.DestroyFontList;
var
i    : Integer;
xfont : HFONT;
//j  : LongInt;
FD: PFontDef;
begin
	for i:= 0 to  fControl.Count -1 do
   begin
   //j := fControl.ItemData[i];
   // if j < 0 then j := -j;
   FD := Pointer( fControl.ItemData[i] );
   //xfont := HFONT(j);
   xfont := FD.Handle;
   FreeMem( FD );
   //
   if xfont <> 0 then DeleteObject(xfont);
   end;
   fControl.Clear;
end;

destructor TFontCombo.Destroy;
begin
  fFontName := '';
		DestroyFontList;
  /////////////////////////////
  //      CloseHandle(TTImage);
  //////////////////////////////
     DestroyIcon( TTImage ); //
  //////////////////////////////
        fControl.Free;
		inherited;
end;





procedure TFontCombo.MakeFontList;
var
DC : HDC;
begin
	 DestroyFontList;
    DC := GetDC(0);
    fControl.BeginUpdate;
        try
            EnumFontFamilies(DC,nil,@EnumFontsProc,LongInt(@Self));
        finally
            ReleaseDC(0,DC);
            fControl.EndUpdate;
        end;

end;

end.
