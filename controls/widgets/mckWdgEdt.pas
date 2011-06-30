unit mckWdgEdt;

interface

uses
  Windows,
  Classes,
  Graphics,
  Controls,
  Forms,
  StdCtrls,
  Grids,
  ExtCtrls,
 {$IFDEF VER140}
  DesignIntf,
  DesignEditors,
  DesignConst,
  Variants, 
 {$ELSE}
  DsgnIntf,
 {$ENDIF}
  ComCtrls;

type
  TKOLWidgetEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;

type
  TWidgetEditDlg = class(TForm)
    ComboBox1: TComboBox;
    Bold: TCheckBox;
    Italic: TCheckBox;
    GlyphGrid: TStringGrid;
    FontLabel: TLabel;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    ColorGrid: TStringGrid;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Image: TImage;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ItalicClick(Sender: TObject);
    procedure BoldClick(Sender: TObject);
    procedure GlyphGridClick(Sender: TObject);
    procedure ColorGridDrawCell(Sender: TObject; Col, Row: longint;
      Rect: TRect; State: TGridDrawState);
    procedure ColorGridClick(Sender: TObject);
    procedure GlyphGridSelectCell(Sender: TObject; Col, Row: longint;
      var CanSelect: Boolean);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
    Glyph: char;
    OffsetLeft: integer;
    OffSetTop: integer;
  public
    { Public declarations }
    procedure DrawPanel;
  end;

procedure Register;

implementation

uses
  mckWidget;

{$R *.dfm}

procedure Register;
begin
  RegisterComponents('KOLUtil', [TKOLWidget]);
  RegisterComponentEditor(TKOLWidget, TKOLWidgetEditor);
end;

const
  Colors : array [0..15] of TColor =
  (clBlack, clMaroon, clGreen, clOlive,
   clNavy, clPurple, clTeal, clGray,
   clSilver, clRed, clLime, clYellow,
   clBlue, clFuchsia, clAqua, clWhite);

function TKOLWidgetEditor.GetVerbCount: integer;
begin
  Result:=1;
end;

function TKOLWidgetEditor.GetVerb(Index: integer): string;
begin
  Result:='Edit &Widget';
end;

function IndexFromColor(C: TColor): integer;
var
  i: integer;
begin
  i:=0;
  while (i < 16) and (ColorToRGB(Colors[i]) <> ColorToRGB(C)) do
    inc(i);
  if i=16 then
    Result:=0
  else
    Result:=i;
end;

procedure TKOLWidgetEditor.ExecuteVerb(Index: integer);
var
  D: TWidgetEditDlg;
begin
  D:=TWidgetEditDlg.Create(Application);
  try
    with Component as TKOLWidget do
    begin
    D.Caption:=Owner.Name + '.' + Name + D.Caption;
    D.GlyphGrid.Font.Name:=Font.Name;
    D.ComboBox1.ItemIndex:=D.ComboBox1.Items.IndexOf(Font.Name);
    D.Bold.Checked:=fsBold in Font.Style;
    D.Italic.Checked:=fsItalic in Font.Style;
    D.Image.Picture.Bitmap:=Image;
    D.Glyph:=Glyph;
    D.OffsetLeft:=OffsetLeft;
    D.OffsetTop:=OffsetTop;
    D.UpDown1.Position:=-OffsetTop;
    D.UpDown2.Position:=OffsetLeft;
    D.GlyphGrid.Row:=ord(Glyph) div 16;
    D.GlyphGrid.Col:=ord(Glyph) mod 16;
    D.ColorGrid.Col:=IndexFromColor(Font.Color);
    end;
    if D.ShowModal = mrOK then
    begin
      with Component as TKOLWidget do
      begin
        Font.Name:=D.GlyphGrid.Font.Name;
        Font.Color:=D.GlyphGrid.Font.Color;
        Font.Style:=D.GlyphGrid.Font.Style;
        Glyph:=D.Glyph;
        Image:=D.Image.Picture.Bitmap;;
        OffsetLeft:=D.OffsetLeft;
        OffsetTop:=D.OffsetTop;
      end;
      Designer.Modified;
    end;
  finally
    D.Free;
  end;
end;

procedure TWidgetEditDlg.FormCreate(Sender: TObject);
var
  vCol, vRow: longint;
begin
  ComboBox1.Items:=Screen.Fonts;
  with GlyphGrid do
  begin
    DefaultColWidth := (ClientWidth div 16) - GridLineWidth;
    DefaultRowHeight := (ClientHeight div 16) - GridLineWidth;
    for vRow:=0 to 15 do
      for vCol:=0 to 15 do
        Cells[vCol,vRow]:=chr(vRow*16 + vCol);
  end;
end;

procedure TWidgetEditDlg.ComboBox1Change(Sender: TObject);
begin
  GlyphGrid.Font.Name:=ComboBox1.Items[ComboBox1.ItemIndex];
  DrawPanel;
end;

procedure TWidgetEditDlg.ItalicClick(Sender: TObject);
var
  fs: TFontStyles;
begin
  fs:=GlyphGrid.Font.Style;
  if Italic.Checked then
    Include(fs,fsItalic)
  else
    Exclude(fs,fsItalic);
  GlyphGrid.Font.Style:=fs;
  DrawPanel;
end;

procedure TWidgetEditDlg.BoldClick(Sender: TObject);
var
  fs: TFontStyles;
begin
  fs:=GlyphGrid.Font.Style;
  if Bold.Checked then
    Include(fs,fsBold)
  else
    Exclude(fs,fsBold);
  GlyphGrid.Font.Style:=fs;
  DrawPanel;
end;

procedure TWidgetEditDlg.GlyphGridClick(Sender: TObject);
begin
  with Panel1 do
  begin
    Font.Name:=GlyphGrid.Font.Name;
    Font.Height:=ClientHeight-4;
    Glyph:=GlyphGrid.Cells[GlyphGrid.Col,GlyphGrid.Row][1];
    DrawPanel;
  end;
end;

procedure TWidgetEditDlg.ColorGridDrawCell(Sender: TObject; Col,
  Row: longint; Rect: TRect; State: TGridDrawState);
begin
  ColorGrid.Canvas.Brush.Color:=Colors[Col];
  ColorGrid.Canvas.FillRect(Rect);
end;

procedure TWidgetEditDlg.ColorGridClick(Sender: TObject);
begin
  GlyphGrid.Font.Color:=Colors[ColorGrid.Col];
  DrawPanel;
end;

// A design mistake!! This routine has to parallel
// TWidget.DrawWidget or else the drawing is off.
procedure TWidgetEditDlg.DrawPanel;
var
  Y: integer;
  R: TRect;
  RB: TRect;
begin
  with Panel1 do
  begin
    Canvas.Handle := GetWindowDC(Handle);
    try
      Canvas.Font:=GlyphGrid.Font;
      Canvas.Brush.Color:=clBtnFace;
      SetBkMode(Canvas.Handle,TRANSPARENT);
      Y:=GetSystemMetrics(SM_CYSIZE);
      R:=Bounds((ClientWidth-(Y-2)) div 2, (ClientHeight - (Y-4)) div 2, Y-2, Y-4);
      DrawFrameControl(Canvas.Handle, R, DFC_BUTTON, DFCS_BUTTONPUSH);
      // define a smaller area to put the glyph in
      InflateRect(R, -2, -2);
      OffsetRect(R,OffsetLeft, OffsetTop);
        if Image.Picture.Bitmap.Empty then
        begin
          // choose a font size to fit
          Canvas.Font.Height := (R.Top - R.Bottom - 1);
          DrawText(Canvas.Handle, pchar(string(Glyph)), 1, R, DT_CENTER or DT_VCENTER or DT_NOCLIP);
         end
        else
        begin
          RB:=Image.Canvas.ClipRect;
          Canvas.BrushCopy(R, Image.Picture.Bitmap, RB, Image.Picture.Bitmap.TransparentColor);
        end;
    finally
      ReleaseDC(Handle, Canvas.Handle);
      Canvas.Handle := 0;
    end;

  end;
end;

procedure TWidgetEditDlg.GlyphGridSelectCell(Sender: TObject; Col,
  Row: longint; var CanSelect: Boolean);
begin
  DrawPanel;
end;

procedure TWidgetEditDlg.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  OffsetTop:=-UpDown1.Position;
  DrawPanel;
end;

procedure TWidgetEditDlg.UpDown2Click(Sender: TObject; Button: TUDBtnType);
begin
  OffsetLeft:=UpDown2.Position;
  DrawPanel;
end;

end.
