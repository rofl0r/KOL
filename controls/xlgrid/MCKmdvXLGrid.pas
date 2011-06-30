unit MCKmdvXLGrid;

interface
{$I KOLDEF.INC}
{$IFDEF _D7orHigher}
  {$WARN UNSAFE_TYPE OFF} // Too many such warnings in Delphi7
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}
uses Windows, Messages, mirror, MCKCtrls, KOL, KOLmdvXLGrid, Controls, Classes, Forms, Graphics;

type
  TmdvXLCell = class;

  TKOLmdvXLGrid = class(TKOLCustomControl)        
  private

    FDefaultColWidth, FDefaultRowHeight: Integer;
    FColCount, FRowCount: Word;
    FTitleColWidth: Integer; FTitleRowHeight: Integer;
    FTitleRow, FTitleCol: TStrings;
    FRows: TList;
    FColWidths, FRowHeights: TList;
    FResizeCol, FResizeRow, FNewSizeCol, FNewSizeRow, FXSizeCol, FYSizeRow, FMovingCol, FMovingRow, FMovingInc: Integer;
    FTopRow, FLeftCol: Integer;
    FUpdate: Integer;
    FOptions: TxlgOptions;
    FAlignmentVert: TvAlignmentText;
    FAlignmentHor: ThAlignmentText;

    FLineColor: TColor;
    FLineWidth: TRect;
    FTitleFont: TKOLFont;
    FTitleColor: TColor;
    FIndent: TRect;
    FTitleSelectedColor: TColor;
    FTitleSelectedFontColor: TColor;

    ilMoving: TImageList;
    FOnSized: TOnSized;
    FOnFocusChange: TOnFocusChange;
    FOnBeginEdit: TOnBeginEdit;
    FOnMoved: TOnMoved;
    FGridStyle: TmdvGridStyle;
    FTitleRowButton: Boolean;
    FTitleColButton: Boolean;
    FOnSelectedChange: TOnSelectedChange;
    FSelectedFontColor: TColor;
    FSelectedColor: TColor;
    FOnButtonDown: TOnButtonDown;
    FOnEndEdit: TOnEndEdit;
    FSelectedColorLine: TColor;
    FOnDrawCell: TOnDrawCell;
    FOnDrawTitle: TOnDrawCell;
    FResizeSensitivity: Byte;
    FDefEditorEvents: Boolean;

    procedure UpdateScrollBars;

    procedure WMNCHitTest(var Message: TMessage); message WM_NCHITTEST;
    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;

    procedure ReadColWidths(Reader: TReader);
    procedure ReadRowHeights(Reader: TReader);
    procedure WriteColWidths(Writer: TWriter);
    procedure WriteRowHeights(Writer: TWriter);

    procedure SetRowCount(const Value: Word);
    procedure SetColCount(const Value: Word);
    procedure SetColWidths(Index: Integer; const Value: Integer);
    procedure SetRowHeights(Index: Integer; const Value: Integer);
    procedure SetDefaultColWidth(const Value: Integer);
    procedure SetDefaultRowHeight(const Value: Integer);
    procedure SetTitleColWidth(const Value: Integer);
    procedure SetTitleRowHeight(const Value: Integer);

    procedure SetTitleCol(const Value: TStrings);
    procedure SetTitleRow(const Value: TStrings);

    procedure SetColor(const Value: TColor);
    procedure SetFont(const Value: TKOLFont);
    procedure SetLineColor(const Value: TColor);
    procedure SetLineWidthBottom(const Value: Integer);
    procedure SetLineWidthLeft(const Value: Integer);
    procedure SetLineWidthRight(const Value: Integer);
    procedure SetLineWidthTop(const Value: Integer);

    procedure SetIndentLeft(const Value: Integer);
    procedure SetIndentBottom(const Value: Integer);
    procedure SetIndentRight(const Value: Integer);
    procedure SetIndentTop(const Value: Integer);
    procedure SetAlignmentVert(const Value: TvAlignmentText);
    procedure SetAlignmentHor(const Value: ThAlignmentText);
    procedure SetOptions(const Value: TxlgOptions);
    procedure SetGridStyle(const Value: TmdvGridStyle);

    procedure SetTitleFont(const Value: TKOLFont);

    procedure SetTitleColor(const Value: TColor);
    procedure SetTitleSelectedColor(const Value: TColor);
    procedure SetTitleSelectedFontColor(const Value: TColor);

    procedure SetLeftCol(const Value: Integer);
    procedure SetTopRow(const Value: Integer);

    function  GetColWidths(Index: Integer): Integer;
    function  GetRowHeights(Index: Integer): Integer;
    function  GetVisibleColCount: Integer;
    function  GetVisibleRowCount: Integer;
    function  GetCells(Col, Row: Integer): TmdvXLCell;
    function GetFont: TKOLFont;
    function GetColor: TColor;

    procedure UpdateDesigner;
    procedure KolFont2Font(AKOLFont: TKOLFont; AFont: TFont);

    procedure MoveCol(Index, NewIndex: Integer);
    procedure MoveRow(Index, NewIndex: Integer);
    function MouseToCell(X, Y: Integer): TPoint;
    function MouseToRow(Y: Integer): Integer;
    function MouseToCol(X: Integer): Integer;
    function CellToRect(Col, Row: Integer): TRect;
    function  GetCoord(Cell: TmdvXLCell): TPoint;
    procedure BeginUpdate;
    procedure EndUpdate;
    function MouseToRowBorder(Y: Integer): Integer;
    function MouseToColBorder(X: Integer): Integer;

    property TopRow: Integer read FTopRow write SetTopRow;
    property LeftCol: Integer read FLeftCol write SetLeftCol;
    property ColWidths[Index: Integer]: Integer read GetColWidths write SetColWidths;
    property RowHeights[Index: Integer]: Integer read GetRowHeights write SetRowHeights;
    property VisibleRowCount: Integer read GetVisibleRowCount;
    property VisibleColCount: Integer read GetVisibleColCount;
    property Cells[Col, Row: Integer]: TmdvXLCell read GetCells;
    procedure SetTitleColButton(const Value: Boolean);
    procedure SetTitleRowButton(const Value: Boolean);
    procedure SetSelectedColor(const Value: TColor);
    procedure SetSelectedFontColor(const Value: TColor);
    procedure SetSelectedColorLine(const Value: TColor);
    procedure SetResizeSensitivity(const Value: Byte);
    procedure SetDefEditorEvents(const Value: Boolean);

  protected
    function AdditionalUnits: string; override;
    procedure SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFont( SL: TStrings; const AName: String ); override;
    procedure AssignEvents(SL: TStringList; const AName: String); override;

    function DefaultColor: TColor; override;
    function DefaultKOLParentColor: Boolean; override;
    procedure SetHasBorder(const Value: Boolean); override;

    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ColCount: Word read FColCount write SetColCount;
    property RowCount: Word read FRowCount write SetRowCount;
    property DefaultColWidth: Integer read FDefaultColWidth write SetDefaultColWidth;
    property DefaultRowHeight: Integer read FDefaultRowHeight write SetDefaultRowHeight;
    property TitleRowHeight: Integer read FTitleRowHeight write SetTitleRowHeight;
    property TitleColWidth: Integer read FTitleColWidth write SetTitleColWidth;
    property TitleRow: TStrings read FTitleRow write SetTitleRow;
    property TitleCol: TStrings read FTitleCol write SetTitleCol;
    property Color: TColor read GetColor write SetColor;
    property Font: TKOLFont read GetFont write SetFont;
    property LineColor: TColor read FLineColor write SetLineColor;
    property LineWidthLeft: Integer read FLineWidth.Left write SetLineWidthLeft;
    property LineWidthRight: Integer read FLineWidth.Right write SetLineWidthRight;
    property LineWidthTop: Integer read FLineWidth.Top write SetLineWidthTop;
    property LineWidthBottom: Integer read FLineWidth.Bottom write SetLineWidthBottom;
    property IndentLeft: Integer read FIndent.Left write SetIndentLeft;
    property IndentRight: Integer read FIndent.Right write SetIndentRight;
    property IndentTop: Integer read FIndent.Top write SetIndentTop;
    property IndentBottom: Integer read FIndent.Bottom write SetIndentBottom;
    property AlignmentHor: ThAlignmentText read FAlignmentHor write SetAlignmentHor;
    property AlignmentVert: TvAlignmentText read FAlignmentVert write SetAlignmentVert;
    property Options: TxlgOptions read FOptions write SetOptions;
    property TitleFont: TKOLFont read FTitleFont write SetTitleFont;
    property TitleColor: TColor read FTitleColor write SetTitleColor;
    property TitleSelectedColor: TColor read FTitleSelectedColor write SetTitleSelectedColor;
    property TitleSelectedFontColor: TColor read FTitleSelectedFontColor write SetTitleSelectedFontColor;
    property GridStyle: TmdvGridStyle read FGridStyle write SetGridStyle;
    property TitleRowButton: Boolean read FTitleRowButton write SetTitleRowButton;
    property TitleColButton: Boolean read FTitleColButton write SetTitleColButton;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor;
    property SelectedColorLine: TColor read FSelectedColorLine write SetSelectedColorLine;
    property SelectedFontColor: TColor read FSelectedFontColor write SetSelectedFontColor;
    property ResizeSensitivity: Byte read FResizeSensitivity write SetResizeSensitivity;

    property OnSized: TOnSized read FOnSized write FOnSized;
    property OnFocusChange: TOnFocusChange read FOnFocusChange write FOnFocusChange;
    property OnSelectedChange: TOnSelectedChange read FOnSelectedChange write FOnSelectedChange;
    property OnMoved: TOnMoved read FOnMoved write FOnMoved;
    property OnBeginEdit: TOnBeginEdit read FOnBeginEdit write FOnBeginEdit;
    property OnEndEdit: TOnEndEdit read FOnEndEdit write FOnEndEdit;
    property OnButtonDown: TOnButtonDown read FOnButtonDown write FOnButtonDown;
    property OnDrawCell: TOnDrawCell read FOnDrawCell write FOnDrawCell;
    property OnDrawTitle: TOnDrawCell read FOnDrawTitle write FOnDrawTitle;

    property DefEditorEvents: Boolean read FDefEditorEvents write SetDefEditorEvents;

    property TabOrder;
    property Left;
    property Top;
    property Width;
    property Height;

    property MinWidth;
    property MinHeight;
    property MaxWidth;
    property MaxHeight;
    property Cursor_;
    property PlaceDown;
    property PlaceRight;
    property PlaceUnder;
    property Visible;
    property Enabled;
    property Align;
    property CenterOnParent;
    property ParentColor;
    property ParentFont;
    property Tag;
    property HelpContext;
    property Localizy;
    property HasBorder;

    property OnClick;
    property OnMouseDblClk;
    property OnDestroy;
    property OnMessage;
    property OnKeyDown;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnResize;
    property OnMove;
    property OnDropFiles;
    property OnShow;
    property OnHide;
    property OnEraseBkgnd;
    property OnScroll;
    property OnChange;
  end;

  TmdvXLCell = class
  private
    FLineLeft, FLineTop, FLineBottom, FLineRight: PXLCellLineAttr;
    Grid: TKOLmdvXLGrid;
    function  GetLineAttr(ARect: TRect; LineDirect: TXLCellLineDirect; Coord: TPoint): TXLCellLineAttr;
    procedure Draw(ARect: TRect; Canvas: TCanvas);
  public
    constructor Create(AGrid: TKOLmdvXLGrid);
    destructor Destroy; override;
  end;

procedure Register;

implementation

{$R *.dcr}

procedure Register;
begin
    RegisterComponents('KOL', [TKOLmdvXLGrid]);
end;

function CompareRect(R_1, R_2: TRect): Boolean;
begin
   Result:= (R_1.Left = R_2.Left)and(R_1.Right = R_2.Right)and(R_1.Top = R_2.Top)and(R_1.Bottom = R_2.Bottom);
end;

{ TKOLmdvXLGrid }

constructor TKOLmdvXLGrid.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FDoubleBuffered:= True;
    Width:= 200;
    Height:= 200;

    FTitleColWidth:= DefTitleColWidth;
    FTitleRowHeight:= DefTitleRowHeight;
    FDefaultColWidth:= DefDefaultColWidth;
    FDefaultRowHeight:= DefDefaultRowHeight;
    FTitleFont:= TKOLFont.Create(Self);
    FTitleCol:= TStringList.Create; FTitleRow:= TStringList.Create;
    FTitleSelectedColor:= DefTitleSelectedColor;
    FTitleSelectedFontColor:= DefTitleSelectedFontColor;
    FTitleColor:= DefTitleColor;
    FSelectedFontColor:= DefSelectedFontColor;
    FSelectedColor:= DefSelectedColor;
    FSelectedColorLine:= DefSelectedColorLine;
    FResizeSensitivity:= DefResizeSensitivity;

    FColWidths:= TList.Create; FRowHeights:= TList.Create;
    FRows:= TList.Create;

    ilMoving:= TImageList.Create(Self);

    FResizeCol:= -1; FResizeRow:= -1;
    FNewSizeCol:= -1; FNewSizeRow:= -1;
    FMovingCol:= -1; FMovingRow:= -1;
    FTopRow:= 0; FLeftCol:= 0;
    FUpdate:= 0;
    Options:= DefOptions;
    GridStyle:= gsStandard;

    LineColor:= DefLineColor;
    LineWidthLeft:= DefLineWidthLeft; LineWidthRight:= DefLineWidthRight; LineWidthTop:= DefLineWidthTop; LineWidthBottom:= DefLineWidthBottom;
    IndentLeft:= DefIndentLeft; IndentRight:= DefIndentRight; IndentTop:= DefIndentTop; IndentBottom:= DefIndentBottom;
    AlignmentHor:= DefAlignmentHor;
    AlignmentVert:= DefAlignmentVert;
    Color:= DefColor;

    FDefEditorEvents:= True;
//    UpdateScrollBars;
end;

procedure TKOLmdvXLGrid.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_TABSTOP or WS_HSCROLL or WS_VSCROLL;
    WindowClass.style := CS_DBLCLKS;
    if HasBorder then
      if NewStyleControls and Ctl3D then begin
        Style := Style and not WS_BORDER;
        ExStyle := ExStyle or WS_EX_CLIENTEDGE;
      end
      else
        Style := Style or WS_BORDER;
  end;
end;

destructor TKOLmdvXLGrid.Destroy;
begin
    FTitleCol.Free; FTitleRow.Free;
    FColWidths.Free; FRowHeights.Free;
    FRows.Free;
    ilMoving.Free;
    inherited Destroy;
end;

function TKOLmdvXLGrid.GetColWidths(Index: Integer): Integer;
begin
    Result:= Integer(FColWidths[Index])
end;

function TKOLmdvXLGrid.GetRowHeights(Index: Integer): Integer;
begin
    Result:= Integer(FRowHeights[Index])
end;

procedure TKOLmdvXLGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Bmp: TBitmap;
    R: TRect;
begin
//    SetFocus;
//    windows.SetFocus(Handle);
//    SetFocus;
    if Button = mbLeft then begin
      if (ColCount>0)and(RowCount>0)and(FTitleRowHeight >= Y)and(FTitleColWidth < X)and(ssAlt in Shift) then begin
        UpdateDesigner;
        FMovingCol:= MouseToCol(X);
        Bmp:= TBitmap.Create;
        Bmp.Width:= ColWidths[FMovingCol]; Bmp.Height:= FTitleRowHeight;
        R:= CellToRect(FMovingCol, 0); R.Top:= ClientRect.Top; R.Bottom:= R.Top + FTitleRowHeight;
        Bmp.Canvas.CopyRect(Rect(0, 0, Bmp.Width-1, Bmp.Height-1), Canvas, R);
        Bmp.Canvas.Pen.Color:= clLime; Bmp.Canvas.Pen.Width:= 3; Bmp.Canvas.Brush.Style:= bsClear; Bmp.Canvas.Rectangle(0, 0, Bmp.Width-1, Bmp.Height-1);
        ilMoving.Clear;
        ilMoving.Width:= Bmp.Width; ilMoving.Height:= Bmp.Height;
        ilMoving.Add(Bmp, nil);
        ilMoving.SetDragImage(0, Bmp.Width div 2, 0);
        ilMoving.BeginDrag(Handle, R.Left + (R.Right-R.Left) div 2, 0);
        FMovingInc:= R.Left + (R.Right-R.Left) div 2 - X;
        ilMoving.ShowDragImage;
        Bmp.Free;
        Exit;
      end;
      if (ColCount>0)and(RowCount>0)and(FTitleColWidth >= X)and(FTitleRowHeight < Y)and(ssAlt in Shift) then begin
        UpdateDesigner;
        FMovingRow:= MouseToRow(Y);
        Bmp:= TBitmap.Create;
        Bmp.Width:= FTitleColWidth; Bmp.Height:= RowHeights[FMovingRow];
        R:= CellToRect(0, FMovingRow); R.Left:= ClientRect.Left; R.Right:= R.Left + FTitleColWidth;
        Bmp.Canvas.CopyRect(Rect(0, 0, Bmp.Width-1, Bmp.Height-1), Canvas, R);
        Bmp.Canvas.Pen.Color:= clLime; Bmp.Canvas.Pen.Width:= 3; Bmp.Canvas.Brush.Style:= bsClear; Bmp.Canvas.Rectangle(0, 0, Bmp.Width-1, Bmp.Height-1);
        ilMoving.Clear;
        ilMoving.Width:= Bmp.Width; ilMoving.Height:= Bmp.Height;
        ilMoving.Add(Bmp, nil);
        ilMoving.SetDragImage(0, 0, Bmp.Height div 2);
        ilMoving.BeginDrag(Handle, 0, R.Top + (R.Bottom-R.Top) div 2);
        FMovingInc:= R.Top + (R.Bottom-R.Top) div 2 - Y;
        ilMoving.ShowDragImage;
        Bmp.Free;
        Exit;
      end;

      if FResizeCol <> -1 then begin
        UpdateDesigner;
        FNewSizeCol:= ColWidths[FResizeCol];
        FXSizeCol:= X;
        Invalidate;
        Exit;
      end;
      if FResizeRow <> -1 then begin
        UpdateDesigner;
        FNewSizeRow:= RowHeights[FResizeRow];
        FYSizeRow:= Y;
        Invalidate;
        Exit;
      end;
    end;
    inherited MouseDown(Button, Shift, X, Y);
end;

procedure TKOLmdvXLGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var C: Integer;
    R: TRect;
begin
    if FMovingCol<>-1 then begin
      ilMoving.HideDragImage;
      ilMoving.EndDrag;
      C:= MouseToCol(X);
      MoveCol(FMovingCol, C);
      R:= CellToRect(C, 0);
      R.TopLeft:= ClientToScreen(Point(R.Left + (R.Right - R.Left) div 2, FTitleRowHeight div 2));
      Mouse.CursorPos:= R.TopLeft;
    end;
    if FMovingRow<>-1 then begin
      ilMoving.HideDragImage;
      ilMoving.EndDrag;
      C:= MouseToRow(Y);
      MoveRow(FMovingRow, C);
      R:= CellToRect(0, C);
      R.TopLeft:= ClientToScreen(Point(FTitleColWidth  div 2, R.Top + (R.Bottom - R.Top) div 2));
      Mouse.CursorPos:= R.TopLeft;
    end;

    if FNewSizeCol <> -1 then begin
      ColWidths[FResizeCol]:= FNewSizeCol;
    end;
    if FNewSizeRow <> -1 then begin
      RowHeights[FResizeRow]:= FNewSizeRow;
      FNewSizeRow:= -1;
      FResizeRow:= -1;
    end;

    FNewSizeCol:= -1; FNewSizeRow:= -1; FResizeCol:= -1; FResizeRow:= -1;
    FMovingCol:= -1; FMovingRow:= -1;

    inherited MouseUp(Button, Shift, X, Y);
end;

procedure TKOLmdvXLGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var P: TPoint;
begin
    if FMovingCol<>-1 then begin
      if ilMoving.Dragging then ilMoving.DragMove(X+FMovingInc,0);
      P:= MouseToCell(X+FMovingInc, Y);
      if P.X > LeftCol+VisibleColCount-1 then begin
        LeftCol:= P.X - VisibleColCount + 1;
        ilMoving.HideDragImage;
        Refresh; UpdateScrollBars;
        ilMoving.ShowDragImage;
      end;
      if (P.X < 0)and(LeftCol>0) then begin
        LeftCol:= Max(0, LeftCol-1);
        ilMoving.HideDragImage;
        Refresh; UpdateScrollBars;
        ilMoving.ShowDragImage;
      end;
      Exit;
    end;
    if FMovingRow<>-1 then begin
      if ilMoving.Dragging then ilMoving.DragMove(0,Y+FMovingInc);
      P:= MouseToCell(X, Y+FMovingInc); 
      if P.y > TopRow+VisibleRowCount-1 then begin
        TopRow:= P.y - VisibleRowCount + 1;
        ilMoving.HideDragImage;
        Refresh; UpdateScrollBars;
        ilMoving.ShowDragImage;
      end;
      if P.y < 0 then begin
        TopRow:= Max(0, TopRow - 1);
        P.y:= TopRow;
        ilMoving.HideDragImage;
        Refresh; UpdateScrollBars;
        ilMoving.ShowDragImage;
      end;
      Exit;
    end;

    //Изменение размеров колонки
    if FNewSizeCol <> -1 then begin
      FNewSizeCol:= Max(1, ColWidths[FResizeCol] + (X-FXSizeCol));
      Invalidate;
      Exit;
    end;
    //Изменение размеров строки
    if FNewSizeRow <> -1 then begin
      FNewSizeRow:= Max(1, RowHeights[FResizeRow] + (Y-FYSizeRow));
      Invalidate;
      Exit;
    end;

    //Определение возможности изменения размеров колонки
    if (FTitleColWidth < X) and (FTitleRowHeight > Y) then begin
      FResizeCol:= MouseToColBorder(X);
      Invalidate;
    end else
      //Определение возможности изменения размеров строки
      if (FTitleColWidth > X) and (FTitleRowHeight < Y) then begin
        FResizeRow:= MouseToRowBorder(Y);
        Invalidate;
      end else Invalidate;
    inherited MouseMove(Shift, X, Y);
end;

function TKOLmdvXLGrid.MouseToCell(X, Y: Integer): TPoint;
begin
    Result:= Point(MouseToCol(X), MouseToRow(Y));
end;

function TKOLmdvXLGrid.MouseToCol(X: Integer): Integer;
var i, Left: Integer;
begin
    Result:= -1;
    Left:= FTitleColWidth;
    for i:= LeftCol to ColCount-1 do begin
      if (X >= Left)and(X <= Left + ColWidths[i]) then begin
        Result:= i;
        Left:= Left + ColWidths[i];
        Break;
      end;
      Left:= Left + ColWidths[i];
    end;
    if X > Left then
    Result:= ColCount-1;
end;

function TKOLmdvXLGrid.MouseToRow(Y: Integer): Integer;
var i, Top: Integer;
begin
    Result:= -1;
    Top:= FTitleRowHeight;
    for i:= TopRow to RowCount-1 do begin
      if (Y >= Top)and(Y <= Top+RowHeights[i]) then begin
        Result:= i;
        Top:= Top + RowHeights[i];
        Break;
      end;
      Top:= Top + RowHeights[i];
    end;
    if Y > Top then Result:= RowCount-1;
end;

procedure TKOLmdvXLGrid.Paint;

procedure DrawDead;
var Rect: TRect;
begin
    if (FTitleColWidth = 0) or (FTitleRowHeight = 0) then Exit;
    Rect:= ClientRect;
    Rect.Right:= Rect.Left + FTitleColWidth;
    Rect.Bottom:= Rect.Top + FTitleRowHeight;
    Canvas.Brush.Color:= FTitleColor; Canvas.Brush.Style:= bsSolid; Canvas.FillRect(Rect);
    DrawEdge(Canvas.Handle, Rect, BDR_RAISEDINNER, BF_RECT);
end;

procedure DrawTitleRow;
var Rect, R: TRect;
    i, K, Last: Integer;
    S: String;
begin
    if (ColCount = 0)or(RowCount = 0) then Exit;
    if (FTitleRowHeight = 0) then Exit;
    Rect:= ClientRect; Rect.Left:= Rect.Left + FTitleColWidth; Rect.Bottom:= Rect.Top + FTitleRowHeight;
    KolFont2Font(FTitleFont, Canvas.Font);
    Canvas.Brush.Color:= FTitleColor; Canvas.Brush.Style:= bsSolid;
    if FResizeCol <> -1 then Last:= ColCount-1 else Last:= Min(ColCount-1, LeftCol + VisibleColCount);
    for i:= LeftCol to Last do begin
      K:= ColWidths[i];
      if (FNewSizeCol<>-1) and (FResizeCol = i) then K:= FNewSizeCol;
      Rect.Right:= Rect.Left + K;
      R:= Rect; S:= TitleCol[i];
      Canvas.FillRect(Rect);
      DrawText(Canvas.Handle, PChar(S), -1, Rect, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
      DrawEdge(Canvas.Handle, Rect, BDR_RAISEDINNER, BF_RECT);
      Rect.Left:= Rect.Right;
      if (FResizeCol = i) then begin
        Canvas.Pen.Color:= clBlack; Canvas.Pen.Width:= 2; Canvas.MoveTo(Rect.Left-1, Rect.Top-1); Canvas.LineTo(Rect.Left-1, ClientHeight);
      end;
    end;
end;

procedure DrawTitleCol;
var Rect, R: TRect;
    i, K, Last: Integer;
    S: String;
begin
    if (ColCount = 0)or(RowCount = 0) then Exit;
    if (FTitleColWidth = 0) then Exit;
    Rect:= ClientRect;
    Rect.Right:= Rect.Left + FTitleColWidth;
    Rect.Top:= Rect.Top + FTitleRowHeight;
    if FResizeRow <> -1 then Last:= RowCount-1 else Last:= Min(RowCount-1, TopRow + VisibleRowCount);
    KolFont2Font(FTitleFont, Canvas.Font);
    Canvas.Brush.Color:= FTitleColor; Canvas.Brush.Style:= bsSolid;
    for i:= TopRow to Last do begin
      K:= RowHeights[i];
      if (FNewSizeRow<>-1) and (FResizeRow = i) then K:= FNewSizeRow;
      Rect.Bottom:= Rect.Top + K;
      Canvas.FillRect(Rect);
      R:= Rect; S:= TitleRow[i]; DrawText(Canvas.Handle, PChar(S), -1, Rect, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
      DrawEdge(Canvas.Handle, Rect, BDR_RAISEDINNER, BF_RECT);
      if (FResizeRow = i) then begin
        Canvas.Pen.Color:= clBlack; Canvas.Pen.Width:= 2; Canvas.MoveTo(Rect.Left-1, Rect.Bottom-1); Canvas.LineTo(ClientWidth, Rect.Bottom-1);
      end;
      Rect.Top:= Rect.Bottom;
    end;
end;

procedure DrawCells;
var R: TRect;
    j, i: Integer;
begin
    if (ColCount = 0)or(RowCount = 0) then Exit;
    Canvas.Brush.Color:= Color;
    for i:= TopRow to Min(RowCount-1, TopRow + VisibleRowCount) do begin
      for j:= LeftCol to Min(ColCount-1, LeftCol + VisibleColCount) do begin
        R:= CellToRect(j, i);
        Cells[j, i].Draw(R, Canvas);
      end;
    end;
end;

begin
    if FUpdate>0 then Exit;
    Canvas.Brush.Style:= bsSolid; Canvas.Brush.Color:= Color;
    Canvas.FillRect(ClientRect);
    DrawCells;
    DrawDead;
    DrawTitleRow;
    DrawTitleCol;
end;

procedure TKOLmdvXLGrid.SetColCount(const Value: Word);
var i, j: Integer;
begin
    BeginUpdate;
    FColCount := Value;
    for i:= FTitleCol.Count to FColCount-1 do FTitleCol.Add('');
    if FTitleCol.Count > FColCount then
      for i:= FTitleCol.Count downto FColCount+1 do FTitleCol.Delete(i-1);

    for i:= FColWidths.Count to FColCount-1 do FColWidths.Add(Pointer(DefaultColWidth));
    if FColWidths.Count > FColCount then
      for i:= FColWidths.Count downto FColCount+1 do FColWidths.Delete(i-1);

    for j:= 0 to FRows.Count-1 do begin
      for i:= TList(FRows[j]).Count to Value-1 do TList(FRows[j]).Add(TmdvXLCell.Create(Self));
      if TList(FRows[j]).Count > Value then
        for i:= TList(FRows[j]).Count downto Value+1 do begin
          TmdvXLCell(TList(FRows[j])[i-1]).Free;
          TList(FRows[j]).Delete(i-1);
        end;
    end;
    EndUpdate;
    UpdateScrollBars;
    Change;
end;

procedure TKOLmdvXLGrid.SetColWidths(Index: Integer; const Value: Integer);
begin
    BeginUpdate;
    FColWidths[Index]:= Pointer(Value);
    FNewSizeCol:= -1;
    FResizeCol:= -1;
//    if Assigned(FOnSized) then FOnSized(Self, dCol, Index, Value);
    EndUpdate;
    UpdateScrollBars;
    Change;
end;

procedure TKOLmdvXLGrid.SetDefaultColWidth(const Value: Integer);
var i: Integer;
begin
    BeginUpdate;
    FDefaultColWidth := Value;
    for i:= 0 to FColCount-1 do FColWidths[i]:= Pointer(Value);
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.SetDefaultRowHeight(const Value: Integer);
var i: Integer;
begin
    BeginUpdate;
    FDefaultRowHeight := Value;
    for i:= 0 to FRowCount-1 do FRowHeights.Items[i]:= Pointer(Value);
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.SetRowCount(const Value: Word);
var i, j, k: Integer;
begin
    BeginUpdate;
    FRowCount := Value;
    for i:= FTitleRow.Count to FRowCount-1 do FTitleRow.Add('');
    if FTitleRow.Count > FRowCount then
      for i:= FTitleRow.Count downto FRowCount+1 do FTitleRow.Delete(i-1);

    for i:= FRowHeights.Count to FRowCount-1 do FRowHeights.Add(Pointer(FDefaultRowHeight));
    if FRowHeights.Count > FRowCount then
      for i:= FRowHeights.Count downto FRowCount+1 do FRowHeights.Delete(i-1);

    for i:= FRows.Count to Value-1 do begin
      k:= FRows.Add(TList.Create);
      for j:= 0 to FColCount-1 do TList(FRows[k]).Add(TmdvXLCell.Create(Self));
    end;
    if FRows.Count > RowCount then
      for i:= FRows.Count-1 downto FRowCount do begin
        for j:= TList(FRows[i]).Count-1 downto 0 do begin
          PmdvXLCell(TList(FRows[i]).Items[j]).Free;
        end;
        TList(FRows[i]).Free;
        FRows.Delete(i);
      end;
    EndUpdate;
    UpdateScrollBars;
    Change;
end;

procedure TKOLmdvXLGrid.SetRowHeights(Index: Integer; const Value: Integer);
begin
    BeginUpdate;
    FRowHeights[Index]:= Pointer(Value);
//    if Assigned(FOnSized) then FOnSized(Self, dRow, Index, Value);
    EndUpdate;
    UpdateScrollBars;
    Change;
end;

procedure TKOLmdvXLGrid.SetTitleCol(const Value: TStrings);
var i: Integer;
begin
    BeginUpdate;
    for i:= 0 to Min(Value.Count-1, FTitleCol.Count-1) do FTitleCol[i] := Value[i];
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.SetTitleColWidth(const Value: Integer);
begin
    BeginUpdate;
    FTitleColWidth := Value;
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.SetTitleRow(const Value: TStrings);
var i: Integer;
begin
    BeginUpdate;
    for i:= 0 to Min(Value.Count-1, FTitleRow.Count-1) do FTitleRow[i] := Value[i];
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.SetTitleRowHeight(const Value: Integer);
begin
    BeginUpdate;
    FTitleRowHeight := Value;
    EndUpdate;
    Change;
end;

function TKOLmdvXLGrid.CellToRect(Col, Row: Integer): TRect;
var i: Integer;
begin
    Result:= Rect(FTitleColWidth, FTitleRowHeight, FTitleColWidth, FTitleRowHeight);
    if (Col<0) or (Col>=FColCount) or (Row<0) or (Row>= FRowCount) then Exit; 
    if TopRow<=Row then
      for i:= TopRow to Row - 1 do Result.Top:= Result.Top + RowHeights[i]
    else
      for i:= Row to TopRow - 1 do Result.Top:= Result.Top - RowHeights[i];

    Result.Bottom:= Result.Top + RowHeights[Row];

    if LeftCol<= Col then
      for i:= LeftCol to Col - 1 do Result.Left:= Result.Left + ColWidths[i]
    else
      for i:= Col to LeftCol - 1 do Result.Left:= Result.Left - ColWidths[i];

    Result.Right:= Result.Left + ColWidths[Col];
end;

procedure TKOLmdvXLGrid.SetLeftCol(const Value: Integer);
begin
    if FLeftCol <> Value then begin
      FLeftCol := Value;
    end;
end;

procedure TKOLmdvXLGrid.SetTopRow(const Value: Integer);
begin
    if FTopRow <> Value then begin
      FTopRow := Value;
    end;
end;

function TKOLmdvXLGrid.GetVisibleColCount: Integer;
var i, Left: Integer;
begin
    Left:= FTitleColWidth;
    i:= LeftCol;
    while i < ColCount do begin
      if (ClientWidth <= Left + ColWidths[i]) then Break;
      Left:= Left + ColWidths[i];
      inc(i);
    end;
    Result:= Max(1, i - LeftCol);
end;

function TKOLmdvXLGrid.GetVisibleRowCount: Integer;
var i, Top: Integer;
begin
    Top:= FTitleRowHeight;
    i:= TopRow;
    while i < RowCount do begin
      if (ClientHeight <= Top + RowHeights[i]) then Break;
      Top:= Top + RowHeights[i];
      inc(i);
    end;
    Result:= Max(1, i - TopRow);
end;

procedure TKOLmdvXLGrid.UpdateScrollBars;
var ScrollInfo: TScrollInfo;
begin
    ScrollInfo.nMin:= 0;
    ScrollInfo.nMax:= FRowCount-1;
    ScrollInfo.nPos:= TopRow;
    ScrollInfo.nPage:= VisibleRowCount;
    ScrollInfo.fMask:= SIF_ALL;
    ScrollInfo.cbSize:= SizeOf(ScrollInfo);
    SetScrollInfo(Handle, SB_VERT, ScrollInfo, True);

    ScrollInfo.nMin:= 0;
    ScrollInfo.nMax:= FColCount-1;
    ScrollInfo.nPos:= LeftCol;
    ScrollInfo.nPage:= VisibleColCount;
    ScrollInfo.fMask:= SIF_ALL;
    ScrollInfo.cbSize:= SizeOf(ScrollInfo);
    SetScrollInfo(Handle, SB_HORZ, ScrollInfo, True);
end;

procedure TKOLmdvXLGrid.WMHScroll(var Message: TWMHScroll);
begin
    inherited;
    case Message.ScrollCode of
      SB_LEFT: LeftCol:= 0;
      SB_RIGHT: LeftCol:= FColCount-VisibleColCount;
      SB_LINELEFT: LeftCol:= Max(0,  LeftCol-1);
      SB_LINERIGHT: LeftCol:= Min(FColCount-VisibleColCount,  LeftCol+1);
      SB_PAGELEFT: LeftCol:= Max(0,  LeftCol-VisibleColCount+1);
      SB_PAGERIGHT: LeftCol:= Min(FColCount-VisibleColCount,  LeftCol+VisibleColCount-1);
      SB_THUMBPOSITION: LeftCol:= Min(FColCount-VisibleColCount,  Max(0,  Message.Pos));
      SB_THUMBTRACK: LeftCol:= Min(FColCount-VisibleColCount,  Max(0,  Message.Pos));
    end;
    invalidate;
    UpdateScrollBars;
end;

procedure TKOLmdvXLGrid.WMVScroll(var Message: TWMVScroll);
begin
    inherited;
    case Message.ScrollCode of
      SB_LEFT: TopRow:= 0;
      SB_RIGHT: TopRow:= FRowCount-VisibleRowCount;
      SB_LINELEFT: TopRow:= Max(0,  TopRow-1);
      SB_LINERIGHT: TopRow:= Min(FRowCount-VisibleRowCount,  TopRow+1);
      SB_PAGELEFT: TopRow:= Max(0,  TopRow-VisibleRowCount+1);
      SB_PAGERIGHT: TopRow:= Min(FRowCount-VisibleRowCount,  TopRow+VisibleRowCount-1);
      SB_THUMBPOSITION: TopRow:= Min(FRowCount-VisibleRowCount,  Max(0,  Message.Pos));
      SB_THUMBTRACK: TopRow:= Min(FRowCount-VisibleRowCount,  Max(0,  Message.Pos));
    end;
    invalidate;
    UpdateScrollBars;
end;

function TKOLmdvXLGrid.GetCells(Col, Row: Integer): TmdvXLCell;
begin
    Result:= TmdvXLCell(TList(FRows[Row])[Col]);
end;

procedure TKOLmdvXLGrid.BeginUpdate;
begin
    inc(FUpdate);
end;

procedure TKOLmdvXLGrid.EndUpdate;
begin
    dec(FUpdate);
    if FUpdate = 0 then Invalidate;
end;

function TKOLmdvXLGrid.GetCoord(Cell: TmdvXLCell): TPoint;
var i, j: Integer;
begin
    Result:= Point(-1, -1);
    for i:= 0 to RowCount - 1 do begin
      j:= TList(FRows[i]).IndexOf(Cell);
      if j <> -1 then begin
        Result:= Point(j, i);
        Break;
      end;
    end;
end;

procedure TKOLmdvXLGrid.SetColor(const Value: TColor);
begin
    BeginUpdate;
    inherited Color:= Value;
    EndUpdate;
end;

function TKOLmdvXLGrid.GetFont: TKOLFont;
begin
    Result:= inherited Font;
end;

procedure TKOLmdvXLGrid.SetFont(const Value: TKOLFont);
begin
    inherited Font.Assign(Value);
end;

procedure TKOLmdvXLGrid.SetLineColor(const Value: TColor);
var i, j: Integer;
begin
    BeginUpdate;
    FLineColor:= Value;
    for i:= 0 to ColCount-1 do
      for j:= 0 to RowCount-1 do begin
        Cells[i,j].FLineLeft.Color:= Value;
        Cells[i,j].FLineRight.Color:= Value;
        Cells[i,j].FLineTop.Color:= Value;
        Cells[i,j].FLineBottom.Color:= Value;
      end;
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.SetLineWidthBottom(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    FLineWidth.Bottom := Value;
    for i:= 0 to ColCount-1 do
      for j:= 0 to RowCount-1 do Cells[i,j].FLineBottom.Width:= Value;
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.SetLineWidthLeft(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    FLineWidth.Left := Value;
    for i:= 0 to ColCount-1 do
      for j:= 0 to RowCount-1 do Cells[i,j].FLineLeft.Width:= Value;
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.SetLineWidthRight(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    FLineWidth.Right := Value;
    for i:= 0 to ColCount-1 do
      for j:= 0 to RowCount-1 do Cells[i,j].FLineRight.Width:= Value;
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.SetLineWidthTop(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    FLineWidth.Top := Value;
    for i:= 0 to ColCount-1 do
      for j:= 0 to RowCount-1 do Cells[i,j].FLineTop.Width:= Value;
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.SetTitleFont(const Value: TKOLFont);
begin
    if FTitleFont.Equal2( Value ) then Exit;
    BeginUpdate;
    FTitleFont.Assign(Value);
    EndUpdate;
end;

procedure TKOLmdvXLGrid.SetTitleColor(const Value: TColor);
begin
    BeginUpdate;
    FTitleColor := Value;
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.SetIndentLeft(const Value: Integer);
begin
    FIndent.Left:= Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetIndentBottom(const Value: Integer);
begin
    FIndent.Bottom := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetIndentRight(const Value: Integer);
begin
    FIndent.Right := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetIndentTop(const Value: Integer);
begin
    FIndent.Top := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetAlignmentVert(const Value: TvAlignmentText);
begin
    FAlignmentVert := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetAlignmentHor(const Value: ThAlignmentText);
begin
    FAlignmentHor := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetOptions(const Value: TxlgOptions);
begin
    FOptions := Value;
    Change;
end;

procedure TKOLmdvXLGrid.MoveCol(Index, NewIndex: Integer);
var i: Integer;
begin
    NewIndex:= Max(0, Min(ColCount-1, NewIndex));
    if Index <> NewIndex then begin
      BeginUpdate;
      FTitleCol.Move(Index, NewIndex);
      FColWidths.Move(Index, NewIndex);
      for i:= 0 to FRows.Count-1 do begin
        TList(FRows[i]).Move(Index, NewIndex);
      end;
//      if Assigned(FOnMoved) then FOnMoved(Self, dCol, Index, NewIndex);
      EndUpdate;
    end;
end;

procedure TKOLmdvXLGrid.MoveRow(Index, NewIndex: Integer);
begin
    NewIndex:= Max(0, Min(RowCount-1, NewIndex));
    if Index <> NewIndex then begin
      BeginUpdate;
      FTitleRow.Move(Index, NewIndex);
      FRowHeights.Move(Index, NewIndex);
      FRows.Move(Index, NewIndex);
//      if Assigned(FOnMoved) then FOnMoved(Self, dRow, Index, NewIndex);
      EndUpdate;
    end;
end;

procedure TKOLmdvXLGrid.CMDesignHitTest(var Msg: TCMDesignHitTest);
begin
    Msg.Result:= Longint(BOOL((FResizeCol<>-1)or(FResizeRow<>-1)or(FMovingCol<>-1)or(FMovingRow<>-1)or(FTitleRowHeight >= Msg.Pos.Y)and(FTitleColWidth < Msg.Pos.X) or (FTitleColWidth >= Msg.Pos.X)and(FTitleRowHeight < Msg.Pos.Y)));
end;

procedure TKOLmdvXLGrid.UpdateDesigner;
var ParentForm: TCustomForm;
begin
  if (csDesigning in ComponentState) and HandleAllocated and
    not (csUpdating in ComponentState) then
  begin
    ParentForm := GetParentForm(Self);
    if Assigned(ParentForm) and Assigned(ParentForm.Designer) then
      ParentForm.Designer.Modified;
  end;
end;

procedure TKOLmdvXLGrid.DefineProperties(Filer: TFiler);

  function DoColWidths: Boolean;
  begin
    Result := (Filer.Ancestor <> nil)and(FColWidths <> nil);
  end;

  function DoRowHeights: Boolean;
  begin
    Result := (Filer.Ancestor <> nil) and (FRowHeights <> nil);
  end;


begin
  inherited DefineProperties(Filer);
    with Filer do begin
      DefineProperty('ColWidths', ReadColWidths, WriteColWidths, True);
      DefineProperty('RowHeights', ReadRowHeights, WriteRowHeights, True);
    end;
end;

procedure TKOLmdvXLGrid.ReadColWidths(Reader: TReader);
var I: Integer;
begin
  with Reader do begin
    ReadListBegin;
    for I := 0 to ColCount - 1 do ColWidths[I] := ReadInteger;
    ReadListEnd;
  end;
end;

procedure TKOLmdvXLGrid.ReadRowHeights(Reader: TReader);
var I: Integer;
begin
  with Reader do begin
    ReadListBegin;
    for I := 0 to RowCount - 1 do RowHeights[I] := ReadInteger;
    ReadListEnd;
  end;
end;

procedure TKOLmdvXLGrid.WriteColWidths(Writer: TWriter);
var I: Integer;
begin
  with Writer do begin
    WriteListBegin;
    for I := 0 to ColCount - 1 do WriteInteger(ColWidths[I]);
    WriteListEnd;
  end;
end;

procedure TKOLmdvXLGrid.WriteRowHeights(Writer: TWriter);
var I: Integer;
begin
  with Writer do begin
    WriteListBegin;
    for I := 0 to RowCount - 1 do WriteInteger(RowHeights[I]);
    WriteListEnd;
  end;
end;

procedure TKOLmdvXLGrid.WMNCHitTest(var Message: TMessage);
begin
    DefaultHandler(Message);
end;

procedure TKOLmdvXLGrid.SetTitleSelectedColor(const Value: TColor);
begin
    FTitleSelectedColor := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetTitleSelectedFontColor(const Value: TColor);
begin
    FTitleSelectedFontColor := Value;
    Change;
end;

function TKOLmdvXLGrid.AdditionalUnits: string;
begin
    Result := ', KOLmdvXLGrid';
end;

procedure TKOLmdvXLGrid.SetupConstruct(SL: TStringList; const AName, AParent, Prefix: String);
const hAlignmentText : array [ThAlignmentText] of String = ('ahLeftJustify', 'ahRightJustify', 'ahCenter', 'ahJustify', 'ahFullJustify');
      vAlignmentText : array [TvAlignmentText] of String = ('ahTop', 'ahBottom', 'ahCenter', 'ahJustify');
      BoolArr : array [Boolean] of String = ('False', 'True');
var S, ColsWidths, RowsHeigths, TitleRows, TitleCols: String;
    i, k: Integer;
    Chn: Boolean;
begin
  S := GenerateTransparentInits;
  ColsWidths:= ''; Chn:= False; k:= 0;
  for i:= 0 to ColCount-1 do begin
    if Length(ColsWidths + Int2Str(ColWidths[i]) + ', ')-k*1024 > k*2 then begin
      ColsWidths:= ColsWidths + #13#10 + '      ';
      inc(k);
    end;
    ColsWidths:= ColsWidths + Int2Str(ColWidths[i]) + ', ';
    Chn:= Chn or (ColWidths[i] <> DefaultColWidth);
  end;
  if Chn then begin
    DeleteTail(ColsWidths, 2);
    ColsWidths:= '.SetColsWidths([ ' + ColsWidths +' ])';
  end
  else
    if DefaultColWidth <> DefDefaultColWidth then ColsWidths:= '.SetDefColWidths( ' + Int2Str(DefaultColWidth) +' )'
    else ColsWidths:= '';

  RowsHeigths:= ''; Chn:= False; k:= 0;
  for i:= 0 to RowCount-1 do begin
    if Length(RowsHeigths + Int2Str(RowHeights[i]) + ', ')-k*1024 > k*2 then begin
      RowsHeigths:= RowsHeigths + #13#10 + '      ';
      inc(k);
    end;
    RowsHeigths:= RowsHeigths + Int2Str(RowHeights[i]) + ', ';
    Chn:= Chn or (RowHeights[i] <> DefaultRowHeight);
  end;
  if Chn then begin
    DeleteTail(RowsHeigths, 2);
    RowsHeigths:= '.SetRowsHeights([ ' + RowsHeigths +' ])';
  end
  else
    if DefaultRowHeight <> DefDefaultRowHeight then RowsHeigths:= '.SetDefRowHeights( ' + Int2Str(DefaultRowHeight) +' )'
    else RowsHeigths:= '';

  TitleRows:= ''; Chn:= False; k:= 0;
  for i:= 0 to TitleRow.Count -1 do begin
    if Length(TitleRows + '''' + TitleRow[i] + ''', ')-k*1024 > k*2 then begin
      TitleRows:= TitleRows + #13#10 + '      ';
      inc(k);
    end;
    TitleRows:= TitleRows + '''' + TitleRow[i] + ''', ';
    Chn:= Chn or (TitleRow[i] <> '');
  end;
  if Chn then begin
    DeleteTail(TitleRows, 2);
    TitleRows:= '.SetTitleRow([ ' + TitleRows +' ])';
  end
  else TitleRows:= '';
  TitleCols:= ''; Chn:= False; k:= 0;
  for i:= 0 to TitleCol.Count -1 do begin
    if Length(TitleCols + '''' + TitleCol[i] + ''', ')-k*1024 > k*2 then begin
      TitleCols:= TitleCols + #13#10 + '      ';
      inc(k);
    end;
    TitleCols:= TitleCols + '''' + TitleCol[i] + ''', ';
    Chn:= Chn or (TitleCol[i] <> '');
  end;
  if Chn then begin
    DeleteTail(TitleCols, 2);
    TitleCols:= '.SetTitleCol([ ' + TitleCols + ' ])';
  end
  else TitleCols:= '';

  SL.Add( Prefix + AName + ' := PmdvXLGrid( New' + TypeName + '( '
          + SetupParams( AName, AParent ) + ' )' + S + ')' + ColsWidths + RowsHeigths + TitleRows + TitleCols + ';' );

  if TitleColWidth <> DefTitleColWidth then SL.Add( Prefix + AName + '.TitleColWidth:= ' + Int2Str(TitleColWidth) + ';');
  if TitleRowHeight <> DefTitleRowHeight then SL.Add( Prefix + AName + '.TitleRowHeight:= ' + Int2Str(TitleRowHeight) + ';');
  if TitleColor <> DefTitleColor then SL.Add( Prefix + AName + '.TitleColor:= ' + Int2Str(TitleColor) + ';');
  if TitleSelectedColor <> DefTitleSelectedColor then SL.Add( Prefix + AName + '.TitleSelectedColor:= ' + Int2Str(TitleSelectedColor) + ';');
  if TitleSelectedFontColor <> DefTitleSelectedFontColor then SL.Add( Prefix + AName + '.TitleSelectedFontColor:= ' + Int2Str(TitleSelectedFontColor) + ';');
  if TitleRowButton <> DefTitleRowButton then SL.Add( Prefix + AName + '.TitleRowButton:= ' + BoolArr[TitleRowButton] + ';');
  if TitleColButton <> DefTitleColButton then SL.Add( Prefix + AName + '.TitleColButton:= ' + BoolArr[TitleColButton] + ';');
  if SelectedColor <> DefSelectedColor then SL.Add( Prefix + AName + '.SelectedColor:= ' + Int2Str(SelectedColor) + ';');
  if SelectedColorLine <> DefSelectedColorLine then SL.Add( Prefix + AName + '.SelectedColorLine:= ' + Int2Str(SelectedColorLine) + ';');
  if SelectedFontColor <> DefSelectedFontColor then SL.Add( Prefix + AName + '.SelectedFontColor:= ' + Int2Str(SelectedFontColor) + ';');
  if ResizeSensitivity <> DefResizeSensitivity then SL.Add( Prefix + AName + '.ResizeSensitivity:= ' + Int2Str(ResizeSensitivity) + ';');

  if LineColor <> DefLineColor then SL.Add( Prefix + AName + '.LineColor:= ' + Int2Str(LineColor) + ';');
  if LineWidthLeft <> DefLineWidthLeft then SL.Add( Prefix + AName + '.LineWidthLeft:= ' + Int2Str(LineWidthLeft) + ';');
  if LineWidthRight <> DefLineWidthRight then SL.Add( Prefix + AName + '.LineWidthRight:= ' + Int2Str(LineWidthRight) + ';');
  if LineWidthTop <> DefLineWidthTop then SL.Add( Prefix + AName + '.LineWidthTop:= ' + Int2Str(LineWidthTop) + ';');
  if LineWidthBottom <> DefLineWidthBottom then SL.Add( Prefix + AName + '.LineWidthBottom:= ' + Int2Str(LineWidthBottom) + ';');
  if IndentLeft <> DefIndentLeft then SL.Add( Prefix + AName + '.IndentLeft:= ' + Int2Str(IndentLeft) + ';');
  if IndentRight <> DefIndentRight then SL.Add( Prefix + AName + '.IndentRight:= ' + Int2Str(IndentRight) + ';');
  if IndentTop <> DefIndentTop then SL.Add( Prefix + AName + '.IndentTop:= ' + Int2Str(IndentTop) + ';');
  if IndentBottom <> DefIndentBottom then SL.Add( Prefix + AName + '.IndentBottom:= ' + Int2Str(IndentBottom) + ';');
  if AlignmentHor <> DefAlignmentHor then SL.Add( Prefix + AName + '.AlignmentHor:= ' + hAlignmentText[AlignmentHor] + ';');
  if AlignmentVert <> DefAlignmentVert then SL.Add( Prefix + AName + '.AlignmentVert:= ' + vAlignmentText[AlignmentVert] + ';');
  if not FDefEditorEvents then SL.Add( Prefix + AName + '.DefEditorEvents:= ' + BoolArr[FDefEditorEvents] + ';');
end;

function TKOLmdvXLGrid.SetupParams(const AName, AParent: String): String;
var S, SS: String;
begin
    S:= '';
    if xlgRangeSelect in Options then S:= S + ', xlgRangeSelect';
    if xlgColsSelect in Options then S:= S + ', xlgColsSelect';
    if xlgRowsSelect in Options then S:= S + ', xlgRowsSelect';
    if xlgRowSizing in Options then S:= S + ', xlgRowSizing';
    if xlgColSizing in Options then S:= S + ', xlgColSizing';
    if xlgRowMoving in Options then S:= S + ', xlgRowMoving';
    if xlgColMoving in Options then S:= S + ', xlgColMoving';
    Delete(S, 1, 2); S:= '[ ' + S + ' ]';
    if GridStyle = gsStandard then SS:= 'gsStandard' else SS:= 'gsXL';
    Result := AParent + ', ' + Int2Str(FColCount) + ', ' + Int2Str(FRowCount) + ', ' + SS + ', '+S;
end;

function TKOLmdvXLGrid.GetColor: TColor;
begin
    Result:= inherited Color;
end;

function TKOLmdvXLGrid.DefaultColor: TColor;
begin
    Result:= DefColor;
end;

function TKOLmdvXLGrid.DefaultKOLParentColor: Boolean;
begin
    Result:= False;
end;

procedure TKOLmdvXLGrid.SetHasBorder(const Value: Boolean);
begin
    inherited SetHasBorder(Value);
    RecreateWnd;
end;

procedure TKOLmdvXLGrid.KolFont2Font(AKOLFont: TKOLFont; AFont: TFont);
begin
    AFont.Color := AKOLFont.Color;
    AFont.Style := AKOLFont.FontStyle;
    AFont.Height := AKOLFont.FontHeight;
    AFont.Name := AKOLFont.FontName;
    AFont.Charset := AKOLFont.FontCharset;
    AFont.Pitch := AKOLFont.FontPitch;
end;

function TKOLmdvXLGrid.MouseToColBorder(X: Integer): Integer;
var i, Left: Integer;
begin
    Result:= -1;
    Left:= FTitleColWidth;
    for i:= LeftCol to ColCount-1 do begin
      if (X = Left + ColWidths[i]) then begin
        Result:= i;
        Break;
      end;
      Left:= Left + ColWidths[i];
    end;
end;

function TKOLmdvXLGrid.MouseToRowBorder(Y: Integer): Integer;
var i, Top: Integer;
begin
    Result:= -1;
    Top:= FTitleRowHeight;
    for i:= TopRow to RowCount-1 do begin
      if (Y = Top+RowHeights[i]) then begin
        Result:= i;
        Break;
      end;
      Top:= Top + RowHeights[i];
    end;
end;

function ReplaceStrToStr(Source: string; SourceSubStr, DestSubStr : String): String;
var I: Integer;
begin
    Result:= ''; I:= Pos(SourceSubStr, Source);
    while I<>0 do begin
      Result:= Result + Copy(Source, 1, I-1) + DestSubStr;
      Delete(Source, 1, I-1 + Length(SourceSubStr));
      I:= Pos(SourceSubStr, Source);
    end;
    Result:= Result + Source;
end;
procedure TKOLmdvXLGrid.SetupFont(SL: TStrings; const AName: String);
begin
    inherited SetupFont(SL, AName);
    if not TitleFont.Equal2(Get_ParentFont) then begin
      TitleFont.GenerateCode( SL, AName+'.TitleFont', Get_ParentFont);
      SL.Text:= ReplaceStrToStr(SL.Text, '.TitleFont.Font.', '.TitleFont.');
    end;
end;

procedure TKOLmdvXLGrid.SetGridStyle(const Value: TmdvGridStyle);
begin
    BeginUpdate;
    FGridStyle := Value;
    EndUpdate;
    Change;
end;

procedure TKOLmdvXLGrid.AssignEvents(SL: TStringList; const AName: String);
begin
    inherited;
    DoAssignEvents(SL, AName, ['OnSized'], [@OnSized]);
    DoAssignEvents(SL, AName, ['OnFocusChange'], [@OnFocusChange]);
    DoAssignEvents(SL, AName, ['OnMoved'], [@OnMoved]);
    DoAssignEvents(SL, AName, ['OnBeginEdit'], [@OnBeginEdit]);
    DoAssignEvents(SL, AName, ['OnEndEdit'], [@OnEndEdit]);
    DoAssignEvents(SL, AName, ['OnSelectedChange'], [@OnSelectedChange]);
    DoAssignEvents(SL, AName, ['OnButtonDown'], [@OnButtonDown]);
    DoAssignEvents(SL, AName, ['OnDrawCell'], [@OnDrawCell]);
    DoAssignEvents(SL, AName, ['OnDrawTitle'], [@OnDrawTitle]);
    Change;
end;

procedure TKOLmdvXLGrid.SetTitleColButton(const Value: Boolean);
begin
    FTitleColButton := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetTitleRowButton(const Value: Boolean);
begin
    FTitleRowButton := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetSelectedColor(const Value: TColor);
begin
    FSelectedColor := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetSelectedFontColor(const Value: TColor);
begin
    FSelectedFontColor := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetSelectedColorLine(const Value: TColor);
begin
    FSelectedColorLine := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetResizeSensitivity(const Value: Byte);
begin
    FResizeSensitivity := Value;
    Change;
end;

procedure TKOLmdvXLGrid.SetDefEditorEvents(const Value: Boolean);
begin
    FDefEditorEvents := Value;
    Change;
end;

{ TmdvXLCell }

constructor TmdvXLCell.Create(AGrid: TKOLmdvXLGrid);
begin
    Grid:= AGrid;
    New(FLineLeft);
    New(FLineTop);
    New(FLineBottom);
    New(FLineRight);

    FLineLeft.Color:= AGrid.LineColor;
    FLineRight.Color:= AGrid.LineColor;
    FLineTop.Color:= AGrid.LineColor;
    FLineBottom.Color:= AGrid.LineColor;
    FLineLeft.Width:= AGrid.LineWidthLeft;
    FLineRight.Width:= AGrid.LineWidthRight;
    FLineTop.Width:= AGrid.LineWidthTop;
    FLineBottom.Width:= AGrid.LineWidthBottom;

end;

destructor TmdvXLCell.Destroy;
begin
    Dispose(FLineLeft);
    Dispose(FLineTop);
    Dispose(FLineBottom);
    Dispose(FLineRight);

    inherited Destroy;
end;

function TmdvXLCell.GetLineAttr(ARect: TRect; LineDirect: TXLCellLineDirect; Coord: TPoint): TXLCellLineAttr;
var WidthLine: Integer;
    W: Integer;
begin
    case LineDirect of
       ldLeft: begin
          if Coord.x = 0 then WidthLine:= FLineLeft.Width
          else WidthLine:= Max(FLineLeft.Width, Grid.Cells[Coord.x-1, Coord.y].FLineRight.Width);
          Result.Drawing:= WidthLine>0;
          if not Result.Drawing then Exit;

          WidthLine:= WidthLine;
          if Coord.x = 0 then W:= Max(1, Round(WidthLine)) else W:= Max(1, Round(WidthLine/2));
          Result.Space:= ARect; Result.Space.Right:= Result.Space.Left + W;
          Result.Color:= FLineLeft.Color;
       end;
       ldRight: begin
          if Coord.x = Grid.ColCount-1 then WidthLine:= FLineRight.Width
          else WidthLine:= Max(FLineRight.Width, Grid.Cells[Coord.x + 1, Coord.y].FLineLeft.Width);
          Result.Drawing:= WidthLine>0;
          if not Result.Drawing then Exit;

          Result.Color:= FLineRight.Color;
          WidthLine:= WidthLine;
          if Coord.x = Grid.ColCount-1 then W:= Max(1, Round(WidthLine)) else begin
            WidthLine:= WidthLine - Max(1, Round(WidthLine/2));
            Result.Drawing:= WidthLine>0;
            if not Result.Drawing then Exit;
            if WidthLine>=1 then W:= Round(WidthLine)
            else begin
              W:= 1; Result.Color:= clGray;
            end;
          end;
          Result.Space:= ARect; Result.Space.Left:= Result.Space.Right - W;
       end;
       ldTop: begin
          if Coord.y = 0 then WidthLine:= FLineTop.Width
          else WidthLine:= Max(FLineTop.Width, Grid.Cells[Coord.x, Coord.y-1].FLineBottom.Width);
          Result.Drawing:= WidthLine>0;
          if not Result.Drawing then Exit;

          WidthLine:= WidthLine;
          if Coord.y = 0 then W:= Max(1, Round(WidthLine)) else W:= Max(1, Round(WidthLine/2));
          Result.Space:= ARect; Result.Space.Bottom:= Result.Space.Top + W;
          Result.Color:= FLineTop.Color;
       end;
       ldBottom: begin
          if Coord.y = Grid.RowCount-1 then WidthLine:= FLineBottom.Width
          else WidthLine:= Max(FLineBottom.Width, Grid.Cells[Coord.x, Coord.y+1].FLineTop.Width);
          Result.Drawing:= WidthLine>0;
          if not Result.Drawing then Exit;

          Result.Color:= FLineBottom.Color;
          WidthLine:= WidthLine;
          if Coord.y = Grid.RowCount-1 then W:= Max(1, Round(WidthLine)) else begin
            WidthLine:= WidthLine - Max(1, Round(WidthLine/2));
            Result.Drawing:= WidthLine>0;
            if not Result.Drawing then Exit;
            if WidthLine>=1 then W:= Round(WidthLine)
            else begin
              W:= 1; Result.Color:= clGray;
            end;
          end;
          Result.Space:= ARect; Result.Space.Top:= Result.Space.Bottom - W;
       end;
    end;
end;

procedure TmdvXLCell.Draw(ARect: TRect; Canvas: TCanvas);
const hAlign : array[ThAlignmentText] of Integer = (DT_LEFT, DT_RIGHT, DT_CENTER, DT_LEFT, DT_LEFT);
const vAlign : array[TvAlignmentText] of Integer = (DT_TOP, DT_BOTTOM, DT_VCENTER, DT_TOP);
var Rect: TRect;
    LineAttr: TXLCellLineAttr;
    P: TPoint;
begin
    Rect:= ARect;
    Canvas.Brush.Style:= bsSolid;
    P:= Grid.GetCoord(Self);
    LineAttr:= GetLineAttr(ARect, ldLeft, P);
    if LineAttr.Drawing then begin
      Canvas.Brush.Color:= LineAttr.Color;
      Canvas.FillRect(LineAttr.Space);
      Rect.Left:= LineAttr.Space.Right;
    end;
    LineAttr:= GetLineAttr(ARect, ldRight, P);
    if LineAttr.Drawing then begin
      Canvas.Brush.Color:= LineAttr.Color;
      Canvas.FillRect(LineAttr.Space);
      Rect.Right:= LineAttr.Space.Left;
    end;
    LineAttr:= GetLineAttr(ARect, ldTop, P);
    if LineAttr.Drawing then begin
      Canvas.Brush.Color:= LineAttr.Color;
      Canvas.FillRect(LineAttr.Space);
      Rect.Top:= LineAttr.Space.Bottom;
    end;
    LineAttr:= GetLineAttr(ARect, ldBottom, P);
    if LineAttr.Drawing then begin
      Canvas.Brush.Color:= LineAttr.Color;
      Canvas.FillRect(LineAttr.Space);
      Rect.Bottom:= LineAttr.Space.Top;
    end;
end;

end.
