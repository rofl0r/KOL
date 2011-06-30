unit mckCProgBar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, mirror;

type

  TBevel = (bvUp, bvDown, bvNone);

  TKOLColorProgressBar = class(TKOLCustomControl)
  private
    { Private declarations }
    fPosition: integer;
    fOldPosit: integer;
    fBColor,
    fFColor  : TColor;
    fFirst,
    fDummy   : boolean;
    fBorder  : integer;
    fParentCl: boolean;
    fBrush   : boolean;
    fBevel   : TBevel;
    fMin,
    fMax     : integer;
    fStr     : string;
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetFColor(C: TColor);
    procedure SetBColor(C: TColor);
    procedure SetPosition(P: integer);
    procedure SetBorder(B: integer);
    procedure SetParentCl(B: boolean);
    procedure SetBevel(B: TBevel);
    procedure SetMin(M: integer);
    procedure SetMax(M: integer);
  protected
    { Protected declarations }
    procedure Paint;
    procedure WMPaint(var Msg: TMessage); message WM_PAINT;
    procedure WMSize (var Msg: TMessage); message WM_SIZE;
    procedure WMActiv(var Msg: TMessage); message WM_SHOWWINDOW;
    procedure CMParCl(var Msg: TMessage); message CM_PARENTCOLORCHANGED;

  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
  published
    { Published declarations }
    property Align;
    property Font;
    property Caption;
    property FColor: TColor read fFColor write SetFColor;
    property BColor: TColor read fBColor write SetBColor;
    property Border: integer read fBorder write SetBorder;
    property Position: integer read fPosition write SetPosition;
    property Max: integer read fMax write SetMax;
    property Min: integer read fMin write SetMin;
    property ParentColor: boolean read fParentCl write SetParentCl;
    property Bevel: TBevel read fBevel write SetBevel;

    property Cursor: boolean read fDummy;
    property HelpContext: boolean read fDummy;
    property HelpKeyWord: boolean read fDummy;
    property HelpType: boolean read fDummy;
    property Hint: boolean read fDummy;
    property IgnoreDefault: boolean read fDummy;
    property Tag: boolean read fDummy;
    
  end;

procedure Register;

implementation

{$R *.dcr}

procedure Register;
begin
  RegisterComponents('KOLUtil', [TKOLColorProgressBar]);
end;

constructor TKOLColorProgressBar.Create;
begin
   inherited;
   Caption     := '';
   fBColor     := ClBtnFace;
   fFColor     := ClRed;
   Width       := 100;
   Height      := 30;
   fFirst      := True;
   fBorder     :=  4;
   fPosition   := 50;
   fMin        := 0;
   fMax        := 100;
   ParentFont  := False;
   Font.FontHeight := -17;
   Font.FontStyle  := [fsBold];
end;

procedure TKOLColorProgressBar.WMPaint;
begin
   inherited;
   Paint;
end;

procedure TKOLColorProgressBar.WMSize;
begin
   inherited;
   fFirst := True;
   Paint;
end;

procedure TKOLColorProgressBar.WMActiv;
begin
   inherited;
   fFirst := True;
   Paint;
end;

procedure TKOLColorProgressBar.CMParCl;
begin
   inherited;
   if fParentCl then begin
      if Msg.wParam <> 0 then
         BColor := TColor(Msg.lParam) else
         BColor := (Parent as TForm).Color;
      FColor := (Parent as TForm).Font.Color;
   end;
end;

function  TKOLColorProgressBar.AdditionalUnits;
begin
   Result := ', KOLProgBar';
end;

procedure TKOLColorProgressBar.SetupFirst;
var St: string;
begin
   inherited;
   if Caption <> '' then begin
      SL.Add( Prefix + AName + '.Caption  := ''' + Caption + ''';');
   end;
   if fPosition <> 50 then begin
      SL.Add( Prefix + AName + '.Position := ' + inttostr(fPosition) + ';');
   end;
   if fBorder <> 4 then begin
      SL.Add( Prefix + AName + '.Border   := ' + inttostr(fBorder) + ';');
   end;
   if fMin <>   0 then begin
      SL.Add( Prefix + AName + '.Min      := ' + inttostr(fMin) + ';');
   end;
   if fMax <> 100 then begin
      SL.Add( Prefix + AName + '.Max      := ' + inttostr(fMax) + ';');
   end;
   if fFColor <> clRed then begin
      SL.Add( Prefix + AName + '.FColor   := ' + color2str(fFColor) + ';');
   end;
   if fBColor <> clRed then begin
      SL.Add( Prefix + AName + '.BColor   := ' + color2str(fBColor) + ';');
   end;
   if fBevel <> bvDown then begin
      if fBevel = bvUp then St := 'bvUp' else St := 'bvNone';
      SL.Add( Prefix + AName + '.Bevel    := ' + St + ';');
   end;
end;

procedure TKOLColorProgressBar.SetFColor;
begin
   fFColor   := C;
   fFirst    := True;
   Paint;
   Change;
end;

procedure TKOLColorProgressBar.SetBColor;
begin
   fBColor := C;
   fFirst  := True;
   Paint;
   Change;
end;

procedure TKOLColorProgressBar.SetPosition;
begin
   fPosition := P;
   Paint;
   Change;
end;

procedure TKOLColorProgressBar.SetBorder;
begin
   fBorder := B;
   fFirst := True;
   Paint;
   Change;
end;

procedure TKOLColorProgressBar.SetParentCl;
begin
   fParentCl := B;
   if B then begin
      Perform(CM_PARENTCOLORCHANGED, 0, 0);
      Paint;
   end;
   Change;
end;

procedure TKOLColorProgressBar.SetBevel;
begin
   fBevel := B;
   fFirst := True;
   Paint;
   Change;
end;

procedure TKOLColorProgressBar.SetMin;
begin
   fMin := M;
   fFirst := True;
   if fMax = fMin then fMax := fMin + 1;
   Paint;
   Change;
end;

procedure TKOLColorProgressBar.SetMax;
begin
   fMax := M;
   fFirst := True;
   if fMin = fMax then fMin := fMax - 1;
   Paint;
   Change;
end;

procedure TKOLColorProgressBar.Paint;
var Rct: TRect;
    Trc: TRect;
    Twk: TRect;
    Str: string;
    Rht: integer;
    Len: integer;
    Rgn: HRgn;
begin
   Rct := GetClientRect;
   Trc := Rct;
   if (fPosition <= fOldPosit) or fFirst or
      (csDesigning in ComponentState) then begin
      case fBevel of
  bvUp: begin
           Frame3D(Canvas, Rct, clWhite, clBlack, 1);
        end;
bvDown: begin
           Frame3D(Canvas, Rct, clBlack, clWhite, 1);
        end;
      end;

      fFirst := False;
      Canvas.brush.Color := fBColor;
      Canvas.FillRect(Rct);
   end;
   Rct    := Trc;

   InflateRect(Rct, -fBorder, -fBorder);
   Rct.Right  := Rct.Left + (Rct.Right - Rct.Left) * fPosition div (Max - Min);

   Str := ' ' + inttostr(fPosition * 100 div (fMax - fMin)) + '% ';
   if Caption <> '' then Str := Caption;
   Len := Canvas.TextWidth(Str);
   Trc.Left  := (width - Len) div 2;
   Trc.Right := Trc.Left + Len;

   if (Rct.Right <= Trc.Left) then begin
      Canvas.brush.Color := fFColor;
      Canvas.FillRect(Rct);
   end else begin
      Canvas.brush.Color := fFColor;
      Twk       := Rct;
      Twk.Right := Trc.Left;
      Canvas.FillRect(Twk);
   end;

   Rht := Rct.Right;
   Canvas.Font.Name   := Font.FontName;
   Canvas.Font.Height := Font.FontHeight;
   Canvas.Font.Color  := Font.Color;
   Canvas.Font.Style  := Font.FontStyle;
   Len := Length(Str);
   Rct.Left  := (width - Canvas.TextWidth(Str)) div 2;
   Rct.Right := (width + Canvas.TextWidth(Str)) div 2 + 1;

   if (fStr <> Str) or ffirst or (csDesigning in ComponentState) then begin
      if (Rct.Right > Rht) or (Canvas.TextHeight(Str) > (Rct.Bottom - Rct.Top)) then begin
         Rgn := CreateRectRgn({Left +} Rht, {Top +} Rct.Top, {Left +} Rct.Right, {Top +} Rct.Bottom);
         SelectClipRgn(Canvas.Handle, Rgn);
         Canvas.brush.Color := fBColor;
         SetTextColor(Canvas.Handle, ColorToRGB(fFColor));
         DrawText(Canvas.Handle, @Str[1], Len, Rct, DT_TOP {or DT_NOCLIP});
         SelectClipRgn(Canvas.Handle, 0);
         DeleteObject(Rgn);
      end;
   end;

   if Rht < Rct.Right then begin
      Rct.Right := Rht;
   end;

   Dec(Rct.Left);
   Inc(Rct.Right);

   if (Rct.Right > Rct.Left) then begin
      Canvas.brush.Color := fFColor;
      SetTextColor(Canvas.Handle, ColorToRGB(fBColor));
      DrawText(Canvas.Handle, @Str[1], Len, Rct, DT_TOP);
{      if Rct.Right < Trc.Right then begin}
         Twk := Rct;
         Twk.Top := Twk.Top + Canvas.TextHeight(Str);
         if Twk.Top < Twk.Bottom then begin
            Canvas.Fillrect(Twk);
         end;
{      end;}
   end;

   if (Rct.Right >= Trc.Right) then begin
      Canvas.brush.Color := fFColor;
      Rct.Left  := Trc.Right - 1;
      Rct.Right := Rht;
      Canvas.FillRect(Rct);
   end;

   fStr := Str;
   fOldPosit := fPosition;
end;

end.
