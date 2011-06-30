unit KOLmdvGliphLabel;
// Компонент TKOLmdvGliphLabel - Отображение текста при помощи Bitmap.
// E-Mail: dominiko-m@yandex.ru
// Автор: Матвеев Дмитрий

// - История -

// Дата: 30.07.2003 Версия: 1.02
// [!] - найдены и исправлены утечеки ресурсов.

// Дата: 28.04.2003 Версия: 1.01
// [*] - небольшие мелкие изменения

// Дата: 15.10.2002 Версия: 1.00
   {Стартовая версия}

{
  Описание ключевых свойств
    property Alphabet - алфавит, которому ставится в соответствие GlyphBitmap;
    property GlyphBitmap - Bitmap для отображения текста, делится на символы в сответствии с длиной Alphabet;
    property Caption - отображаемый текст;
    property TransparentLabel - признак прозрачности цвета TransparentColor в GlyphBitmap;
    property TransparentColor - прозрачный цвет в GlyphBitmap;
    property VerticalAlign - вертикальное выравнивание;
    property TextAlign - горизонтальное выравнивание;
}
interface

uses Windows, Messages, KOL;

type

  PmdvGliphLabel = ^TmdvGliphLabel;
  TmdvGliphLabel = object(TControl)
  private
    procedure Paint(DC: HDC);
    function GetAlphabet: String;
    procedure SetAlphabet(const Value: String);
    function GetTransparentLabel: Boolean;
    procedure SetTransparentLabel(const Value: Boolean);
    function GetTransparentColor: TColor;
    procedure SetTransparentColor(const Value: TColor);
    function GetCaption: String;
    procedure SetCaption(const Value: String);

  public
//    property VerticalAlign read fVerticalAlign write fVerticalAlign;
    property Alphabet: String read GetAlphabet write SetAlphabet;
    property Caption: String read GetCaption write SetCaption;
    property TransparentLabel: Boolean read GetTransparentLabel write SetTransparentLabel;
    property TransparentColor: TColor read GetTransparentColor write SetTransparentColor;
    property GlyphBitmap: HBitmap read fGlyphBitmap write fGlyphBitmap;
  end;

  TKOLmdvGliphLabel = PmdvGliphLabel;

function NewmdvGliphLabel(AParent: PControl; ACaption, AAlphabet: String; ATransparentLabel: Boolean; ATransparentColor: TColor; AGlyphBitmap: HBitmap): TKOLmdvGliphLabel;

implementation
type
  PmdvGliphLabelData = ^TmdvGliphLabelData;
  TmdvGliphLabelData = object(TObj)
     FAlphabet, FCaption: String;
     FTransparentLabel: Boolean;
     FTransparentColor: TColor;
     destructor Destroy; virtual;
  end;


function WndProcGliphLabel(Sender: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var PaintStruct: TPaintStruct;
    DC: HDC;
begin
    Result := FALSE;
   case Msg.message of
      WM_PAINT: Begin
        if PmdvGliphLabel(Sender).fUpdCount>0 then Exit;
        if Msg.wParam = 0 then DC:= BeginPaint(Sender.Handle, PaintStruct) else DC := Msg.wParam;
        PmdvGliphLabel(Sender).Paint(DC);
        if Msg.wParam = 0 then EndPaint(Sender.Handle, PaintStruct);
        Result:= True;
        Rslt:= 0;
      end;
    end;
end;

function NewmdvGliphLabel(AParent: PControl; ACaption, AAlphabet: String; ATransparentLabel: Boolean; ATransparentColor: TColor; AGlyphBitmap: HBitmap): TKOLmdvGliphLabel;
var mdvGliphLabelData: PmdvGliphLabelData;
begin
    Result:= TKOLmdvGliphLabel(NewPanel(AParent, esNone));
    New(mdvGliphLabelData, Create);
    Result.fCustomObj:= mdvGliphLabelData;
    Result.fGlyphBitmap:= AGlyphBitmap;
    mdvGliphLabelData.FCaption:= ACaption;
    mdvGliphLabelData.FAlphabet:= AAlphabet;
    mdvGliphLabelData.FTransparentLabel:= ATransparentLabel;
    mdvGliphLabelData.FTransparentColor:= ATransparentColor;
    Result.AttachProc(WndProcGliphLabel);
end;

{ TmdvGliphLabel }

function TmdvGliphLabel.GetAlphabet: String;
begin
    Result:= PmdvGliphLabelData(FCustomObj).FAlphabet;
end;

function TmdvGliphLabel.GetCaption: String;
begin
    Result:= PmdvGliphLabelData(FCustomObj).FCaption;
end;

function TmdvGliphLabel.GetTransparentColor: TColor;
begin
    Result:= PmdvGliphLabelData(FCustomObj).FTransparentColor;
end;

function TmdvGliphLabel.GetTransparentLabel: Boolean;
begin
    Result:= PmdvGliphLabelData(FCustomObj).FTransparentLabel;
end;

{$WARNINGS OFF}
procedure TmdvGliphLabel.Paint(DC: HDC);
var tDC, MemDC, MaskDC: HDC;
    tBmp, MaskBmp, MskBmp, MemBmp, MmBmp: HBitmap;
    tBrush: HBRUSH;
    i, k, X, Y: Integer;
    BM: BITMAP;
    crText, crBack: TColorRef;
begin
    if not Transparent then begin
      tBrush:= CreateSolidBrush(Color2RGB(Self.fColor));
      FillRect(DC, ClientRect, tBrush);
      DeleteObject(tBrush);
    end;
    if PmdvGliphLabelData(FCustomObj).FAlphabet = '' then Exit;
    if PmdvGliphLabelData(FCustomObj).FCaption = '' then Exit;

    GetObject(fGlyphBitmap, sizeof(BITMAP), @BM);

    tDC := CreateCompatibleDC(0);
    tBmp := SelectObject(tDC, fGlyphBitmap);

    if PmdvGliphLabelData(FCustomObj).FTransparentLabel then begin
      MemDC := CreateCompatibleDC(0);
      MemBmp := CreateCompatibleBitmap(tDC, BM.bmWidth, BM.bmHeight);
      MmBmp:= SelectObject(MemDC, MemBmp);

      MaskBmp := CreateBitmap(BM.bmWidth, BM.bmHeight, 1, 1, nil);
      MaskDC := CreateCompatibleDC(0);
      MskBmp:= SelectObject(MaskDC, MaskBmp);
      crBack := Windows.SetBkColor(tDC, Color2RGB(PmdvGliphLabelData(FCustomObj).FTransparentColor));
      BitBlt(MaskDC, 0, 0, BM.bmWidth, BM.bmHeight, tDC, 0, 0, SRCCOPY);
      Windows.SetBkColor(tDC, crBack);

      BitBlt(MemDC, 0, 0, BM.bmWidth, BM.bmHeight, MaskDC, 0, 0, SrcCopy);
      BitBlt(MemDC, 0, 0, BM.bmWidth, BM.bmHeight, tDC, 0, 0, SrcErase);

      crText := SetTextColor(DC, $0);
      crBack := Windows.SetBkColor(DC, $FFFFFF);
    end;

    BM.bmWidth:= BM.bmWidth div Length(PmdvGliphLabelData(FCustomObj).FAlphabet);

    case fVerticalAlign of
      vaCenter: Y:= (Height - BM.bmHeight) div 2;
      vaBottom: Y:= (Height - BM.bmHeight);
      else Y:= 0;
    end;                               
    case fTextAlign of
      taCenter: X:= (Width - Length(PmdvGliphLabelData(FCustomObj).FCaption)*BM.bmWidth) div 2;
      taRight: X:= (Width - Length(PmdvGliphLabelData(FCustomObj).FCaption)*BM.bmWidth);
      else X:= 0;
    end;

    for i:= 1 to Length(PmdvGliphLabelData(FCustomObj).FCaption) do begin
      k:= Pos(PmdvGliphLabelData(FCustomObj).FCaption[i], PmdvGliphLabelData(FCustomObj).FAlphabet);
      if k > 0 then begin
        if PmdvGliphLabelData(FCustomObj).FTransparentLabel then begin
          BitBlt(DC, X+BM.bmWidth*(i-1), Y, BM.bmWidth, BM.bmHeight, MaskDC, BM.bmWidth*(k-1), 0, SrcAnd);
          BitBlt(DC, X+BM.bmWidth*(i-1), Y, BM.bmWidth, BM.bmHeight, MemDC, BM.bmWidth*(k-1), 0, SrcInvert);
        end
        else BitBlt(DC, X+BM.bmWidth*(i-1), Y, BM.bmWidth, BM.bmHeight, tDC, BM.bmWidth*(k-1), 0, SRCCOPY);
      end;
    end;

    if PmdvGliphLabelData(FCustomObj).FTransparentLabel then begin
      Windows.SetBkColor( DC, crBack);
      SetTextColor( DC, crText);

      SelectObject(MaskDC, MskBmp);
      DeleteObject(MaskBmp);
      DeleteDC(MaskDC);
      SelectObject(MemDC, MmBmp);
      DeleteDC(MemDC);
      DeleteObject(MemBmp);
    end;
    SelectObject(tDC, tBmp);
    DeleteDC(tDC);
end;
{$WARNINGS ON}
procedure TmdvGliphLabel.SetAlphabet(const Value: String);
begin
    PmdvGliphLabelData(FCustomObj).FAlphabet:= Value;
    Invalidate;
end;

procedure TmdvGliphLabel.SetCaption(const Value: String);
begin
    PmdvGliphLabelData(FCustomObj).FCaption:= Value;
    Invalidate;
end;

procedure TmdvGliphLabel.SetTransparentColor(const Value: TColor);
begin
    PmdvGliphLabelData(FCustomObj).FTransparentColor:= Value;
    Invalidate;
end;

procedure TmdvGliphLabel.SetTransparentLabel(const Value: Boolean);
begin
    PmdvGliphLabelData(FCustomObj).FTransparentLabel:= Value;
    Invalidate;
end;

{ TmdvGliphLabelData }

destructor TmdvGliphLabelData.Destroy;
begin
    FAlphabet:= ''; FCaption:= '';
    inherited;
end;

end.
