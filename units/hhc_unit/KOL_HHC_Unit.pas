//++++++++++++++++++++++++++++++++++++
// KOL_HHC_UNIT                      +
// версия 1.1                        +
// автор Бабахин Алексей             +
// вопросы и пердложения направлять: +
// tamerlan311@mail.ru               +
//++++++++++++++++++++++++++++++++++++
// что нового :
// v1.1
// [!] немного исправлена отрисовка
// [!] исправлена процедура setbitmap
// [-] убрано извращение с $IFDEF которое совершенно не нужно даже
//      если бы работало(не используемые процедурю и так не компиляться!)
// [+] добавлено свойство trans_color определяющее цвет который надо ввырезать
// [+] добавлена функция update_rgn обновляет непрямоугольный регион
// v1.2
// 18.03.03
// [!] исправлен баг с ОГРОМНОЙ утечкой ресурсов в процедуре bitmaptoregion и в самом компоненте!
// [!] переработана функция createbitmapbuttonex(стили)
// [!] исправлен механизм ассоциации региона с окном!
// [!] некоторые исправления еще

unit KOL_HHC_unit;
{* В этом модуле собраны компоненты процедуры и функции написанные Виртуальной
корпорацией Hacker-House Company для библиотеки KOL&MCK}
interface
uses
  windows, messages, KOL, kolmath;

type
  Tlevel = 1..255;

//------------------------------------------------------------------------------
//-------------bitmap button
//------------------------------------------------------------------------------
  Pbitmapbutton = ^Tbitmapbutton;//
  TKOLbitmapbutton = Pbitmapbutton;
  Tbitmapbutton = object(TControl)
  {* Вполне не стандартный контрол позволяющий создавать кнопочки не прямоугольной
  формы из обыкновенного битмапа. Для этого нужновызвать процедуру
  Newbitmapbutton либо Newbitmapbuttonex}

  private
    function gettranscolor: Tcolor;
    procedure settranscolor(val: Tcolor);
  public
    procedure setbitmap(bitm: Hbitmap);
    {* устанавливает новый битмап и изменяет форму кнопки}
    property  trans_color :TColor read gettranscolor write settranscolor ;
    procedure update_rgn;
  end;
  PbitbuttData = ^TbitbuttData;
  TbitbuttData = object(TObj)
    f_image:PBitmap;
    ts_color:TColor;
    pos: TPoint;
    destructor Destroy; virtual;
  end;

//------------------------------------------------------------------------------
//-----------декларация пппроцедур
//------------------------------------------------------------------------------
function Newbitmapbuttonex(AOwner: PControl; Himage:HBITMAP; left,top:integer; ts_cl:TColor): Pbitmapbutton;
{* создает новый bitmapbutton с расширенной инициализацией объекта}
function Newbitmapbutton(AOwner: PControl): Pbitmapbutton;
{* создает новый bitmapbutton}

function BitmapToRegion(hmap: HBitmap; TransColor: Cardinal):  HRGN;
{* создает регион пользуясь битмапом}
function Bitmap_size(Bitmap: HBITMAP):tsize;
{* определяет размер битмапа имея его шендл}
function Bitmap_copy(origin: Hbitmap): Hbitmap;
{* копирует битмап (создает новую битовую марицу, копирует туда указанную -//- и возвращает шендл)}

procedure ColorRGBToHLS(clrRGB: COLORREF; var Hue, Luminance, Saturation: Byte);
{* вычисляет тон, яркость и контраст по составляющим RGB (дернуто из GraphUtil)}
function ColorHLSToRGB(Hue, Luminance, Saturation: Byte): TColorRef;
{* преобразует HSL в RGB обратно предыдущей функции}
function HueToRGB(Lum, Sat, Hue: Double): Integer;

procedure bit2bg_bit(color: TColor; level: Tlevel; bitmap: HBITMAP);
{* преобразует карту бит в монотонный рисунок с цветом color. от level зависит контраст}
//function open_colose_cd(Drive:Pchar;open:boolean): boolean;


implementation

uses Math;

destructor TbitbuttData.Destroy;
begin
 DeleteObject(f_image.Handle);
 inherited;
end;

const
  HLSMAX = 240;            // максимальные значения яркости тона и контрастности
  RGBMAX = 255;            // максимальные значения RGB
  HLSUndefined = (HLSMAX*2/3);// незнаю
  error_copy_bitmap = 'Ошибка при копировании битмапа!';
  error_reate_rgn = 'Ошибка при создании непрямоугольного региона!';
  error_in_size = 'ошибка при определении размеров битмапа';

function WndProcBitbuttParent( Sender: PControl; var Msg: TMsg; var Rslt:Integer ): boolean;
var
  D:PbitbuttData;
  k:HDC;
  PaintStruct: TPaintStruct;
begin
  D:=Pointer(Sender.CustomObj);
  Result:=false;
  case msg.message of
  WM_CREATE      : begin
                     If D.f_image.Handle<>0 then 
                     SetWindowRgn(Msg.hwnd,BitmapToRegion(D.f_image.Handle,D.ts_color), True);
                   end;
  WM_PAINT       : begin
                     k:=Msg.wParam;
                     if k=0 then
                     k:= BeginPaint(Sender.Handle, PaintStruct);
                     D.f_image.Draw(k,0,0);
                     if Msg.wParam=0 then
                     EndPaint(Sender.Handle, PaintStruct);
                     Result:=True;
                   end;
  WM_LBUTTONDBLCLK,
  WM_LBUTTONDOWN : begin
                     Sender.SetPosition(Sender.Position.X-2,Sender.Position.Y-2);
                     Sender.Update;
                     Sender.Parent.Update;
                   end;
  WM_LBUTTONUP   : begin
                     Sender.SetPosition(sender.Position.X+2,sender.Position.Y+2);
                     Sender.Update;
                     Sender.Parent.Update;
                   end;
  end;
end;


function Newbitmapbuttonex(AOwner: PControl; Himage:HBITMAP; left,top:integer; ts_cl:TColor): Pbitmapbutton;
var D: PbitbuttData;
begin
Result:=Newbitmapbutton(AOwner);
{Result:=Pbitmapbutton(_NewControl( AOwner, 'BUTTON',
                      WS_CHILD or WS_VISIBLE or
                      BS_USERBUTTON or BS_CHECKBOX or
                      BS_DEFPUSHBUTTON, False, nil ));
GetMem( D, Sizeof( D^ ) );
Pointer(Result.CustomObj):=D;
D.f_image := NewBitmap(0,0);
Result.AttachProc(WndProcBitbuttParent);}
D:=Pointer(Result.CustomObj);
D.f_image.Handle:=Bitmap_copy(Himage);
Result.SetPosition(left,top);
Result.SetSize(D.f_image.Width,D.f_image.Height);
D.ts_color:=ts_cl;
end;

function Newbitmapbutton(AOwner: PControl): Pbitmapbutton;
var D: PbitbuttData;
begin
Result:=Pbitmapbutton(_NewControl( AOwner, 'BUTTON',
                      WS_CHILD or WS_VISIBLE or
                      BS_USERBUTTON or BS_CHECKBOX or
                      BS_DEFPUSHBUTTON, False, nil ));
New(D, Create);
Result.CustomObj:=D;
D.f_image := NewBitmap(0,0);
D.ts_color:=clWhite;
Result.AttachProc(WndProcBitbuttParent);
end;


function Tbitmapbutton.gettranscolor: Tcolor;
var D:PbitbuttData;
begin
D:=Pointer(CustomObj);
Result:=D.ts_color;
end;


procedure Tbitmapbutton.settranscolor(val: TColor);
var D:PbitbuttData;
begin
D:=Pointer(CustomObj);
D.ts_color:=val;
update_rgn;
end;

procedure Tbitmapbutton.setbitmap(bitm: Hbitmap);
var D:PbitbuttData;
tm_rgn:HRGN;
begin
D:=Pointer(CustomObj);
D.f_image.Clear;
D.f_image.Handle:=bitmap_copy(bitm);
Height:=d.f_image.Height;
Width :=d.f_image.Width;
tm_rgn:= BitmapToRegion(D.f_image.Handle,trans_color);
if fHandle<>0 then SetWindowRgn(fHandle,tm_rgn, True);
DeleteObject(tm_rgn);

end;

procedure Tbitmapbutton.update_rgn;
var d:PbitbuttData;
t_rgn:HRGN;
begin
d:=Pointer(CustomObj);
t_rgn:=BitmapToRegion(D.f_image.Handle,trans_color);
if fHandle<>0 then
  SetWindowRgn(fHandle, t_rgn, True);
DeleteObject(t_rgn);
end;



function BitmapToRegion(hmap: HBitmap; TransColor: Cardinal):  HRGN;
var
  XStart: Integer;
  X, Y: Integer;
  hd  : HDC;
  res : THandle;
  dime: TSize;
  t_rgn:HRGN;
begin
    Result:=0;
    hd := CreateCompatibleDC( 0 );
    res:= SelectObject(hd, hmap);
    if res = 0 then
               begin
               {$IFDEF mes_error} ShowMessage(error_reate_rgn);{$ENDIF}
               Exit;
               end
      else
      begin
        dime:=bitmap_size(hmap);
        Result := 0;
        for Y := 0 to dime.cy - 1 do
          begin
            X := 0;
            while X < dime.cx do
              begin
             // Пpопyскаем пpозpачные точки
                while (X < dime.cx) and (Windows.GetPixel(hd,x,y) = TransColor) do
                  Inc(X);
                if X = dime.cx then
                  Break;
                  XStart := X;
                  // Пpопyскаем непpозpачные точки
                  while (X < dime.cx) and (Windows.GetPixel(hd,x,y) < TransColor) do
                    Inc(X);
                    // Создаём новый пpямоyгольный pегион и добавляем его к
                    // pегионy всей каpтинки
                    if Result = 0 then
                      Result := CreateRectRgn(XStart, Y, X, Y + 1)
                    else begin
                    t_rgn:= CreateRectRgn(XStart, Y, X, Y + 1);
                      CombineRgn(Result, Result, t_rgn, RGN_OR);
                    DeleteObject(t_rgn);
                    end;
              end;
          end;
      end;
      SelectObject(hd, res);
      DeleteDC(hd);
end;

function Bitmap_size(Bitmap: HBITMAP):tsize;
var
  DS: windows.TBitmap;
  Bytes: Integer;
begin
  Bytes := GetObject(Bitmap, SizeOf(DS), @DS);
//  ASSERT( Bytes <> 0, 'Bitmap не найден!' ); old
  if Bytes <> 0 then //new
  begin //new
    Result.cx:=DS.bmWidth;
    Result.cy:=DS.bmHeight;
  end //new+
  else
  begin
    {$IFDEF mes_error} ShowMessage(error_in_size);{$ENDIF}
    Result.cx:=0;
    Result.cy:=0;
  end;//new-
end;

function Bitmap_copy(origin: Hbitmap): Hbitmap;
var
  size:TSize;
  dc,dc1:HDC;
  res,res1:THandle;

begin
Result:=0;
size:=Bitmap_size(origin);
dc:=CreateCompatibleDC(0);
res:= SelectObject(dc, origin);
if res=0 then
         begin
         {$IFDEF mes_error}ShowMessage(error_copy_bitmap);{$ENDIF}
         Exit;
         end;
dc1:=CreateCompatibleDC(dc);
Result:=CreateCompatibleBitmap(dc,size.cx,size.cy);
res1:=SelectObject(dc1,Result);
BitBlt( dc1,0,0,size.cx,size.cy,dc,0,0,SrcCopy);
SelectObject(dc,res);
DeleteDC(dc);
SelectObject(dc1,res1);
DeleteDC(dc1);
end;


procedure ColorRGBToHLS(clrRGB: COLORREF; var Hue, Luminance, Saturation: Byte);
var
  H, L, S: Double;
  R, G, B: Word;
  cMax, cMin: Double;
  Rdelta, Gdelta, Bdelta: Extended; { intermediate value: % of spread from max }
begin
  R := GetRValue(clrRGB);
  G := GetGValue(clrRGB);
  B := GetBValue(clrRGB);

  { вычисляем яркость }
  cMax := kolMath.Max(kolMath.Max(R, G), B);
  cMin := kolMath.Min(kolMath.Min(R, G), B);
  L := ( ((cMax + cMin) * HLSMAX{239}) + RGBMAX ) / ( 2 * RGBMAX);
  if cMax = cMin then  { r=g=b --> achromatic case }
  begin                { saturation }
    Hue := Round(HLSUndefined);
    Luminance := Round(L);
    Saturation := 0;
  end
  else                 { chromatic case }
  begin
    { saturation }
    if L <= HLSMAX/2 then
      S := ( ((cMax-cMin)*HLSMAX) + ((cMax+cMin)/2) ) / (cMax+cMin)
    else
      S := ( ((cMax-cMin)*HLSMAX) + ((2*RGBMAX-cMax-cMin)/2) ) / (2*RGBMAX-cMax-cMin);

    { hue }
    Rdelta := ( ((cMax-R)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);
    Gdelta := ( ((cMax-G)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);
    Bdelta := ( ((cMax-B)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);

    if (R = cMax) then
      H := Bdelta - Gdelta
    else if (G = cMax) then
      H := (HLSMAX/3) + Rdelta - Bdelta
    else // B == cMax
      H := ((2 * HLSMAX) / 3) + Gdelta - Rdelta;

    if (H < 0) then
      H := H + HLSMAX;
    if (H > HLSMAX) then
      H := H - HLSMAX;
    Hue := Round(H);
    Luminance := Round(L);
    Saturation := Round(S);
  end;
end;

function ColorHLSToRGB(Hue, Luminance, Saturation: Byte): TColorRef;

  function RoundColor(Value: Double): Integer;
  begin
    if Value > 255 then
      Result := 255
    else
      Result := Round(Value);
  end;

var
  R,G,B: Double;               { RGB component values }
  Magic1,Magic2: Double;       { calculated magic numbers (really!) }
begin
  if (Saturation = 0) then
  begin            { achromatic case }
     R := (Luminance * RGBMAX)/HLSMAX;
     G := R;
     B := R;
     if (Hue <> HLSUndefined) then
       ;{ ERROR }
  end
  else
  begin            { chromatic case }
     { set up magic numbers }
     if (Luminance <= (HLSMAX/2)) then
        Magic2 := (Luminance * (HLSMAX + Saturation) + (HLSMAX/2)) / HLSMAX
     else
        Magic2 := Luminance + Saturation - ((Luminance * Saturation) + (HLSMAX/2)) / HLSMAX;
     Magic1 := 2 * Luminance - Magic2;

     { get RGB, change units from HLSMAX to RGBMAX }
     R := (HueToRGB(Magic1,Magic2,Hue+(HLSMAX/3))*RGBMAX + (HLSMAX/2))/HLSMAX;
     G := (HueToRGB(Magic1,Magic2,Hue)*RGBMAX + (HLSMAX/2)) / HLSMAX;
     B := (HueToRGB(Magic1,Magic2,Hue-HLSMAX/3)*RGBMAX + (HLSMAX/2))/HLSMAX;
  end;
  Result := RGB(RoundColor(R), RoundColor(G), RoundColor(B));
end;

function HueToRGB(Lum, Sat, Hue: Double): Integer;
var
  ResultEx: Double;
begin
  { range check: note values passed add/subtract thirds of range }
  if (hue < 0) then
     hue := hue + HLSMAX;

  if (hue > HLSMAX) then
     hue := hue - HLSMAX;

  { return r,g, or b value from this tridrant }
  if (hue < (HLSMAX/6)) then
    ResultEx := Lum + (((Sat-Lum)*hue+(HLSMAX/12))/(HLSMAX/6))
  else if (hue < (HLSMAX/2)) then
    ResultEx := Sat
  else if (hue < ((HLSMAX*2)/3)) then
    ResultEx := Lum + (((Sat-Lum)*(((HLSMAX*2)/3)-hue)+(HLSMAX/12))/(HLSMAX/6))
  else
    ResultEx := Lum;
  Result := Round(ResultEx);
end;


procedure bit2bg_bit(color: TColor; level: Tlevel; bitmap: HBITMAP);
var
  l_bit,l_col,h_col,s_col,tem:byte;// яркость битовой матрицы, яркость,тон и насыщеность фонового цвета
  DC:HDC;// контекст устойства в котором будет производиться трансформация бибитмапа!
  res:THandle;
  size:TSize;// размер изображения
  x,y:Integer;// переменные цыклов
  bit_col:TColor;// цвет текущей точки в битовой матрице(в данном случае в контексте устройства
  R,G,B:Integer;// компоненты цвета
  cMax, cMin: Double;// промещуточные значения в вычислении яркости
begin
  size:=Bitmap_size(bitmap);
  DC:=CreateCompatibleDC(0);
  res:= SelectObject(dc, bitmap);
  if res=0 then Exit;// если контекст устройства не ассоциирован с битмапом то выходим
  ColorRGBToHLS( Color2RGB(color),h_col,l_col,s_col);// определяем тон и насыщенность фона

  for x:= 0 to size.cx-1 do
     for y:= 0 to size.cy-1 do
      begin
        bit_col:=GetPixel(DC,x,y);
        R:=Byte(bit_col       );
        G:=Byte(bit_col shr 8 );
        B:=Byte(bit_col shr 16);
        { вычисляем яркось точки }
        cMax := kolMath.Max(kolMath.Max(R, G), B);
        cMin := kolMath.Min(kolMath.Min(R, G), B);
        l_bit :=Round( ( ((cMax + cMin) * HLSMAX{239}) + RGBMAX ) / ( 2 * RGBMAX) );
        tem:=l_col-(round((240-l_bit)/level{уровень постеризации ~7}));
        bit_col:=ColorHLSToRGB(h_col,tem,s_col);
        SetPixel(DC,x,y,bit_col);// записываям обработаный пиксель
      end;
  SelectObject(dc,res);
  DeleteDC(dc);
end;

{function open_colose_cd;
begin
Result:=False;
end;}

end.
