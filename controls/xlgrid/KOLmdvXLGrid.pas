{**********************************************************************}
//Для отключения поддержки ненужных возможностей
//(в целях уменьшения размера выходного файла)
//закомментируйте сответствующие строки с $DEFINE
{$DEFINE ColMoving}      // Возможность перемещения колонок
{$DEFINE RowMoving}      // Возможность перемещения строк
{$DEFINE ColSizing}      // Возможность изменения размеров колонок
{$DEFINE RowSizing}      // Возможность изменения размеров строк
{$DEFINE ColsSelect}     // Возможность выделения колонок
{$DEFINE RowsSelect}     // Возможность выделения строк
{$DEFINE ColButton}      // Поддержка кнопок в левом заголовке
{$DEFINE RowButton}      // Поддержка кнопок в верхнем заголовке
{**********************************************************************}

{$IFDEF ColMoving} {$DEFINE Moving} {$ENDIF}
{$IFDEF RowMoving} {$DEFINE Moving} {$ENDIF}
{$IFDEF ColSizing} {$DEFINE Sizing} {$ENDIF}
{$IFDEF RowSizing} {$DEFINE Sizing} {$ENDIF}
{$IFDEF ColsSelect} {$DEFINE Select} {$ENDIF}
{$IFDEF RowsSelect} {$DEFINE Select} {$ENDIF}


unit KOLmdvXLGrid;
// Компонент mdvXLGrid - Компонент для вывода информации в таблице (сетке).
// E-Mail: dominiko-m@yandex.ru
// Автор: Матвеев Дмитрий

// - История -

// Дата: 09.12.2003 Версия: 1.11
   {
   [+] - добавлено свойство DefEditorEvents.
   }

// Дата: 22.10.2003 Версия: 1.10
   {
   [!] - исправлена ошибка, разрушения Grid'a при активном редакторе (спасибо <Falcon>).
   }

// Дата: 21.10.2003 Версия: 1.09
   {
   [!] - исправлена установка текста ячейки при выходе из режима редактирования (спасибо Дмитрий aka Dimaxx).
   [*] - добавлены свойства для ячеек (по просьбе <Falcon>).
   }

// Дата: 07.10.2003 Версия: 1.08
   {
   [!] - исправлена обработка курсора в соответствии с версией KOL 1.85.
   }

// Дата: 30.07.2003 Версия: 1.07
   {
   [*] - методы BeginEdit и EndEdit перенесены из секции protected в public.
   [!] - исправлена ошибка поведения редактора при скролинге.
   }

// Дата: 24.07.2003 Версия: 1.06
   {
   [+] - Добавлено свойство ResizeSensitivity - установка чувствительности мыши при
         изменении размеров колонок
   }

// Дата: 15.05.2003 Версия: 1.05
   {
   [!] - найдена и исправлена куча утечек ресурсов.
   }

// Дата: 12.03.2003 Версия: 1.04
   {
   [!] - Исправлено зеркало в соответствии с версией MCK 1.70
   }

// Дата: 14.01.2003 Версия: 1.03
   {
   [+] - Добавлено событие OnDrawTitle - пользовательская отрисовка заголовка
   [*] - изменена обработка полос прокрутки
   }

// Дата: 9.12.2002 Версия: 1.02
   {
   [!] - Исправлены ошибки при отрисовке
   [!] - Исправлены ошибки инициализации (надеюсь) /спасибо Yuri Gusev/
   [+] - Добавлена возможность условной компиляции (для отключения не нужных возможностей - уменьшение ЕХЕ)
   }


// Дата: 29.11.2002 Версия: 1.01
   {
   [!] - Исправлена ошибка при работе с ImageList (проявлялась при вызове NewFont и NewList)
   [+] - Добавлено событие OnDrawCell
   }

// Дата: 5.11.2002 Версия: 1.00
   {
   Исправлена ошибка при изменениии количества строк и столбцов.
   Исправлена ошибка обработки нажатия кнопок в заголовке.
   Исправлена ошибка отрисовки фокуса.
   Добавлено:
   property OnChange - при изменении содержимого ячеек;
   property Data - произвольные данные "прицепляемые к ячейке";
   Удалено:
   property TitleAutoFill - кому нужно сам заполнит :)
   }

// Дата: 14.10.2002 Версия: 1.00b
   {Стартовая версия}

{
  Описание ключевых свойств
    property Options:
        xlgRangeSelect - выделение диапазона ячеек
        xlgColsSelect - выделение колонок
        xlgRowsSelect - выделение строк
        xlgColSizing - изменение размеров колонок
        xlgRowSizing - изменение размеров строк
        xlgColMoving - перемещение колонок
        xlgRowMoving - перемещение строк

    property GridStyle - (gsXL, gsStandard);

    property ColCount - количество колонок;
    property RowCount - количество строк;
    property DefaultColWidth - ширина колонок по умолчанию;
    property DefaultRowHeight - высота строк по умолчанию;
    property ColWidths[Index: Integer] - ширины колонок;
    property RowHeights[Index: Integer] - высоты строк;
    property TopRow - верхняя видимая строка;
    property LeftCol - левая видимая колонка;
    property VisibleColCount - количество видимых колонок;
    property VisibleRowCount - количество видимых строк;

    property SelectedCols[Index: Integer] - список выделенных колонок;
    property SelectedRows[Index: Integer] - список выделенных строк;
    property Selected - выделенный прямоугольник (не цветом, а в рамкой);
    property Position - позиция курсора (фокус);
    property IsCellSelected - возвращает, выделена ли ячейка;
    property SelectedColor - цвет выделения;
    property SelectedFontColor - цвет фонтa выделения;

    property TitleRowHeight - высота строки заголовка;
    property TitleColWidth - ширина столбца заголовка;
    property TitleRows[Index: Integer] - заголовки колонок;
    property TitleCols[Index: Integer] - заголовки строк;
    property TitleFont - шрифт заголовка;
    property TitleColor - цвет заголовка;
    property TitleSelectedColor - цвет выделения заголовка;
    property TitleSelectedFontColor - цвет шрифта выделения заголовка;

    property TitleRowButton - признак кнопок в строке заголовка;
    property TitleColButton - признак кнопок в столбце заголовка;

    Все свойства относящиеся к яцейкам можно задавать как для всех сразу, так и для отдельных ячеек
    property Cells[Col, Row: Integer] - доступ к ячейкам сетки;
    property Color - цвет ячеек;
    property Font - шрифт ячеек;

    property LineColor - цвет линий ячеек;
    property LineWidthLeft - толщина левой линии ячеек;
    property LineWidthRight - толщина правой линии ячеек;
    property LineWidthTop - толщина верхней линии ячеек;
    property LineWidthBottom - толщина нижней линии ячеек;

    property IndentLeft - левый отступ текста ячеек;
    property IndentRight - правый отступ текста ячеек;
    property IndentTop - верхний отступ текста ячеек;
    property IndentBottom - нижний отступ текста ячеек;
    property AlignmentHor - горизонтальное выравнивание текста ячеек;
    property AlignmentVert - вертикальное выравнивание текста ячеек;

    property Data - произвольные данные "прицепляемые к ячейке";

    property ScrollBars - включает\выключает горизонтальные и вертикальные полосы прокрутки.

    property OnSized - изменение размеров колонок и строк;
    property OnFocusChange - изменение активной ячейки;
    property OnSelectedChange - изменение выделения;
    property OnMoved - перемещение колонок и строк;
    property OnBeginEdit - начало редактирования;
    property OnEndEdit - окончание редактирования;

    Как таковой редактор в Grid-компоненте отсутствует (в VCL -
    InplaceEditor). Т.к сетка, все таки  предназначена для отображения
    данных, а редакторование - это функционально.

    Для поддержки возможности редактирования есть два свойства.

    OnBeginEdit - возникает при возникновении возможности редактирования (Enter, F2, Двойном щелчке на ячейке). Переход в режим редактирования по одному щелчку (как в Grid'e VCL) - нет, мне это там не нравилось. Хотя если есть настоятельное мнение, что это нужно, можно и сделать. :))
    TOnBeginEdit = procedure (Sender: PControl; ACol, ARow: Integer; var AShowControl, ATextControl: PControl; var AIndents: TRect) of object;

    Sender: PControl - Сам контрол, т.е Grid.

    ACol, ARow: Integer; - соответственно координаты сфокусированной   ячейки.

    var AShowControl: PControl - здель нужно передать указатель на контрол
    (PControl), который будет использоваться как редактор. Например
    Edit или Panel, при этом на ней можно разместить любые элементы.
    Если nil(он там изначально) - то соответственно редактор  вызываться не будет.

    var ATextControl: PControl; - Элемент, который будет иметь фокус
    просле активизации редактора (AShowControl). Имеет смысл если на
    AShowControl лежит несколько контролов. может быть nil, тогда фокус
    получит AShowControl.
    var AIndents: TRect - Отступы с которыми будет позиционироваться
    AShowControl относительно ячейки. Полезно для выравнивания текста в
    Grid'e и в редакторе, ну или еще зачем нибудь - вариантов много.

    Элементы редактирования (AShowControl) не должны использоваться для
    других целей, т.к. они автоматически будут скрываться по окончанию
    редактирования.

    OnEndEdit - возникает при окончании редактирования. (нажатии Enter, F2, потере фокуса)
    TOnEndEdit = procedure (Sender: PControl; ACol, ARow: Integer; AShowControl, ATextControl: PControl; var AText: String; var Access: Boolean) of object;

    Sender: PControl;         Тоже что и в OnBeginEdit
    ACol, ARow: Integer;
    AShowControl, ATextControl: PControl;

    var AText: String;  - Текст который будет установлен в ячейке(по
    умолчанию текст из FTextEditor)
    var Access: Boolean - При False выход из редактора не произойдет.

    Обрабатывать OnEndEdit не обязательно, т.к в ячейке текст
    установится автоматом из FTextEditor.

    Грид должен создаваться после контролов, используемых для
    редактирования (TabOrder грида > TabOrder контролов).
    Или перед разрушением формы нужно вызвать EndEdit.

    property OnButtonDown - нажатие на кнопку в заголовке;
    property OnChange - при изменении содержимого ячеек;
    property OnDrawCell - пользовательская отрисовка ячеек;
    property OnDrawTitle - пользовательская отрисовка заголовка (начало координат -1, -1);

    procedure Merge - объединение ячеек;
    procedure Split - разъединение ячеек;
    property DefEditorEvents - обработка событий редактора осуществляется Grid'ом
}
interface
{$I KOLDEF.INC}
{$IFDEF _D7orHigher}
  {$WARN UNSAFE_TYPE OFF} // Too many such warnings in Delphi7
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses Windows, Messages, KOL, KolDragImageList;

type
  PmdvXLCell = ^TmdvXLCell;

  TDrawState = (dsDeadDown, dsButtonDown);
  TDrawStates = Set of TDrawState;
  TDirect = (dCol, dRow);
  TOnSized = procedure (Sender: PControl; Direct: TDirect; Index, Value: Integer) of object;
  TOnMoved = procedure (Sender: PControl; Direct: TDirect; Index, NewIndex: Integer) of object;
  TOnFocusChange = procedure (Sender: PControl; ACol, ARow: Integer) of object;
  TOnSelectedChange = procedure (Sender: PControl; ARect: TRect) of object;
  TOnBeginEdit = procedure (Sender: PControl; ACol, ARow: Integer; var AShowControl, ATextControl: PControl; var AIndents: TRect) of object;
  TOnEndEdit = procedure (Sender: PControl; ACol, ARow: Integer; AShowControl, ATextControl: PControl; var AText: String; var Access: Boolean) of object;
  TOnButtonDown = procedure (Sender: PControl; Direct: TDirect; Index: Integer) of object;
  TOnDrawCell = procedure (Sender: PControl; ACol, ARow: Integer; ACell: PmdvXLCell; ACanvas: PCanvas; ARect: TRect; ASelected, AFocused: Boolean; var Access: Boolean) of object;

  ThAlignmentText = (ahLeftJustify, ahRightJustify, ahCenter, ahJustify, ahFullJustify);
  TvAlignmentText = (avTop, avBottom, avCenter, avJustify);

  TxlgOption = (xlgRangeSelect, xlgColsSelect, xlgRowsSelect, xlgColSizing, xlgRowSizing, xlgColMoving, xlgRowMoving);
  TxlgOptions = Set of TxlgOption;

  TmdvGridStyle = (gsXL, gsStandard);

  PmdvXLGrid = ^TmdvXLGrid;
  TKOLmdvXLGrid = PmdvXLGrid;
  TmdvXLGrid = object(TControl)
  private
    procedure Paint(DC: HDC);
    procedure GraphicChange(Sender: PGraphicTool);
    procedure InitCustomData;

    function  GetCountRow(ALeft, ARight, ARow: Integer): TPoint;
    function  GetCountCol(ATop, ABottom, ACol: Integer): TPoint;

    procedure SetRowCount(const Value: Word);
    procedure SetColCount(const Value: Word);
    procedure SetDefaultColWidth(const Value: Integer);
    procedure SetDefaultRowHeight(const Value: Integer);
    procedure SetRowHeights(Index: Integer; const Value: Integer);
    procedure SetColWidths(Index: Integer; const Value: Integer);
    procedure SetTopRow(const Value: Integer);
    procedure SetLeftCol(const Value: Integer);
    procedure SetColor(const Value: TColor);
    procedure SetOptions(const Value: TxlgOptions);

    procedure SetSelectedCols(Index: Integer; const Value: Boolean);
    procedure SetSelectedRows(Index: Integer; const Value: Boolean);
    procedure SetSelected(Value: TRect);
    procedure SetPos(const Value: TPoint);

    procedure SetLineColor(const Value: TColor);
    procedure SetLineWidthBottom(const Value: Integer);
    procedure SetLineWidthLeft(const Value: Integer);
    procedure SetLineWidthRight(const Value: Integer);
    procedure SetLineWidthTop(const Value: Integer);

    procedure SetSelectedColor(const Value: TColor);
    procedure SetGridStyle(const Value: TmdvGridStyle);

    procedure SetTitleColWidth(const Value: Integer);
    procedure SetTitleRowHeight(const Value: Integer);
    procedure SetTitleCols(Index: Integer; const Value: String);
    procedure SetTitleRows(Index: Integer; const Value: String);
    procedure SetTitleColor(const Value: TColor);
    procedure SetTitleSelectedColor(const Value: TColor);
    procedure SetTitleSelectedFontColor(const Value: TColor);

    procedure SetIndentBottom(const Value: Integer);
    procedure SetIndentLeft(const Value: Integer);
    procedure SetIndentRight(const Value: Integer);
    procedure SetIndentTop(const Value: Integer);
    procedure SetAlignmentHor(const Value: ThAlignmentText);
    procedure SetAlignmentVert(const Value: TvAlignmentText);

    procedure SetOnBeginEdit(const Value: TOnBeginEdit);
    procedure SetOnFocusChange(const Value: TOnFocusChange);
    procedure SetOnSized(const Value: TOnSized);
    procedure SetOnMoved(const Value: TOnMoved);

    function GetRowCount: Word;
    function GetColCount: Word;
    function GetDefaultColWidth: Integer;
    function GetDefaultRowHeight: Integer;
    function GetColWidths(Index: Integer): Integer;
    function GetRowHeights(Index: Integer): Integer;
    function GetLeftCol: Integer;
    function GetTopRow: Integer;
    function GetColor: TColor;
    function GetOptions: TxlgOptions;
    function GetCells(Col, Row: Integer): PmdvXLCell;
    function GetVisibleColCount: Integer;
    function GetVisibleRowCount: Integer;

    function GetSelectedCols(Index: Integer): Boolean;
    function GetSelectedRows(Index: Integer): Boolean;
    function GetSelected: TRect;
    function GetPosition: TPoint;

    function GetLineColor: TColor;
    function GetLineWidthLeft: Integer;
    function GetLineWidthRight: Integer;
    function GetLineWidthTop: Integer;
    function GetLineWidthBottom: Integer;

    function GetTitleColWidth: Integer;
    function GetTitleRowHeight: Integer;
    function GetTitleFont: PGraphicTool;
    function GetTitleColor: TColor;
    function GetTitleSelectedColor: TColor;
    function GetTitleSelectedFontColor: TColor;
    function GetTitleCols(Index: Integer): String;
    function GetTitleRows(Index: Integer): String;

    function GetIndentBottom: Integer;
    function GetIndentRight: Integer;
    function GetIndentTop: Integer;
    function GetIndentLeft: Integer;
    function GetAlignmentHor: ThAlignmentText;
    function GetAlignmentVert: TvAlignmentText;

    {$IFDEF Sizing} function GetResizeSensitivity: Byte;
    procedure SetResizeSensitivity(const Value: Byte); {$ENDIF}

    function GetSelectedColor: TColor;
    function GetGridStyle: TmdvGridStyle;

    function GetOnBeginEdit: TOnBeginEdit;
    function GetOnFocusChange: TOnFocusChange;
    function GetOnMoved: TOnMoved;
    function GetOnSized: TOnSized;

    {$IFDEF Sizing} procedure ChangeCursor(Cur: Integer); {$ENDIF}
    {$IFDEF Sizing} procedure RestoreCursor; {$ENDIF}
    function GetIsCellSelected(Col, Row: Integer): Boolean;

    function GetTitleColButton: Boolean;
    function GetTitleRowButton: Boolean;
    procedure SetTitleColButton(const Value: Boolean);
    procedure SetTitleRowButton(const Value: Boolean);
    function GetOnSelectedChange: TOnSelectedChange;
    procedure SetOnSelectedChange(const Value: TOnSelectedChange);
    function GetSelectedFontColor: TColor;
    procedure SetSelectedFontColor(const Value: TColor);
    function GetOnButtonDown: TOnButtonDown;
    procedure SetOnButtonDown(const Value: TOnButtonDown);
    function GetOnEndEdit: TOnEndEdit;
    procedure SetOnEndEdit(const Value: TOnEndEdit);
    function GetSelectedColorLine: TColor;
    procedure SetSelectedColorLine(const Value: TColor);
    function GetOnDrawCell: TOnDrawCell;
    procedure SetOnDrawCell(const Value: TOnDrawCell);
    function GetOnDrawTitle: TOnDrawCell;
    procedure SetOnDrawTitle(const Value: TOnDrawCell);
    function GetDefEditorEvents: Boolean;
    procedure SetDefEditorEvents(const Value: Boolean);

  protected
    procedure UpdateScrollBars;

    procedure OnEditorExit(ASender: PObj);
    procedure OnEditorKeyDown(ASender: PControl; var AKey: Longint; AShift: DWORD);

  public

    procedure  BeginEdit;
    function EndEdit(ASave: Boolean; AEndEdit: Boolean = False): Boolean;

    procedure BeginUpdate;
    procedure EndUpdate;

    function SetColsWidths(Values: array of Integer): PmdvXLGrid;
    function SetRowsHeights(Values: array of Integer): PmdvXLGrid;
    function SetDefRowHeights(ARowWidths: Integer): PmdvXLGrid;
    function SetDefColWidths(AColWidths: Integer): PmdvXLGrid;
    function SetTitleRow(Values: array of String): PmdvXLGrid;
    function SetTitleCol(Values: array of String): PmdvXLGrid;

    procedure ShowPosX(X: Integer);
    procedure ShowPosY(Y: Integer);

    procedure SetSelectedAll(Value: Boolean);

    function MouseToCell(X, Y: Integer): TPoint;
    function MouseToRow(Y: Integer): Integer;
    function MouseToCol(X: Integer): Integer;
    function MouseToRowBorder(Y: Integer): Integer;
    function MouseToColBorder(X: Integer): Integer;

    function CellToRect(ACol, ARow: Integer): TRect;
    function GetCoord(Cell: PmdvXLCell): TPoint;

    procedure MoveCol(Index, NewIndex: Integer);
    procedure MoveRow(Index, NewIndex: Integer);
    procedure DeleteCol(Index: Integer);
    procedure DeleteRow(Index: Integer);

    procedure Merge(ARect: TRect);
    procedure Split(APos: TPoint);
    function HasMerge(ARect: TRect): Boolean;
    function IsMerge(APos: TPoint): Boolean;

    property ColCount: Word read GetColCount write SetColCount;
    property RowCount: Word read GetRowCount write SetRowCount;
    property DefaultColWidth: Integer read GetDefaultColWidth write SetDefaultColWidth;
    property DefaultRowHeight: Integer read GetDefaultRowHeight write SetDefaultRowHeight;
    property ColWidths[Index: Integer]: Integer read GetColWidths write SetColWidths;
    property RowHeights[Index: Integer]: Integer read GetRowHeights write SetRowHeights;
    property TopRow: Integer read GetTopRow write SetTopRow;
    property LeftCol: Integer read GetLeftCol write SetLeftCol;
    property Color: TColor read GetColor write SetColor;
    property Options: TxlgOptions read GetOptions write SetOptions;
    property VisibleRowCount: Integer read GetVisibleRowCount;
    property VisibleColCount: Integer read GetVisibleColCount;
    property Cells[Col, Row: Integer]: PmdvXLCell read GetCells;

    property SelectedCols[Index: Integer]: Boolean read GetSelectedCols write SetSelectedCols;
    property SelectedRows[Index: Integer]: Boolean read GetSelectedRows write SetSelectedRows;
    property Selected: TRect read GetSelected write SetSelected;
    property Position: TPoint read GetPosition write SetPos;
    property IsCellSelected[Col, Row: Integer]: Boolean read GetIsCellSelected;

    property LineColor: TColor read GetLineColor write SetLineColor;
    property LineWidthLeft: Integer read GetLineWidthLeft write SetLineWidthLeft;
    property LineWidthRight: Integer read GetLineWidthRight write SetLineWidthRight;
    property LineWidthTop: Integer read GetLineWidthTop write SetLineWidthTop;
    property LineWidthBottom: Integer read GetLineWidthBottom write SetLineWidthBottom;

    property TitleRowHeight: Integer read GetTitleRowHeight write SetTitleRowHeight;
    property TitleColWidth: Integer read GetTitleColWidth write SetTitleColWidth;
    property TitleRows[Index: Integer]: String read GetTitleRows write SetTitleRows;
    property TitleCols[Index: Integer]: String read GetTitleCols write SetTitleCols;
    property TitleFont: PGraphicTool read GetTitleFont;
    property TitleColor: TColor read GetTitleColor write SetTitleColor;
    property TitleSelectedColor: TColor read GetTitleSelectedColor write SetTitleSelectedColor;
    property TitleSelectedFontColor: TColor read GetTitleSelectedFontColor write SetTitleSelectedFontColor;

    property SelectedColor: TColor read GetSelectedColor write SetSelectedColor;
    property SelectedColorLine: TColor read GetSelectedColorLine write SetSelectedColorLine;
    property SelectedFontColor: TColor read GetSelectedFontColor write SetSelectedFontColor;

    property GridStyle: TmdvGridStyle read GetGridStyle write SetGridStyle;

    property IndentLeft: Integer read GetIndentLeft write SetIndentLeft;
    property IndentRight: Integer read GetIndentRight write SetIndentRight;
    property IndentTop: Integer read GetIndentTop write SetIndentTop;
    property IndentBottom: Integer read GetIndentBottom write SetIndentBottom;
    property AlignmentHor: ThAlignmentText read GetAlignmentHor write SetAlignmentHor;
    property AlignmentVert: TvAlignmentText read GetAlignmentVert write SetAlignmentVert;
    property TitleRowButton: Boolean read GetTitleRowButton write SetTitleRowButton;
    property TitleColButton: Boolean read GetTitleColButton write SetTitleColButton;
    {$IFDEF Sizing} property ResizeSensitivity: Byte read GetResizeSensitivity write SetResizeSensitivity; {$ENDIF}

    property OnSized: TOnSized read GetOnSized write SetOnSized;
    property OnFocusChange: TOnFocusChange read GetOnFocusChange write SetOnFocusChange;
    property OnSelectedChange: TOnSelectedChange read GetOnSelectedChange write SetOnSelectedChange;
    property OnMoved: TOnMoved read GetOnMoved write SetOnMoved;
    property OnBeginEdit: TOnBeginEdit read GetOnBeginEdit write SetOnBeginEdit;
    property OnEndEdit: TOnEndEdit read GetOnEndEdit write SetOnEndEdit;
    property OnButtonDown: TOnButtonDown read GetOnButtonDown write SetOnButtonDown;
    property OnDrawCell: TOnDrawCell read GetOnDrawCell write SetOnDrawCell;
    property OnDrawTitle: TOnDrawCell read GetOnDrawTitle write SetOnDrawTitle;

    property DefEditorEvents: Boolean read GetDefEditorEvents write SetDefEditorEvents; 
  end;


  TFontCase = (fcNone, fcLow, fcUpper);

  TXLCellLineDirect = (ldLeft, ldRight, ldTop, ldBottom);
  PXLCellLineAttr = ^TXLCellLineAttr;
  TXLCellLineAttr = record
      Drawing: Boolean;
      Color: TColor;
      Space: TRect;
      Width: Integer;
  end;

  TmdvXLCell = object(TObj)
  private
//    FBmp: PBitmap;
    FText: String;
    FLineLeft: PXLCellLineAttr;
    FLineTop: PXLCellLineAttr;
    FLineBottom: PXLCellLineAttr;
    FLineRight: PXLCellLineAttr;
    FFont: PGraphicTool;

    FIndent: TRect;
    FHAlignment: ThAlignmentText;
    FVAlignment: TvAlignmentText;
    FColor: TColor;

    Grid: PmdvXLGrid;
    FShow, FIsMerge: Boolean;
    FBoundsWidth: Integer;
    FBoundsHeight: Integer;
    FMergePos: TPoint;
    FSelected: Integer;
    FData: Pointer;

    procedure DrawLineAttr(ACanvas: PCanvas; ARect: TRect; ACol, ARow: Integer; AFocus: Boolean; var AResRect: TRect);
    procedure SetFont(const Value: PGraphicTool);
    procedure SetColor(const Value: TColor);
    procedure SetText(const Value: String);
    procedure SetHAlignment(const Value: ThAlignmentText);
    procedure SetVAlignment(const Value: TvAlignmentText);

    procedure SetIndentBottom(const Value: Integer);
    procedure SetIndentLeft(const Value: Integer);
    procedure SetIndentRight(const Value: Integer);
    procedure SetIndentTop(const Value: Integer);
  protected
     procedure Draw(ARect: TRect; ACol, ARow: Integer; ACanvas: PCanvas; ASelect, AFocus: Boolean);
  public
     destructor Destroy; virtual;
//     procedure DrawBmp(ARect: TRect);
     property Text: String read FText write SetText;
     {* Текст содержащийся в ячейке. }
     property Data: Pointer read FData write FData;
     {* Указатель на произвольные данные прикрепленные к ячейке. }
     property Font: PGraphicTool read FFont write SetFont;
     {* Шрифт текста в ячейке. }
     property Color: TColor read FColor write SetColor;
     {* Указатель на произвольные данные прикрепленные к ячейке. }
     property HAlignment: ThAlignmentText read FHAlignment write SetHAlignment;
     {* Горизонтальное выравнивание текста в ячейке. }
     property VAlignment: TvAlignmentText read FVAlignment write SetVAlignment;
     {* Вертикальное выравнивание текста в ячейке. }

     property IndentLeft: Integer read FIndent.Left write SetIndentLeft;
     {* Отступ слева текста в ячейке. }
     property IndentRight: Integer read FIndent.Right write SetIndentRight;
     {* Отступ справа текста в ячейке. }
     property IndentTop: Integer read FIndent.Top write SetIndentTop;
     {* Отступ сверху текста в ячейке. }
     property IndentBottom: Integer read FIndent.Bottom write SetIndentBottom;
     {* Отступ снизу текста в ячейке. }

     property LineLeft: PXLCellLineAttr read FLineLeft;
     {* Аттрубуты левой линии ячейки. }
     property LineRight: PXLCellLineAttr read FLineRight;
     {* Аттрубуты правой линии ячейки. }
     property LineTop: PXLCellLineAttr read FLineTop;
     {* Аттрубуты верхней линии ячейки. }
     property LineBottom: PXLCellLineAttr read FLineBottom;
     {* Аттрубуты нижней линии ячейки. }

     property IsMerge: Boolean read FIsMerge;
     {* Объединена ли ячейка. }
     property Show: Boolean read FShow;
     {* Отображается ли ячейка.
        (при IsMerge = True и Show = True - левая верхняя из объединенных ячеек)}
     property BoundsWidth: Integer read FBoundsWidth;
     {* Количество объединенных ячейка по горизонтали. }
     property BoundsHeight: Integer read FBoundsHeight;
     {* Количество объединенных ячейка по вертикали. }
     property MergePos: TPoint read FMergePos;
     {* Координаты левой верхней из объединенных ячеек. }
  end;

const
    DefDefaultColWidth = 70;
    DefDefaultRowHeight = 20;
    DefTitleRowHeight = 20;
    DefTitleColWidth = 30;
    DefTitleColor = clBtnFace;
    DefTitleSelectedColor = cl3DDkShadow;
    DefTitleSelectedFontColor = clBtnHighlight;
    DefSelectedColor = clHighlight;
    DefSelectedColorLine = clHighlightText;
    DefSelectedFontColor = clHighlightText;
    DefColor = clWindow;
    DefLineColor = clBtnShadow;
    DefLineWidthLeft = 1;
    DefLineWidthRight = 1;
    DefLineWidthTop = 1;
    DefLineWidthBottom = 1;
    DefIndentLeft = 1;
    DefIndentRight = 1;
    DefIndentTop = 1;
    DefIndentBottom = 1;
    DefAlignmentHor = ahLeftJustify;
    DefAlignmentVert = avCenter;
    DefOptions = [xlgRowsSelect, xlgColSizing, xlgColMoving];
    DefTitleRowButton = False;
    DefTitleColButton = False;
    DefResizeSensitivity = 1;

function NewmdvXLGrid(AParent: PControl; AColCount, ARowCount: Integer; AGridStyle: TmdvGridStyle; AOptions: TxlgOptions): PmdvXLGrid;

implementation

{$IFDEF Sizing}
  {$R Cursors.res}
{$ENDIF}

const
  IDC_HSPLIT =    PChar(32765);
  IDC_VSPLIT =    PChar(32764);

type
  PKolXLGridData = ^TKolXLGridData;
  TKolXLGridData = object(TObj)
    FGrid: TKOLmdvXLGrid;
    FColCount, FRowCount: Word;
    FDefaultRowHeight, FDefaultColWidth: Integer;
    FTopRow, FLeftCol: Integer;
    FColWidths, FRowHeights: PList;
    FRows: PList;
    {$IFDEF ColsSelect} FSelectedCols: PList; {$ENDIF}
    {$IFDEF RowsSelect} FSelectedRows: PList; {$ENDIF}
    FSelected: TRect;
    FPosition: TPoint;
    FSelectedStart: TPoint;
    FSelectedColor, FSelectedFontColor, FSelectedColorLine: TColor;
    FFirstSelectRows, FFirstSelectCols, FLastSelectRows, FLastSelectCols: Integer;
    {$IFDEF Moving} FMovingInc: Integer; {$ENDIF}
    {$IFDEF ColMoving} FMovingCol: Integer; {$ENDIF}
    {$IFDEF RowMoving} FMovingRow: Integer; {$ENDIF}
    {$IFDEF ColSizing} FResizeCol, FNewSizeCol, FXSizeCol: Integer; {$ENDIF}
    {$IFDEF RowSizing} FResizeRow, FNewSizeRow, FYSizeRow: Integer; {$ENDIF}
    {$IFDEF Sizing} FResizeSensitivity: Integer; {$ENDIF}
    {$IFDEF Sizing} FDefaultCursor: HCursor; {$ENDIF}
    {$IFDEF Sizing} FCursorChanged: Boolean; {$ENDIF}
    {$IFDEF ColSizing} FCursor_hSplit: HCursor; {$ENDIF}
    {$IFDEF RowSizing} FCursor_vSplit: HCursor; {$ENDIF}
    {$IFDEF ColButton} FTitleColButton: Boolean; {$ENDIF}
    {$IFDEF RowButton} FTitleRowButton: Boolean; {$ENDIF}
    FTitleColWidth, FTitleRowHeight, FColButton, FRowButton: Integer;
    FTitleColor: TColor;
    {$IFDEF Select} FTitleSelectedColor, FTitleSelectedFontColor: TColor; {$ENDIF}
    FTitleFont: PGraphicTool;
    FTitleCol: PStrList;
    FTitleRow: PStrList;
    FLineColor: TColor;
    FLineWidth: TRect;
    FIndent: TRect;
    FAlignmentHor: ThAlignmentText;
    FAlignmentVert: TvAlignmentText;
    FOptions: TxlgOptions;
    FGridStyle: TmdvGridStyle;
    FDrawStates: TDrawStates;
    FPaintBmp: PBitmap;
    {$IFDEF Moving} ilMoving: PDragImageList; {$ENDIF}
    FShowEditor, FTextEditor: PControl;
    FDefEditorEvents: Boolean;

    FOnBeginEdit: TOnBeginEdit;
    FOnEndEdit: TOnEndEdit;
    FOnFocusChange: TOnFocusChange;
    FOnSelectedChange: TOnSelectedChange;
    FOnMoved: TOnMoved;
    FOnSized: TOnSized;
    FOnButtonDown: TOnButtonDown;
    FOnDrawCell: TOnDrawCell;
    FOnDrawTitle: TOnDrawCell;
    destructor Destroy; virtual;
  end;

function NewmdvXLCell(AGrid: PmdvXLGrid): PmdvXLCell;
begin
    Result:= New(PmdvXLCell, Create);
    Result.Grid:= AGrid;
    Result.FFont:= NewFont; Result.FFont.Assign(AGrid.Font);

//    Result.FBmp:= NewBitmap(0, 0);
    New(Result.FLineLeft);
    New(Result.FLineTop);
    New(Result.FLineBottom);
    New(Result.FLineRight);

    Result.FBoundsWidth:= 0;
    Result.FBoundsHeight:= 0;
    Result.FMergePos:= MakePoint(0, 0);
    Result.FShow:= True; Result.FIsMerge:= False; Result.FSelected:= 0;

    Result.Text:= '';

    Result.Color:= AGrid.Color;
    Result.LineLeft.Color:= AGrid.LineColor;
    Result.LineRight.Color:= AGrid.LineColor;
    Result.LineTop.Color:= AGrid.LineColor;
    Result.LineBottom.Color:= AGrid.LineColor;
    Result.LineLeft.Width:= AGrid.LineWidthLeft;
    Result.LineRight.Width:= AGrid.LineWidthRight;
    Result.LineTop.Width:= AGrid.LineWidthTop;
    Result.LineBottom.Width:= AGrid.LineWidthBottom;

    Result.HAlignment:= AGrid.AlignmentHor;
    Result.VAlignment:= AGrid.AlignmentVert;

    Result.FIndent:= PKolXLGridData(AGrid.FCustomObj).FIndent;
end;

{ TmdvXLGrid }

function WndProcmdvXLGrid( Sender: PControl; var Msg: TMsg; var Rslt: Integer ): Boolean;
var mdvXLGrid: PmdvXLGrid;
    P: TPoint;
    Bmp: PBitmap;
    R: TRect;
    i, K: Integer;
    RangeSelect: Boolean;
    PaintStruct: TPaintStruct;
procedure Scroll(ACmd, APos, ACount, AVisibleCount: Integer; var AValue: Integer);
begin
    mdvXLGrid.BeginUpdate;
    case ACmd of
      SB_LEFT: AValue:= 0;
      SB_RIGHT: AValue:= ACount - AVisibleCount;
      SB_LINELEFT: AValue:= Max(0, AValue-1);
      SB_LINERIGHT: AValue:= Min(ACount - AVisibleCount, AValue+1);
      SB_PAGELEFT: AValue:= Max(0, AValue - AVisibleCount+1);
      SB_PAGERIGHT: AValue:= Min(ACount - AVisibleCount, AValue + AVisibleCount-1);
      SB_THUMBPOSITION, SB_THUMBTRACK: AValue:= Max(0, Min(ACount - AVisibleCount,  APos));
    end;
    mdvXLGrid.UpdateScrollBars; mdvXLGrid.EndUpdate;
end;
begin
    Result := FALSE;
    mdvXLGrid:= PmdvXLGrid(Sender);
    case Msg.message of
      WM_VSCROLL: begin
        Scroll(LoWord(Msg.wParam), HiWord(Msg.wParam), PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount, mdvXLGrid.VisibleRowCount, PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow);
      end;
      WM_HSCROLL: begin
        Scroll(LoWord(Msg.wParam), HiWord(Msg.wParam), PKolXLGridData(mdvXLGrid.FCustomObj).FColCount, mdvXLGrid.VisibleColCount, PKolXLGridData(mdvXLGrid.FCustomObj).FLeftCol);
      end;
      WM_LBUTTONDBLCLK: begin
        P:= mdvXLGrid.MouseToCell(TSmallPoint(Msg.lParam).X, TSmallPoint(Msg.lParam).Y);
        if (P.X = mdvXLGrid.Position.X)and(P.Y = mdvXLGrid.Position.Y) then mdvXLGrid.BeginEdit;
      end;
      WM_MOUSEWHEEL: begin
        if mdvXLGrid.EndEdit(True) then Exit;
        mdvXLGrid.BeginUpdate;
        if ((Msg.wParam and MK_CONTROL)=MK_CONTROL) then mdvXLGrid.TopRow:= Min(PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-mdvXLGrid.VisibleRowCount,  Max(0,  PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow - (mdvXLGrid.VisibleRowCount-1)*(Smallint(HiWord(Msg.wParam)) div 120)))
        else mdvXLGrid.TopRow:= Min(PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-mdvXLGrid.VisibleRowCount,  Max(0,  PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow - Smallint(HiWord(Msg.wParam)) div 120));
        mdvXLGrid.UpdateScrollBars; mdvXLGrid.EndUpdate;
      end;
      WM_LBUTTONDOWN: begin
        if not mdvXLGrid.EndEdit(True) then Exit;
        if (PKolXLGridData(mdvXLGrid.FCustomObj).FColCount<=0)or(PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount<=0) then Exit;
        SetFocus(mdvXLGrid.Handle); SetCapture(mdvXLGrid.Handle);

        {$IFDEF ColMoving}
        if (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight >= TSmallPoint(Msg.lParam).y)and(PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth < TSmallPoint(Msg.lParam).X)and(GetKeyState( VK_MENU ) < 0)and(xlgColMoving in PKolXLGridData(mdvXLGrid.FCustomObj).FOptions) then begin
          k:= mdvXLGrid.MouseToCol(TSmallPoint(Msg.lParam).X);
          if not mdvXLGrid.HasMerge(MakeRect(k, 0, k, PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-1)) then begin

            PKolXLGridData(mdvXLGrid.FCustomObj).FMovingCol:= k;
            Bmp:= NewBitmap(mdvXLGrid.ColWidths[PKolXLGridData(mdvXLGrid.FCustomObj).FMovingCol], PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight);
            Bmp.PixelFormat:= pf24bit; Bmp.HandleType:= bmDDB;
            R:= mdvXLGrid.CellToRect(PKolXLGridData(mdvXLGrid.FCustomObj).FMovingCol, 0); R.Top:= mdvXLGrid.ClientRect.Top;
            R.Bottom:= R.Top + PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight;
            Bmp.Canvas.CopyRect(MakeRect(0, 0, Bmp.Width-1, Bmp.Height-1), mdvXLGrid.Canvas, R);
            Bmp.Canvas.Pen.Color:= clLime; Bmp.Canvas.Pen.PenWidth:= 3; Bmp.Canvas.Brush.BrushStyle:= bsClear; Bmp.Canvas.Rectangle(0, 0, Bmp.Width-1, Bmp.Height-1);

            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.DragCursor:= 0;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ImageList.Clear;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ImageList.Colors:= ilcColorDDB;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ImageList.ImgWidth:= Bmp.Width; PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ImageList.ImgHeight:= Bmp.Height;
            k:= PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ImageList.Add(Bmp.ReleaseHandle, 0);

            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.SetDragImage(k, Bmp.Width div 2, 0);
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.BeginDrag(mdvXLGrid.Handle, R.Left + (R.Right-R.Left) div 2, 0);
            PKolXLGridData(mdvXLGrid.FCustomObj).FMovingInc:= R.Left + (R.Right-R.Left) div 2 - TSmallPoint(Msg.lParam).X;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ShowDragImage;
            Bmp.Free;
          end;
          Exit;
        end;
        {$ENDIF}
        {$IFDEF RowMoving}
        if (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth >= TSmallPoint(Msg.lParam).X)and(PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight < TSmallPoint(Msg.lParam).Y)and(GetKeyState( VK_MENU ) < 0)and(xlgRowMoving in PKolXLGridData(mdvXLGrid.FCustomObj).FOptions) then begin
          k:= mdvXLGrid.MouseToRow(TSmallPoint(Msg.lParam).Y);
          if not mdvXLGrid.HasMerge(MakeRect(0, k, PKolXLGridData(mdvXLGrid.FCustomObj).FColCount-1, k)) then begin

            PKolXLGridData(mdvXLGrid.FCustomObj).FMovingRow:= k;
            Bmp:= NewBitmap(PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth, mdvXLGrid.RowHeights[PKolXLGridData(mdvXLGrid.FCustomObj).FMovingRow]);
            Bmp.PixelFormat:= pf24bit; Bmp.HandleType:= bmDDB;
            R:= mdvXLGrid.CellToRect(0, PKolXLGridData(mdvXLGrid.FCustomObj).FMovingRow); R.Left:= mdvXLGrid.ClientRect.Left; R.Right:= R.Left + PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth;
            Bmp.Canvas.CopyRect(MakeRect(0, 0, Bmp.Width-1, Bmp.Height-1), mdvXLGrid.Canvas, R);
            Bmp.Canvas.Pen.Color:= clLime; Bmp.Canvas.Pen.PenWidth:= 3; Bmp.Canvas.Brush.BrushStyle:= bsClear; Bmp.Canvas.Rectangle(0, 0, Bmp.Width-1, Bmp.Height-1);

            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.DragCursor:= 0;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ImageList.Clear;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ImageList.Colors:= ilcColorDDB;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ImageList.ImgWidth:= Bmp.Width; PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ImageList.ImgHeight:= Bmp.Height;
            k:= PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ImageList.Add(Bmp.ReleaseHandle, 0);
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.SetDragImage(k, 0, Bmp.Height div 2);
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.BeginDrag(mdvXLGrid.Handle, 0, R.Top + (R.Bottom-R.Top) div 2);
            PKolXLGridData(mdvXLGrid.FCustomObj).FMovingInc:= R.Top + (R.Bottom-R.Top) div 2 - TSmallPoint(Msg.lParam).Y;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ShowDragImage;
            Bmp.Free;
          end;
          Exit;
        end;
        {$ENDIF}
        {$IFDEF ColSizing}
        if PKolXLGridData(mdvXLGrid.FCustomObj).FResizeCol <> -1 then begin

          PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeCol:= mdvXLGrid.ColWidths[PKolXLGridData(mdvXLGrid.FCustomObj).FResizeCol];
          PKolXLGridData(mdvXLGrid.FCustomObj).FXSizeCol:= TSmallPoint(Msg.lParam).X;
          mdvXLGrid.Invalidate;
          Exit;
        end;
        {$ENDIF}
        {$IFDEF RowSizing}
        if PKolXLGridData(mdvXLGrid.FCustomObj).FResizeRow <> -1 then begin

          PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeRow:= mdvXLGrid.RowHeights[PKolXLGridData(mdvXLGrid.FCustomObj).FResizeRow];
          PKolXLGridData(mdvXLGrid.FCustomObj).FYSizeRow:= TSmallPoint(Msg.lParam).Y;
          mdvXLGrid.Invalidate;
          Exit;
        end;
        {$ENDIF}
        PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows:= -1; PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols:= -1;
        PKolXLGridData(mdvXLGrid.FCustomObj).FSelectedStart:= MakePoint(-1, -1);

        //Выделить все
        if (xlgRangeSelect in PKolXLGridData(mdvXLGrid.FCustomObj).FOptions) then begin
          PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates:= PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates - [dsDeadDown];
          if (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth >= TSmallPoint(Msg.lParam).X) and (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight >= TSmallPoint(Msg.lParam).Y) then begin

            PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates:= PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates + [dsDeadDown];
            mdvXLGrid.SetSelectedAll(True);
            mdvXLGrid.Position:= MakePoint(PKolXLGridData(mdvXLGrid.FCustomObj).FLeftCol, PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow);
            mdvXLGrid.Selected:= MakeRect(0, 0, PKolXLGridData(mdvXLGrid.FCustomObj).FColCount-1, PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-1);
          end;
        end;

        //Выделение по строкам
        if (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth >= TSmallPoint(Msg.lParam).X) and (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight < TSmallPoint(Msg.lParam).Y) then begin
          if {$IFDEF ColButton} not PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColButton and  {$ENDIF} (xlgRowsSelect in PKolXLGridData(mdvXLGrid.FCustomObj).FOptions) then begin

            PKolXLGridData(mdvXLGrid.FCustomObj).FSelected:= MakeRect(-1, -1, -1, -1);
            if (Msg.wParam and MK_CONTROL)<>MK_CONTROL then mdvXLGrid.SetSelectedAll(False);
            PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows:= mdvXLGrid.MouseToRow(TSmallPoint(Msg.lParam).Y); PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectRows:= PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows;
            if PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows <> -1 then begin
  //            Position:= MakePoint(LeftCol, PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows);
  //            Selected:= MakeRect(0, PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows, ColCount-1, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectRows);
              mdvXLGrid.SelectedRows[PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows]:= not mdvXLGrid.SelectedRows[PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows];
            end;
          end;
          {$IFDEF ColButton}
          if PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColButton then begin

            PKolXLGridData(mdvXLGrid.FCustomObj).FColButton:= mdvXLGrid.MouseToRow(TSmallPoint(Msg.lParam).Y);
            PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates:= PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates + [dsButtonDown];
            mdvXLGrid.Invalidate;
          end;
           {$ENDIF}
        end;

        if (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth < TSmallPoint(Msg.lParam).X) and (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight >= TSmallPoint(Msg.lParam).Y) then begin
          //Выделение по столбцам
          if {$IFDEF RowButton} not PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowButton and {$ENDIF} (xlgColsSelect in PKolXLGridData(mdvXLGrid.FCustomObj).FOptions) then begin

            PKolXLGridData(mdvXLGrid.FCustomObj).FSelected:= MakeRect(-1, -1, -1, -1);
            if (Msg.wParam and MK_CONTROL)<>MK_CONTROL then mdvXLGrid.SetSelectedAll(False);
            PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols:= mdvXLGrid.MouseToCol(TSmallPoint(Msg.lParam).X); PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectCols:= PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols;
            if PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols <> -1 then begin
  //            Position:= MakePoint(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols, TopRow);
  //            Selected:= MakeRect(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols, 0, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectCols, RowCount-1);
              mdvXLGrid.SelectedCols[PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols]:= not mdvXLGrid.SelectedCols[PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols];
            end;
          end;
          {$IFDEF RowButton}
          if PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowButton then begin

            PKolXLGridData(mdvXLGrid.FCustomObj).FRowButton:= mdvXLGrid.MouseToCol(TSmallPoint(Msg.lParam).X);
            PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates:= PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates + [dsButtonDown];
            mdvXLGrid.Invalidate;
          end;
          {$ENDIF}
        end;

        if (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth < TSmallPoint(Msg.lParam).X) and (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight < TSmallPoint(Msg.lParam).Y) then begin

          PKolXLGridData(mdvXLGrid.FCustomObj).FSelected:= MakeRect(-1, -1, -1, -1);
          if ((Msg.wParam and MK_CONTROL)<>MK_CONTROL) or not (xlgRangeSelect in PKolXLGridData(mdvXLGrid.FCustomObj).FOptions) then mdvXLGrid.SetSelectedAll(False);
          PKolXLGridData(mdvXLGrid.FCustomObj).FSelectedStart:= mdvXLGrid.MouseToCell(TSmallPoint(Msg.lParam).X, TSmallPoint(Msg.lParam).Y);
          mdvXLGrid.Position:= PKolXLGridData(mdvXLGrid.FCustomObj).FSelectedStart;
          PKolXLGridData(mdvXLGrid.FCustomObj).FSelectedStart:= mdvXLGrid.Position;
        end;
      end;
      WM_LBUTTONUP: begin
        {$IFDEF ColMoving}
        if PKolXLGridData(mdvXLGrid.FCustomObj).FMovingCol<>-1 then begin
          PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.HideDragImage;
          PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.EndDrag;
          k:= mdvXLGrid.MouseToCol(TSmallPoint(Msg.lParam).X);
          mdvXLGrid.MoveCol(PKolXLGridData(mdvXLGrid.FCustomObj).FMovingCol, k);
          mdvXLGrid.ShowPosX(k);
          R:= mdvXLGrid.CellToRect(k, 0);
          R.TopLeft:= mdvXLGrid.Client2Screen(MakePoint(R.Left + (R.Right - R.Left) div 2, PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight div 2));
          SetCursorPos(R.Left, R.Top);
        end;
        {$ENDIF}
        {$IFDEF RowMoving}
        if PKolXLGridData(mdvXLGrid.FCustomObj).FMovingRow<>-1 then begin
          PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.HideDragImage;
          PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.EndDrag;
          k:= mdvXLGrid.MouseToRow(TSmallPoint(Msg.lParam).Y);
          mdvXLGrid.MoveRow(PKolXLGridData(mdvXLGrid.FCustomObj).FMovingRow, k);
          R:= mdvXLGrid.CellToRect(0, k);
          R.TopLeft:= mdvXLGrid.Client2Screen(MakePoint(PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth  div 2, R.Top + (R.Bottom - R.Top) div 2));
          SetCursorPos(R.Left, R.Top);
        end;
        {$ENDIF}

        if PKolXLGridData(mdvXLGrid.FCustomObj).FRowButton >=0 then begin
          PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates:= PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates - [dsButtonDown];
          mdvXLGrid.Invalidate;
          if (PKolXLGridData(mdvXLGrid.FCustomObj).FRowButton = mdvXLGrid.MouseToCol(TSmallPoint(Msg.lParam).X))and(PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight >= TSmallPoint(Msg.lParam).Y) then
            if Assigned(PKolXLGridData(mdvXLGrid.FCustomObj).FOnButtonDown) then PKolXLGridData(mdvXLGrid.FCustomObj).FOnButtonDown(@mdvXLGrid, dCol, PKolXLGridData(mdvXLGrid.FCustomObj).FRowButton);
        end;
        if PKolXLGridData(mdvXLGrid.FCustomObj).FColButton >=0 then begin
          PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates:= PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates - [dsButtonDown];
          mdvXLGrid.Invalidate;
          if (PKolXLGridData(mdvXLGrid.FCustomObj).FColButton = mdvXLGrid.MouseToRow(TSmallPoint(Msg.lParam).Y))and(PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth >= TSmallPoint(Msg.lParam).X) then
            if Assigned(PKolXLGridData(mdvXLGrid.FCustomObj).FOnButtonDown) then PKolXLGridData(mdvXLGrid.FCustomObj).FOnButtonDown(@mdvXLGrid, dRow, PKolXLGridData(mdvXLGrid.FCustomObj).FColButton);
        end;
        {$IFDEF ColSizing}
        if PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeCol <> -1 then begin
          mdvXLGrid.ColWidths[PKolXLGridData(mdvXLGrid.FCustomObj).FResizeCol]:= PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeCol;
        end;
        {$ENDIF}
        {$IFDEF RowSizing}
        if PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeRow <> -1 then begin
          mdvXLGrid.RowHeights[PKolXLGridData(mdvXLGrid.FCustomObj).FResizeRow]:= PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeRow;
        end;
        {$ENDIF}
        {$IFDEF ColSizing}PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeCol:= -1; PKolXLGridData(mdvXLGrid.FCustomObj).FResizeCol:= -1; {$ENDIF}
        {$IFDEF RowSizing}PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeRow:= -1; PKolXLGridData(mdvXLGrid.FCustomObj).FResizeRow:= -1; {$ENDIF}
        {$IFDEF ColMoving}PKolXLGridData(mdvXLGrid.FCustomObj).FMovingCol:= -1; {$ENDIF} {$IFDEF RowMoving}PKolXLGridData(mdvXLGrid.FCustomObj).FMovingRow:= -1;{$ENDIF}
        PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows:= -1; PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols:= -1;
        PKolXLGridData(mdvXLGrid.FCustomObj).FSelectedStart:= MakePoint(-1, -1);
        PKolXLGridData(mdvXLGrid.FCustomObj).FRowButton:= -1; PKolXLGridData(mdvXLGrid.FCustomObj).FColButton:= -1;
        ReleaseCapture;
      end;
      WM_MOUSEMOVE: begin
        {$IFDEF ColMoving}
        if PKolXLGridData(mdvXLGrid.FCustomObj).FMovingCol<>-1 then begin
          if PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.Dragging then PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.DragMove(TSmallPoint(Msg.lParam).X+PKolXLGridData(mdvXLGrid.FCustomObj).FMovingInc,0);
          K:= mdvXLGrid.MouseToCol(TSmallPoint(Msg.lParam).X+PKolXLGridData(mdvXLGrid.FCustomObj).FMovingInc);
          if K > PKolXLGridData(mdvXLGrid.FCustomObj).FLeftCol + mdvXLGrid.VisibleColCount-1 then begin
            mdvXLGrid.LeftCol:= K - mdvXLGrid.VisibleColCount + 1;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.HideDragImage;
            mdvXLGrid.Update; mdvXLGrid.UpdateScrollBars;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ShowDragImage;
          end;
          if (K < 0)and(PKolXLGridData(mdvXLGrid.FCustomObj).FLeftCol>0) then begin
            mdvXLGrid.LeftCol:= Max(0, PKolXLGridData(mdvXLGrid.FCustomObj).FLeftCol-1);
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.HideDragImage;
            mdvXLGrid.Update; mdvXLGrid.UpdateScrollBars;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ShowDragImage;
          end;
          Exit;
        end;
        {$ENDIF}
        {$IFDEF RowMoving}
        if PKolXLGridData(mdvXLGrid.FCustomObj).FMovingRow<>-1 then begin
          if PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.Dragging then PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.DragMove(0,TSmallPoint(Msg.lParam).Y+PKolXLGridData(mdvXLGrid.FCustomObj).FMovingInc);
          K:= mdvXLGrid.MouseToRow(TSmallPoint(Msg.lParam).Y+PKolXLGridData(mdvXLGrid.FCustomObj).FMovingInc);
          if K > PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow + mdvXLGrid.VisibleRowCount-1 then begin
            mdvXLGrid.TopRow:= K - mdvXLGrid.VisibleRowCount + 1;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.HideDragImage;
            mdvXLGrid.Update; mdvXLGrid.UpdateScrollBars;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ShowDragImage;
          end;
          if K < 0 then begin
            mdvXLGrid.TopRow:= Max(0, PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow - 1);
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.HideDragImage;
            mdvXLGrid.Update; mdvXLGrid.UpdateScrollBars;
            PKolXLGridData(mdvXLGrid.FCustomObj).ilMoving.ShowDragImage;
          end;
          Exit;
        end;
        {$ENDIF}
        if PKolXLGridData(mdvXLGrid.FCustomObj).FRowButton >=0 then begin
          K:= mdvXLGrid.MouseToCol(TSmallPoint(Msg.lParam).X);
          if (PKolXLGridData(mdvXLGrid.FCustomObj).FRowButton = K)and(PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight >= TSmallPoint(Msg.lParam).Y) then PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates:= PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates + [dsButtonDown]
          else PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates:= PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates - [dsButtonDown];
          mdvXLGrid.Invalidate;
          Exit;
        end;
        if PKolXLGridData(mdvXLGrid.FCustomObj).FColButton >=0 then begin
          K:= mdvXLGrid.MouseToRow(TSmallPoint(Msg.lParam).Y);
          if (PKolXLGridData(mdvXLGrid.FCustomObj).FColButton = K)and(PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth >= TSmallPoint(Msg.lParam).X) then PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates:= PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates + [dsButtonDown]
          else PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates:= PKolXLGridData(mdvXLGrid.FCustomObj).FDrawStates - [dsButtonDown];
          mdvXLGrid.Invalidate;
          Exit;
        end;

        //Выделение диапазона
        if (PKolXLGridData(mdvXLGrid.FCustomObj).FSelectedStart.x<>-1) then begin
          P:= mdvXLGrid.MouseToCell(TSmallPoint(Msg.lParam).X, TSmallPoint(Msg.lParam).Y); //P:= Point(Max(P.x, 0), Max(P.y, 0));
          if P.X > PKolXLGridData(mdvXLGrid.FCustomObj).FLeftCol+mdvXLGrid.VisibleColCount-1 then begin
            mdvXLGrid.LeftCol:= P.X - mdvXLGrid.VisibleColCount + 1;
          end;
          if P.y > PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow + mdvXLGrid.VisibleRowCount-1 then begin
            mdvXLGrid.TopRow:= P.y - mdvXLGrid.VisibleRowCount + 1;
            mdvXLGrid.Invalidate;
          end;

          if P.X < 0 then begin
            mdvXLGrid.LeftCol:= Max(0, PKolXLGridData(mdvXLGrid.FCustomObj).FLeftCol-1);
            P.X:= PKolXLGridData(mdvXLGrid.FCustomObj).FLeftCol;
          end;
          if P.y < 0 then begin
            mdvXLGrid.TopRow:= Max(0, PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow - 1);
            P.y:= PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow;
          end;
          R:= MakeRect(Min(PKolXLGridData(mdvXLGrid.FCustomObj).FSelectedStart.x, P.x), Min(PKolXLGridData(mdvXLGrid.FCustomObj).FSelectedStart.y, P.y), Max(PKolXLGridData(mdvXLGrid.FCustomObj).FSelectedStart.x, P.x), Max(PKolXLGridData(mdvXLGrid.FCustomObj).FSelectedStart.y, P.y));

          if (xlgRangeSelect in PKolXLGridData(mdvXLGrid.FCustomObj).FOptions) then begin
            if not RectsEqual(PKolXLGridData(mdvXLGrid.FCustomObj).FSelected, R) then begin
              mdvXLGrid.Selected := R;
              mdvXLGrid.Invalidate;
              mdvXLGrid.UpdateScrollBars;
            end;
          end
          else begin
            if (PKolXLGridData(mdvXLGrid.FCustomObj).FPosition.X <> P.X)or(PKolXLGridData(mdvXLGrid.FCustomObj).FPosition.Y <> P.Y) then begin
              mdvXLGrid.Position:= P;
              PKolXLGridData(mdvXLGrid.FCustomObj).FSelected:= MakeRect(mdvXLGrid.Position.X, mdvXLGrid.Position.Y, mdvXLGrid.Position.X, mdvXLGrid.Position.Y);
              mdvXLGrid.Invalidate;
              mdvXLGrid.UpdateScrollBars;
            end;
          end;
          Exit;
        end;

        //Выделение по колонкам
        if PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols <> -1 then begin
          K:= mdvXLGrid.MouseToCol(TSmallPoint(Msg.lParam).X);
          if K > PKolXLGridData(mdvXLGrid.FCustomObj).FLeftCol+mdvXLGrid.VisibleColCount-1 then begin
            mdvXLGrid.LeftCol:= K - mdvXLGrid.VisibleColCount + 1;
          end;
          if K < 0 then begin
            mdvXLGrid.LeftCol:= Max(0, PKolXLGridData(mdvXLGrid.FCustomObj).FLeftCol-1);
            K:= PKolXLGridData(mdvXLGrid.FCustomObj).FLeftCol;
          end;
          if (K <> -1)and(K <> PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectCols) then begin
            for i:= Min(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectCols) to Max(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectCols) do mdvXLGrid.SelectedCols[i]:= False;
            PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectCols:= K;
    //        PKolXLGridData(mdvXLGrid.FCustomObj).FSelected:= MakeRect(Min(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectCols), 0, Max(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectCols), PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-1);
            for i:= Min(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectCols) to Max(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectCols, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectCols) do mdvXLGrid.SelectedCols[i]:= True;
            mdvXLGrid.Invalidate;
            mdvXLGrid.UpdateScrollBars;
          end;
          Exit;
        end;
        //Выделение по строкам
        if PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows <> -1 then begin
          K:= mdvXLGrid.MouseToRow(TSmallPoint(Msg.lParam).Y);
          if K > PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow+mdvXLGrid.VisibleRowCount-1 then begin
            mdvXLGrid.TopRow:= K - mdvXLGrid.VisibleRowCount + 1;
          end;
          if K < 0 then begin
            mdvXLGrid.TopRow:= Max(0, PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow - 1);
            K:= PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow;
          end;
          if (K <> -1)and(K <> PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectRows) then begin
            for i:= Min(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectRows) to Max(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectRows) do mdvXLGrid.SelectedRows[i]:= False;
            PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectRows:= K;
    //        PKolXLGridData(mdvXLGrid.FCustomObj).FSelected:= MakeRect(0, Min(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectRows), PKolXLGridData(mdvXLGrid.FCustomObj).FColCount-1, Max(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectRows));
            for i:= Min(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectRows) to Max(PKolXLGridData(mdvXLGrid.FCustomObj).FFirstSelectRows, PKolXLGridData(mdvXLGrid.FCustomObj).FLastSelectRows) do mdvXLGrid.SelectedRows[i]:= True;
            mdvXLGrid.Invalidate;
            mdvXLGrid.UpdateScrollBars;
          end;
          Exit;
        end;

        //Изменение размеров колонки
        {$IFDEF ColSizing}
        if PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeCol <> -1 then begin
          PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeCol:= Max(1, mdvXLGrid.ColWidths[PKolXLGridData(mdvXLGrid.FCustomObj).FResizeCol] + (TSmallPoint(Msg.lParam).X-PKolXLGridData(mdvXLGrid.FCustomObj).FXSizeCol));
          mdvXLGrid.Invalidate;
          Exit;
        end;
        {$ENDIF}
        //Изменение размеров строки
        {$IFDEF RowSizing}
        if PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeRow <> -1 then begin
          PKolXLGridData(mdvXLGrid.FCustomObj).FNewSizeRow:= Max(1, mdvXLGrid.RowHeights[PKolXLGridData(mdvXLGrid.FCustomObj).FResizeRow] + (TSmallPoint(Msg.lParam).Y-PKolXLGridData(mdvXLGrid.FCustomObj).FYSizeRow));
          mdvXLGrid.Invalidate;
          Exit;
        end;
        {$ENDIF}
        //Определение возможности изменения размеров колонки
        {$IFDEF ColSizing}
        if (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth < TSmallPoint(Msg.lParam).X) and (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight > TSmallPoint(Msg.lParam).Y) then begin
          PKolXLGridData(mdvXLGrid.FCustomObj).FResizeCol:= mdvXLGrid.MouseToColBorder(TSmallPoint(Msg.lParam).X);
          if PKolXLGridData(mdvXLGrid.FCustomObj).FResizeCol <> -1 then mdvXLGrid.ChangeCursor(1) else mdvXLGrid.RestoreCursor;
        end else
        {$ENDIF}
          {$IFDEF RowSizing}
          //Определение возможности изменения размеров строки
          if (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleColWidth > TSmallPoint(Msg.lParam).X) and (PKolXLGridData(mdvXLGrid.FCustomObj).FTitleRowHeight < TSmallPoint(Msg.lParam).Y) then begin
            PKolXLGridData(mdvXLGrid.FCustomObj).FResizeRow:= mdvXLGrid.MouseToRowBorder(TSmallPoint(Msg.lParam).Y);
            if PKolXLGridData(mdvXLGrid.FCustomObj).FResizeRow <> -1 then mdvXLGrid.ChangeCursor(2)  else mdvXLGrid.RestoreCursor;
          end else mdvXLGrid.RestoreCursor;{$ENDIF}
      end;
      WM_KEYDOWN: begin
        if not mdvXLGrid.EndEdit(True) then Exit;
        RangeSelect:= (xlgRangeSelect in PKolXLGridData(mdvXLGrid.FCustomObj).FOptions) and (GetKeyState( VK_SHIFT ) < 0);
        if not (GetKeyState(VK_CONTROL) < 0) then
          case Msg.wParam of
             VK_LEFT: begin
                mdvXLGrid.SetSelectedAll(False);
                if RangeSelect then begin
                  P:= mdvXLGrid.GetCountCol(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom, mdvXLGrid.Position.x);
                  if (mdvXLGrid.Selected.Left <=  P.x)and(mdvXLGrid.Selected.Right =  P.y) then begin
                    P:= mdvXLGrid.GetCountCol(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom, mdvXLGrid.Selected.Left-1);
                    mdvXLGrid.Selected:= MakeRect(Max(0, P.x), mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Right, mdvXLGrid.Selected.Bottom);
                    mdvXLGrid.ShowPosX(mdvXLGrid.Selected.Left);
                  end
                  else begin
                    P:= mdvXLGrid.GetCountCol(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom, mdvXLGrid.Selected.Right);
                    P:= mdvXLGrid.GetCountCol(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom, P.x-1);
                    mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Top, Min(PKolXLGridData(mdvXLGrid.FCustomObj).FColCount-1, P.y), mdvXLGrid.Selected.Bottom);
                    mdvXLGrid.ShowPosX(mdvXLGrid.Selected.Right-1);
                  end
                end
                else begin
                  P:= mdvXLGrid.GetCountCol(mdvXLGrid.Position.y, mdvXLGrid.Position.y, Max(0, mdvXLGrid.Position.x));
                  mdvXLGrid.Position:= MakePoint(Max(0, P.x - 1), mdvXLGrid.Position.y);
                end;
                mdvXLGrid.Invalidate;
             end;
             VK_RIGHT: begin
                mdvXLGrid.SetSelectedAll(False);
                if RangeSelect then begin
                  P:= mdvXLGrid.GetCountCol(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom, mdvXLGrid.Position.x);
                  if (mdvXLGrid.Selected.Right >=  P.y)and(mdvXLGrid.Selected.Left =  P.x) then begin
                    P:= mdvXLGrid.GetCountCol(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom, mdvXLGrid.Selected.Right+1);
                    mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Top, Min(PKolXLGridData(mdvXLGrid.FCustomObj).FColCount-1, P.y), mdvXLGrid.Selected.Bottom);
                    mdvXLGrid.ShowPosX(mdvXLGrid.Selected.Right);
                  end
                  else begin
                    P:= mdvXLGrid.GetCountCol(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom, mdvXLGrid.Selected.Left);
                    P:= mdvXLGrid.GetCountCol(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom, P.y+1);
                    mdvXLGrid.Selected:= MakeRect(Max(0, P.x), mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Right, mdvXLGrid.Selected.Bottom);
                    mdvXLGrid.ShowPosX(mdvXLGrid.Selected.Left);
                  end
                end
                else begin
                  P:= mdvXLGrid.GetCountCol(mdvXLGrid.Position.y, mdvXLGrid.Position.y, Max(0, mdvXLGrid.Position.x));
                  mdvXLGrid.Position:= MakePoint(Min(PKolXLGridData(mdvXLGrid.FCustomObj).FColCount-1, P.y + 1), mdvXLGrid.Position.y);
                end;
                mdvXLGrid.Invalidate;
             end;
             VK_UP: begin
                mdvXLGrid.SetSelectedAll(False);
                if RangeSelect then begin
                  P:= mdvXLGrid.GetCountRow(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right, mdvXLGrid.Position.y);
                  if (mdvXLGrid.Selected.Top <=  P.x)and(mdvXLGrid.Selected.Bottom =  P.y) then begin
                    P:= mdvXLGrid.GetCountRow(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right, mdvXLGrid.Selected.Top-1);
                    mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, Max(0, P.x), mdvXLGrid.Selected.Right, mdvXLGrid.Selected.Bottom);
                    mdvXLGrid.ShowPosY(mdvXLGrid.Selected.Top);
                  end
                  else begin
                    P:= mdvXLGrid.GetCountRow(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right, mdvXLGrid.Selected.Bottom);
                    P:= mdvXLGrid.GetCountRow(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right, P.x-1);
                    mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Right, Min(PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-1, P.y));
                    mdvXLGrid.ShowPosY(mdvXLGrid.Selected.Bottom);
                  end
                end
                else begin
                  P:= mdvXLGrid.GetCountRow(mdvXLGrid.Position.x, mdvXLGrid.Position.x, Max(0, mdvXLGrid.Position.y));
                  mdvXLGrid.Position:= MakePoint(mdvXLGrid.Position.x, Max(0, P.x - 1));
                end;
                mdvXLGrid.Invalidate;
             end;
             VK_DOWN: begin
                mdvXLGrid.SetSelectedAll(False);
                if RangeSelect then begin
                  P:= mdvXLGrid.GetCountRow(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right, mdvXLGrid.Position.y);
                  if (mdvXLGrid.Selected.Bottom >=  P.y)and(mdvXLGrid.Selected.Top =  P.x) then begin
                    P:= mdvXLGrid.GetCountRow(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right, mdvXLGrid.Selected.Bottom+1);
                    mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Right, Min(PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-1, P.y));
                    mdvXLGrid.ShowPosY(mdvXLGrid.Selected.Bottom);
                  end
                  else begin
                    P:= mdvXLGrid.GetCountRow(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right, mdvXLGrid.Selected.Top);
                    P:= mdvXLGrid.GetCountRow(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right, P.y+1);
                    mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, Max(0, P.x), mdvXLGrid.Selected.Right, mdvXLGrid.Selected.Bottom);
                    mdvXLGrid.ShowPosY(mdvXLGrid.Selected.Top);
                  end
                end
                else begin
                  P:= mdvXLGrid.GetCountRow(mdvXLGrid.Position.x, mdvXLGrid.Position.x, Max(0, mdvXLGrid.Position.y));
                  mdvXLGrid.Position:= MakePoint(mdvXLGrid.Position.x, Max(0, P.y + 1));
                end;
                mdvXLGrid.Invalidate;
             end;
             VK_PRIOR: begin
                mdvXLGrid.SetSelectedAll(False);
                mdvXLGrid.TopRow:= Max(PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow - mdvXLGrid.VisibleRowCount+1, 0);
                if RangeSelect then
                  if (mdvXLGrid.Selected.Top <=  mdvXLGrid.Position.y)and(mdvXLGrid.Selected.Bottom =  mdvXLGrid.Position.y) then begin
                    mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, Max(0, mdvXLGrid.Selected.Top - mdvXLGrid.VisibleRowCount+1), mdvXLGrid.Selected.Right, mdvXLGrid.Selected.Bottom);
                    mdvXLGrid.Selected:= MakeRect(Min(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right), Min(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom), Max(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right), Max(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom));
                    mdvXLGrid.ShowPosY(mdvXLGrid.Selected.Top);
                  end
                  else begin
                    mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Right, Min(PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-1, mdvXLGrid.Selected.Bottom-mdvXLGrid.VisibleRowCount+1));
                    mdvXLGrid.Selected:= MakeRect(Min(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right), Min(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom), Max(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right), Max(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom));
                    mdvXLGrid.ShowPosY(mdvXLGrid.Selected.Bottom);
                  end
                else mdvXLGrid.Position:= MakePoint(mdvXLGrid.Position.x, Max(0, mdvXLGrid.Position.y - mdvXLGrid.VisibleRowCount+1));
                mdvXLGrid.Invalidate;
                mdvXLGrid.UpdateScrollBars;
             end;
             VK_NEXT: begin
                mdvXLGrid.SetSelectedAll(False);
                mdvXLGrid.TopRow:= Min(PKolXLGridData(mdvXLGrid.FCustomObj).FTopRow + mdvXLGrid.VisibleRowCount-1, PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-mdvXLGrid.VisibleRowCount);
                if RangeSelect then
                  if (mdvXLGrid.Selected.Bottom >=  mdvXLGrid.Position.y)and(mdvXLGrid.Selected.Top =  mdvXLGrid.Position.y) then begin
                    mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Right, Min(PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-1, mdvXLGrid.Selected.Bottom+mdvXLGrid.VisibleRowCount-1));
                    mdvXLGrid.Selected:= MakeRect(Min(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right), Min(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom), Max(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right), Max(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom));
                    mdvXLGrid.ShowPosY(mdvXLGrid.Selected.Bottom);
                  end
                  else begin
                    mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, Max(0, mdvXLGrid.Selected.Top+mdvXLGrid.VisibleRowCount-1), mdvXLGrid.Selected.Right, mdvXLGrid.Selected.Bottom);
                    mdvXLGrid.Selected:= MakeRect(Min(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right), Min(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom), Max(mdvXLGrid.Selected.Left, mdvXLGrid.Selected.Right), Max(mdvXLGrid.Selected.Top, mdvXLGrid.Selected.Bottom));
                    mdvXLGrid.ShowPosY(mdvXLGrid.Selected.Top);
                  end
                else mdvXLGrid.Position:= MakePoint(mdvXLGrid.Position.x, Min(PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-1, mdvXLGrid.Position.y + mdvXLGrid.VisibleRowCount-1));
                mdvXLGrid.Invalidate;
                mdvXLGrid.UpdateScrollBars;
             end;
             VK_HOME: begin
                mdvXLGrid.SetSelectedAll(False);
                mdvXLGrid.LeftCol:= 0;
                if RangeSelect then
                  mdvXLGrid.Selected:= MakeRect(0, mdvXLGrid.Selected.Top, mdvXLGrid.Position.x, mdvXLGrid.Selected.Bottom)
                else mdvXLGrid.Position:= MakePoint(0, mdvXLGrid.Position.y);
                mdvXLGrid.Invalidate;
                mdvXLGrid.UpdateScrollBars;
             end;
             VK_END: begin
                mdvXLGrid.SetSelectedAll(False);
                mdvXLGrid.LeftCol:= Max(0, PKolXLGridData(mdvXLGrid.FCustomObj).FColCount - mdvXLGrid.VisibleColCount);
                if RangeSelect then mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Position.x, mdvXLGrid.Selected.Top, PKolXLGridData(mdvXLGrid.FCustomObj).FColCount - 1, mdvXLGrid.Selected.Bottom)
                else mdvXLGrid.Position:= MakePoint(PKolXLGridData(mdvXLGrid.FCustomObj).FColCount - 1, mdvXLGrid.Position.y);
                mdvXLGrid.Invalidate;
                mdvXLGrid.UpdateScrollBars;
             end;
             VK_RETURN, VK_F2: begin
                mdvXLGrid.BeginEdit;
             end;
          end
        else
          case Msg.wParam of
             VK_UP: begin
                mdvXLGrid.SetSelectedAll(False);
                mdvXLGrid.TopRow:= 0;
                if RangeSelect then mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, 0, mdvXLGrid.Selected.Right, mdvXLGrid.Position.y)
                else mdvXLGrid.Position:= MakePoint(mdvXLGrid.Position.x, 0);
                mdvXLGrid.Invalidate;
             end;
             VK_DOWN: begin
                mdvXLGrid.SetSelectedAll(False);
                mdvXLGrid.TopRow:= Max(0, PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount - mdvXLGrid.VisibleRowCount);
                if RangeSelect then mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Selected.Left, mdvXLGrid.Position.y, mdvXLGrid.Selected.Right, PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-1)
                else mdvXLGrid.Position:= MakePoint(mdvXLGrid.Position.x, PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-1);
                mdvXLGrid.Invalidate;
                mdvXLGrid.UpdateScrollBars;
             end;
             VK_LEFT: begin
                mdvXLGrid.SetSelectedAll(False);
                mdvXLGrid.LeftCol:= 0;
                if RangeSelect then mdvXLGrid.Selected:= MakeRect(0, mdvXLGrid.Selected.Top, mdvXLGrid.Position.x, mdvXLGrid.Selected.Bottom)
                else mdvXLGrid.Position:= MakePoint(0, mdvXLGrid.Position.y);
                mdvXLGrid.Invalidate;
                mdvXLGrid.UpdateScrollBars;
             end;
             VK_RIGHT: begin
                mdvXLGrid.SetSelectedAll(False);
                mdvXLGrid.LeftCol:= Max(0, PKolXLGridData(mdvXLGrid.FCustomObj).FColCount - mdvXLGrid.VisibleColCount);
                if RangeSelect then mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Position.x, mdvXLGrid.Selected.Top, PKolXLGridData(mdvXLGrid.FCustomObj).FColCount - 1, mdvXLGrid.Selected.Bottom)
                else mdvXLGrid.Position:= MakePoint(PKolXLGridData(mdvXLGrid.FCustomObj).FColCount - 1, mdvXLGrid.Position.y);
                mdvXLGrid.Invalidate;
                mdvXLGrid.UpdateScrollBars;
             end;
             VK_HOME: begin
                mdvXLGrid.SetSelectedAll(False);
                mdvXLGrid.LeftCol:= 0;
                mdvXLGrid.TopRow:= 0;
                if RangeSelect then mdvXLGrid.Selected:= MakeRect(0, 0, mdvXLGrid.Position.x, mdvXLGrid.Position.y)
                else mdvXLGrid.Position:= MakePoint(0, 0);
                mdvXLGrid.Invalidate;
                mdvXLGrid.UpdateScrollBars;
             end;
             VK_END: begin
                mdvXLGrid.SetSelectedAll(False);
                mdvXLGrid.LeftCol:= Max(0, PKolXLGridData(mdvXLGrid.FCustomObj).FColCount - mdvXLGrid.VisibleColCount);
                mdvXLGrid.TopRow:= Max(0, PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount - mdvXLGrid.VisibleRowCount);
                if RangeSelect then mdvXLGrid.Selected:= MakeRect(mdvXLGrid.Position.x, mdvXLGrid.Position.y, PKolXLGridData(mdvXLGrid.FCustomObj).FColCount - 1, PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount - 1)
                else mdvXLGrid.Position:= MakePoint(PKolXLGridData(mdvXLGrid.FCustomObj).FColCount - 1, PKolXLGridData(mdvXLGrid.FCustomObj).FRowCount-1);
                mdvXLGrid.Invalidate;
                mdvXLGrid.UpdateScrollBars;
             end;
          end;
      end;
      WM_PAINT: Begin
        if mdvXLGrid.fUpdCount>0 then Exit;
        if Msg.wParam = 0 then k:= BeginPaint(Sender.Handle, PaintStruct) else k:= Msg.wParam;
        mdvXLGrid.Paint(K);
        if Msg.wParam = 0 then EndPaint(Sender.Handle, PaintStruct);
        Result:= True;
        Rslt:= 0;
      end;
      WM_SIZE: mdvXLGrid.UpdateScrollBars;
    end;
end;

function NewmdvXLGrid(AParent: PControl; AColCount, ARowCount: Integer; AGridStyle: TmdvGridStyle; AOptions: TxlgOptions): PmdvXLGrid;
begin
    Result:= PmdvXLGrid(_NewControl(AParent, 'mdvGrid', WS_CHILD or WS_CLIPCHILDREN or
                                      WS_CLIPSIBLINGS or WS_TABSTOP or WS_BORDER or
                                      WS_VSCROLL or WS_HSCROLL or WS_VISIBLE,
                                      True, nil));

    Result.ClsStyle:= CS_VREDRAW + CS_HREDRAW + CS_DBLCLKS;
    Result.InitCustomData;
    Result.ColCount:= AColCount;
    Result.RowCount:= ARowCount;
    Result.Options:= AOptions;
    Result.GridStyle:= AGridStyle;
    PKolXLGridData(Result.FCustomObj).FSelected:= MakeRect(-1, -1, -1, -1);
    PKolXLGridData(Result.FCustomObj).FPosition:= MakePoint(0, 0); Result.Position:= MakePoint(0, 0);
    Result.AttachProc(WndProcmdvXLGrid);
end;

procedure TmdvXLGrid.BeginEdit;
var Indents, R: TRect;
begin
    if PKolXLGridData(FCustomObj).FShowEditor <> nil then Exit;
    PKolXLGridData(FCustomObj).FShowEditor:= nil; PKolXLGridData(FCustomObj).FShowEditor:= nil;
    Indents:= MakeRect(0, 0, 0, 0);
    if Assigned(PKolXLGridData(FCustomObj).FOnBeginEdit) then PKolXLGridData(FCustomObj).FOnBeginEdit(@Self, Position.X, Position.Y, PKolXLGridData(FCustomObj).FShowEditor, PKolXLGridData(FCustomObj).FTextEditor, Indents);
    if PKolXLGridData(FCustomObj).FShowEditor<> nil then begin
      if PKolXLGridData(FCustomObj).FTextEditor = nil then PKolXLGridData(FCustomObj).FTextEditor:= PKolXLGridData(FCustomObj).FShowEditor;
      PKolXLGridData(FCustomObj).FTextEditor.Font.Assign(Cells[Position.X, Position.Y].Font);
      Windows.SetParent(PKolXLGridData(FCustomObj).FShowEditor.Handle, Handle);
      R:= CellToRect(Position.X, Position.Y);
      R:= MakeRect(R.Left+Indents.Left, R.Top+Indents.Top, R.Right-Indents.Right, R.Bottom-Indents.Bottom);
      PKolXLGridData(FCustomObj).FShowEditor.BoundsRect:= R;
      SetWindowText(PKolXLGridData(FCustomObj).FTextEditor.Handle, PChar(Cells[Position.X, Position.Y].Text));
      PKolXLGridData(FCustomObj).FShowEditor.Visible:= True;
      Windows.SetFocus(PKolXLGridData(FCustomObj).FTextEditor.Handle);
      if PKolXLGridData(FCustomObj).FDefEditorEvents then begin
        PKolXLGridData(FCustomObj).FTextEditor.OnLeave:= OnEditorExit;
        PKolXLGridData(FCustomObj).FTextEditor.OnKeyDown:= OnEditorKeyDown;
      end;
    end;
end;

function TmdvXLGrid.CellToRect(ACol, ARow: Integer): TRect;
var i: Integer;
begin
    Result:= MakeRect(PKolXLGridData(FCustomObj).FTitleColWidth, PKolXLGridData(FCustomObj).FTitleRowHeight, PKolXLGridData(FCustomObj).FTitleColWidth, PKolXLGridData(FCustomObj).FTitleRowHeight);
    if (ACol<0) or (ACol>=PKolXLGridData(FCustomObj).FColCount) or (ARow<0) or (ARow>= PKolXLGridData(FCustomObj).FRowCount) then Exit;

    if PKolXLGridData(FCustomObj).FTopRow<=ARow then
      for i:= PKolXLGridData(FCustomObj).FTopRow to ARow - 1 do Result.Top:= Result.Top + RowHeights[i]
    else
      for i:= ARow to PKolXLGridData(FCustomObj).FTopRow - 1 do Result.Top:= Result.Top - RowHeights[i];

    if PKolXLGridData(FCustomObj).FLeftCol<= ACol then
      for i:= PKolXLGridData(FCustomObj).FLeftCol to ACol - 1 do Result.Left:= Result.Left + ColWidths[i]
    else
      for i:= ACol to PKolXLGridData(FCustomObj).FLeftCol - 1 do Result.Left:= Result.Left - ColWidths[i];

    Result.Bottom:= Result.Top;
    for i:= ARow to ARow + Cells[ACol, ARow].FBoundsHeight do
      Result.Bottom:= Result.Bottom + RowHeights[i];

    Result.Right:= Result.Left;
    for i:= ACol to ACol + Cells[ACol, ARow].FBoundsWidth do
      Result.Right:= Result.Right + ColWidths[i];
end;

{$IFDEF Sizing}
procedure TmdvXLGrid.ChangeCursor(Cur: Integer);
begin
    if not PKolXLGridData(FCustomObj).FCursorChanged then PKolXLGridData(FCustomObj).FDefaultCursor:= Cursor;
    {$IFDEF ColSizing} if Cur = 1 then Cursor:= PKolXLGridData(FCustomObj).FCursor_hSplit; {$ENDIF}
    {$IFDEF RowSizing} if Cur = 2 then Cursor:= PKolXLGridData(FCustomObj).FCursor_vSplit; {$ENDIF}
    PKolXLGridData(FCustomObj).FCursorChanged:= True;    
end;
{$ENDIF}

function TmdvXLGrid.EndEdit(ASave: Boolean; AEndEdit: Boolean = False): Boolean;
var S, SS: String;
    i: Integer;
    H: HWnd;
begin
    Result:= True;
    if (PKolXLGridData(FCustomObj).FShowEditor = nil) then Exit;
    if (PKolXLGridData(FCustomObj).FShowEditor.Visible) then begin
      if (PKolXLGridData(FCustomObj).FShowEditor = nil) then Exit;
      H:= GetFocus; for i:= 0 to PKolXLGridData(FCustomObj).FShowEditor.ChildCount-1 do if (PKolXLGridData(FCustomObj).FShowEditor.Children[i].Handle = H)and(H<>PKolXLGridData(FCustomObj).FTextEditor.Handle) then Exit;
      SetLength(S, 1024);
      SetLength(S, GetWindowText(PKolXLGridData(FCustomObj).FTextEditor.handle, PChar(S), 1024));
      if Assigned(PKolXLGridData(FCustomObj).FOnEndEdit) then PKolXLGridData(FCustomObj).FOnEndEdit(@Self, Position.X, Position.Y, PKolXLGridData(FCustomObj).FShowEditor, PKolXLGridData(FCustomObj).FTextEditor, S, Result);
      if not Result and not AEndEdit then Exit;
      if ASave and Result then begin
        SS:= Cells[Position.X, Position.Y].Text;
        Cells[Position.X, Position.Y].Text:= S;
        if Assigned(fOnChange) and (SS<>S) then fOnChange(@Self);
      end;
      if (PKolXLGridData(FCustomObj).FShowEditor <> nil) then PKolXLGridData(FCustomObj).FShowEditor.Visible:= False;
    end;
    PKolXLGridData(FCustomObj).FShowEditor:= nil;
    PKolXLGridData(FCustomObj).FTextEditor:= nil;
end;

function TmdvXLGrid.GetAlignmentHor: ThAlignmentText;
begin
    Result:= PKolXLGridData(FCustomObj).FAlignmentHor;
end;

function TmdvXLGrid.GetAlignmentVert: TvAlignmentText;
begin
    Result:= PKolXLGridData(FCustomObj).FAlignmentVert;
end;

function TmdvXLGrid.GetCells(Col, Row: Integer): PmdvXLCell;
begin
    Result:= PmdvXLCell(PList(PKolXLGridData(FCustomObj).FRows.Items[Row]).Items[Col]);
end;

function TmdvXLGrid.GetColCount: Word;
begin
    Result:= PKolXLGridData(FCustomObj).FColCount;
end;

function TmdvXLGrid.GetColor: TColor;
begin
    Result:= fColor;
end;

function TmdvXLGrid.GetColWidths(Index: Integer): Integer;
begin
    Result:= Integer(PKolXLGridData(FCustomObj).FColWidths.Items[Index])
end;

function TmdvXLGrid.GetCoord(Cell: PmdvXLCell): TPoint;
var i, j: Integer;
begin
    Result:= MakePoint(-1, -1);
    for i:= 0 to PKolXLGridData(FCustomObj).FRowCount - 1 do begin
      j:= PList(PKolXLGridData(FCustomObj).FRows.Items[i]).IndexOf(Cell);
      if j <> -1 then begin
        Result:= MakePoint(j, i);
        Break;
      end;
    end;
end;

function TmdvXLGrid.GetCountCol(ATop, ABottom, ACol: Integer): TPoint;
var i, j, C_1, C_2: Integer;
begin
    ACol:= Max(0, Min(ColCount-1, ACol));
    Result:= MakePoint(ACol, ACol);
    repeat
      C_1:= Result.x; C_2:= Result.y;
      for i:= ATop to ABottom do begin
        for j:= C_1 to C_2 do begin
          Result.x:= Min(j - Cells[j, i].FMergePos.x, Result.x);
          Result.y:= Max(Result.y, j - Cells[j, i].FMergePos.x + Cells[j - Cells[j, i].FMergePos.x, i].FBoundsWidth);
        end;
      end;
    until (C_1 = Result.x) and (C_2 = Result.y)
end;

function TmdvXLGrid.GetCountRow(ALeft, ARight, ARow: Integer): TPoint;
var i, j, R_1, R_2: Integer;
begin
    ARow:= Max(0, Min(RowCount-1, ARow));
    Result:= MakePoint(ARow, ARow);
    repeat
      R_1:= Result.x; R_2:= Result.y;
      for i:= ALeft to ARight do begin
        for j:= R_1 to R_2 do begin
          Result.x:= Min(Result.x, j - Cells[i, j].FMergePos.y);
          Result.y:= Max(Result.y, j - Cells[i, j].FMergePos.y + Cells[i, j - Cells[i, j].FMergePos.y].FBoundsHeight);
        end;
      end;
    until (R_1 = Result.x) and (R_2 = Result.y)
end;

function TmdvXLGrid.GetDefaultColWidth: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FDefaultColWidth;
end;

function TmdvXLGrid.GetDefaultRowHeight: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FDefaultRowHeight;
end;

function TmdvXLGrid.GetGridStyle: TmdvGridStyle;
begin
    Result:= PKolXLGridData(FCustomObj).FGridStyle;
end;

function TmdvXLGrid.GetIndentBottom: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FIndent.Bottom;
end;

function TmdvXLGrid.GetIndentLeft: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FIndent.Left;
end;

function TmdvXLGrid.GetIndentRight: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FIndent.Right;
end;

function TmdvXLGrid.GetIndentTop: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FIndent.Top;
end;

function TmdvXLGrid.GetLeftCol: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FLeftCol;
end;

function TmdvXLGrid.GetLineColor: TColor;
begin
    Result:= PKolXLGridData(FCustomObj).FLineColor;
end;

function TmdvXLGrid.GetLineWidthBottom: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FLineWidth.Bottom;
end;

function TmdvXLGrid.GetLineWidthLeft: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FLineWidth.Left;
end;

function TmdvXLGrid.GetLineWidthRight: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FLineWidth.Right;
end;

function TmdvXLGrid.GetLineWidthTop: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FLineWidth.Top;
end;

function TmdvXLGrid.GetOnBeginEdit: TOnBeginEdit;
begin
    Result:= PKolXLGridData(FCustomObj).FOnBeginEdit;
end;

function TmdvXLGrid.GetOnFocusChange: TOnFocusChange;
begin
    Result:= PKolXLGridData(FCustomObj).FOnFocusChange;
end;

function TmdvXLGrid.GetOnMoved: TOnMoved;
begin
    Result:= PKolXLGridData(FCustomObj).FOnMoved;
end;

function TmdvXLGrid.GetOnSized: TOnSized;
begin
    Result:= PKolXLGridData(FCustomObj).FOnSized;
end;

function TmdvXLGrid.GetOptions: TxlgOptions;
begin
    Result:= PKolXLGridData(FCustomObj).FOptions;
end;

function TmdvXLGrid.GetPosition: TPoint;
begin
    Result:= PKolXLGridData(FCustomObj).FPosition;
end;

function TmdvXLGrid.GetRowCount: Word;
begin
    Result:= PKolXLGridData(FCustomObj).FRowCount;
end;

function TmdvXLGrid.GetRowHeights(Index: Integer): Integer;
begin
    Result:= Integer(PKolXLGridData(FCustomObj).FRowHeights.Items[Index])
end;

function TmdvXLGrid.GetSelected: TRect;
begin
    if (xlgRangeSelect in Options) then Result:= PKolXLGridData(FCustomObj).FSelected else Result:= MakeRect(Position.X, Position.Y, Position.X, Position.Y);
end;

function TmdvXLGrid.GetSelectedColor: TColor;
begin
    Result:= PKolXLGridData(FCustomObj).FSelectedColor;
end;

function TmdvXLGrid.GetSelectedCols(Index: Integer): Boolean;
begin
    {$IFDEF ColsSelect} Result:= Integer(PKolXLGridData(FCustomObj).FSelectedCols.Items[Index]) > 0; {$ELSE} Result:= False; {$ENDIF}
end;

function TmdvXLGrid.GetSelectedRows(Index: Integer): Boolean;
begin
    {$IFDEF RowsSelect} Result:= Integer(PKolXLGridData(FCustomObj).FSelectedRows.Items[Index]) > 0; {$ELSE} Result:= False; {$ENDIF}
end;

function TmdvXLGrid.GetTitleColor: TColor;
begin
    Result:= PKolXLGridData(FCustomObj).FTitleColor;
end;

function TmdvXLGrid.GetTitleCols(Index: Integer): String;
begin
    if (Index>=0)and(Index<PKolXLGridData(FCustomObj).FTitleCol.Count) then Result:= PKolXLGridData(FCustomObj).FTitleCol.Items[Index] else Result:= '';
end;

function TmdvXLGrid.GetTitleColWidth: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FTitleColWidth;
end;

function TmdvXLGrid.GetTitleFont: PGraphicTool;
begin
    Result:= PKolXLGridData(FCustomObj).FTitleFont;
end;

function TmdvXLGrid.GetTitleRowHeight: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FTitleRowHeight;
end;

function TmdvXLGrid.GetTitleRows(Index: Integer): String;
begin
    Result:= PKolXLGridData(FCustomObj).FTitleRow.Items[Index];
end;

function TmdvXLGrid.GetTitleSelectedColor: TColor;
begin
    {$IFDEF Select} Result:= PKolXLGridData(FCustomObj).FTitleSelectedColor; {$ELSE} Result:= PKolXLGridData(FCustomObj).FTitleColor; {$ENDIF}
end;

function TmdvXLGrid.GetTitleSelectedFontColor: TColor;
begin
    {$IFDEF Select} Result:= PKolXLGridData(FCustomObj).FTitleSelectedFontColor; {$ELSE} Result:= PKolXLGridData(FCustomObj).FTitleFont.Color; {$ENDIF}
end;

function TmdvXLGrid.GetTopRow: Integer;
begin
    Result:= PKolXLGridData(FCustomObj).FTopRow;
end;

function TmdvXLGrid.GetVisibleColCount: Integer;
var i, L: Integer;
begin
    L:= TitleColWidth;
    i:= LeftCol;
    while i < ColCount do begin
      if (ClientWidth <= L + ColWidths[i]) then Break;
      L:= L + ColWidths[i];
      inc(i);
    end;
    Result:= Max(1, i - LeftCol);
end;

function TmdvXLGrid.GetVisibleRowCount: Integer;
var T, i: Integer;
begin
    T:= TitleRowHeight;
    i:= TopRow;
    while i < RowCount do begin
      if (ClientHeight <= T + RowHeights[i]) then Break;
      T:= T + RowHeights[i];
      inc(i);
    end;
    Result:= Max(1, i - TopRow);
end;

function TmdvXLGrid.GetIsCellSelected(Col, Row: Integer): Boolean;
begin
    Result:= {$IFDEF ColsSelect} (Integer(PKolXLGridData(FCustomObj).FSelectedCols.Items[Col]) > 0) or {$ENDIF} {$IFDEF RowsSelect} (Integer(PKolXLGridData(FCustomObj).FSelectedRows.Items[Row]) > 0) or {$ENDIF} (Cells[Col, Row].FSelected>0);
end;

type TObjectsChange = (ocFont, ocTitleFont, ocSelectedFont);

procedure TmdvXLGrid.GraphicChange(Sender: PGraphicTool);
var i, j: Integer;
begin
    case Sender.Tag of
     Integer(ocFont): begin
        BeginUpdate;
        for i:= 0 to ColCount-1 do for j:= 0 to RowCount-1 do Cells[i,j].Font.Assign(Font);
        EndUpdate;
     end;
     Integer(ocTitleFont): begin
        BeginUpdate;
        EndUpdate;
     end;
     Integer(ocSelectedFont): begin
        Invalidate;
     end;
    end;
end;

function TmdvXLGrid.HasMerge(ARect: TRect): Boolean;
var i, j: Integer;
begin
    Result:= False;
    for i:= Max(0, ARect.Top) to Max(0, ARect.Bottom) do
      for j:= Max(0, ARect.Left) to Max(0, ARect.Right) do
        if Cells[j, i].FIsMerge then begin
          Result:= True; Break;
        end;
end;

procedure TmdvXLGrid.InitCustomData;
var P: PKolXLGridData;
begin
    New(P, Create); FCustomObj:= P; P.FGrid:= @Self;
    LookTabKeys:= [tkTab];
    IgnoreDefault:= True;
    Font.Tag:= Integer(ocFont); Font.OnChange:= GraphicChange;

    {$IFDEF ColSizing} PKolXLGridData(FCustomObj).FCursor_hSplit:= LoadCursor(HInstance, IDC_HSPLIT); {$ENDIF}
    {$IFDEF RowSizing} PKolXLGridData(FCustomObj).FCursor_vSplit:= LoadCursor(HInstance, IDC_VSPLIT); {$ENDIF}

    PKolXLGridData(FCustomObj).FSelectedFontColor:= DefSelectedFontColor;
    PKolXLGridData(FCustomObj).FSelectedColorLine:= DefSelectedColorLine;
    PKolXLGridData(FCustomObj).FSelectedColor:= DefSelectedColor;
    PKolXLGridData(FCustomObj).FPaintBmp:= NewBitmap(ClientWidth, ClientHeight);
    {$IFDEF Moving} PKolXLGridData(FCustomObj).ilMoving:= NewDragImageList(@Self); {$ENDIF}

    PKolXLGridData(FCustomObj).FDrawStates:= [];

    PKolXLGridData(FCustomObj).FDefaultColWidth:= DefDefaultColWidth;
    PKolXLGridData(FCustomObj).FDefaultRowHeight:= DefDefaultRowHeight;
    PKolXLGridData(FCustomObj).FColWidths:= NewList;
    PKolXLGridData(FCustomObj).FRowHeights:= NewList;
    PKolXLGridData(FCustomObj).FRows:= NewList;

    PKolXLGridData(FCustomObj).FTitleColWidth:= DefTitleColWidth;
    PKolXLGridData(FCustomObj).FTitleRowHeight:= DefTitleRowHeight;
    PKolXLGridData(FCustomObj).FTitleFont:= NewFont; PKolXLGridData(FCustomObj).FTitleFont.Tag:= Integer(ocTitleFont); PKolXLGridData(FCustomObj).FTitleFont.OnChange:= GraphicChange;
    PKolXLGridData(FCustomObj).FTitleCol:= NewStrList; PKolXLGridData(FCustomObj).FTitleRow:= NewStrList;
    {$IFDEF Select} PKolXLGridData(FCustomObj).FTitleSelectedColor:= DefTitleSelectedColor; {$ENDIF}
    {$IFDEF Select} PKolXLGridData(FCustomObj).FTitleSelectedFontColor:= DefTitleSelectedFontColor; {$ENDIF}
    PKolXLGridData(FCustomObj).FTitleColor:= DefTitleColor;
    {$IFDEF RowButton} PKolXLGridData(FCustomObj).FTitleRowButton:= DefTitleRowButton; {$ENDIF}
    {$IFDEF ColButton} PKolXLGridData(FCustomObj).FTitleColButton:= DefTitleColButton; {$ENDIF}
    PKolXLGridData(FCustomObj).FColButton:= -1; PKolXLGridData(FCustomObj).FRowButton:= -1;

    {$IFDEF ColsSelect} PKolXLGridData(FCustomObj).FSelectedCols:= NewList; {$ENDIF}
    {$IFDEF RowsSelect} PKolXLGridData(FCustomObj).FSelectedRows:= NewList; {$ENDIF}
    PKolXLGridData(FCustomObj).FFirstSelectRows:= -1; PKolXLGridData(FCustomObj).FFirstSelectCols:= -1;
    {$IFDEF ColSizing} PKolXLGridData(FCustomObj).FResizeCol:= -1; PKolXLGridData(FCustomObj).FNewSizeCol:= -1; {$ENDIF}
    {$IFDEF RowSizing} PKolXLGridData(FCustomObj).FResizeRow:= -1;PKolXLGridData(FCustomObj).FNewSizeRow:= -1; {$ENDIF}
    {$IFDEF Sizing} PKolXLGridData(FCustomObj).FResizeSensitivity:= DefResizeSensitivity; {$ENDIF}
    {$IFDEF Sizing} PKolXLGridData(FCustomObj).FCursorChanged:= False; {$ENDIF}
    {$IFDEF ColMoving} PKolXLGridData(FCustomObj).FMovingCol:= -1; {$ENDIF}
    {$IFDEF RowMoving} PKolXLGridData(FCustomObj).FMovingRow:= -1; {$ENDIF}
    PKolXLGridData(FCustomObj).FSelectedStart:= MakePoint(-1, -1);
    PKolXLGridData(FCustomObj).FTopRow:= 0; PKolXLGridData(FCustomObj).FLeftCol:= 0;
    PKolXLGridData(FCustomObj).FGridStyle:= gsStandard;

    PKolXLGridData(FCustomObj).FLineColor:= DefLineColor;
    PKolXLGridData(FCustomObj).FLineWidth.Left:= DefLineWidthLeft; PKolXLGridData(FCustomObj).FLineWidth.Right:= DefLineWidthRight; PKolXLGridData(FCustomObj).FLineWidth.Top:= DefLineWidthTop; PKolXLGridData(FCustomObj).FLineWidth.Bottom:= DefLineWidthBottom;
    PKolXLGridData(FCustomObj).FIndent.Left:= DefIndentLeft; PKolXLGridData(FCustomObj).FIndent.Right:= DefIndentRight; PKolXLGridData(FCustomObj).FIndent.Top:= DefIndentTop; PKolXLGridData(FCustomObj).FIndent.Bottom:= DefIndentBottom;
    PKolXLGridData(FCustomObj).FAlignmentHor:= DefAlignmentHor;
    PKolXLGridData(FCustomObj).FAlignmentVert:= DefAlignmentVert;

    FColor:= DefColor;

    PKolXLGridData(FCustomObj).FOnBeginEdit:= nil; PKolXLGridData(FCustomObj).FOnEndEdit:= nil;
    PKolXLGridData(FCustomObj).FOnFocusChange:= nil; PKolXLGridData(FCustomObj).FOnSelectedChange:= nil;
    PKolXLGridData(FCustomObj).FOnMoved:= nil; PKolXLGridData(FCustomObj).FOnSized:= nil;
    PKolXLGridData(FCustomObj).FOnButtonDown:= nil;
    PKolXLGridData(FCustomObj).FOnDrawCell:= nil; PKolXLGridData(FCustomObj).FOnDrawTitle:= nil;
    PKolXLGridData(FCustomObj).FDefEditorEvents:= True;
end;

function TmdvXLGrid.IsMerge(APos: TPoint): Boolean;
begin
    Result:= False;
    if APos.X = -1 then Exit;
    Result:= Cells[APos.X, APos.Y].FIsMerge;
end;

procedure TmdvXLGrid.Merge(ARect: TRect);
var i, j: Integer;
begin
    if ((ARect.Top = ARect.Bottom)and(ARect.Left = ARect.Right)) or HasMerge(ARect) then Exit;
    BeginUpdate;
    EndEdit(True, True);
    for i:= ARect.Top to ARect.Bottom do begin
      for j:= ARect.Left to ARect.Right do begin
        Cells[j, i].FIsMerge:= True;
        if (i = ARect.Top) and (j = ARect.Left) then begin
          Cells[j, i].FShow:= True;
          Cells[j, i].FBoundsWidth:= ARect.Right - ARect.Left;
          Cells[j, i].FBoundsHeight:= ARect.Bottom - ARect.Top;
        end
        else begin
          Cells[j, i].FShow:= False;
          Cells[j, i].FMergePos:= MakePoint(j - ARect.Left, i - ARect.Top);
        end;
      end
    end;
    EndUpdate;
end;

function TmdvXLGrid.MouseToCell(X, Y: Integer): TPoint;
begin
    Result:= MakePoint(MouseToCol(X), MouseToRow(Y));
end;

function TmdvXLGrid.MouseToCol(X: Integer): Integer;
var i, L: Integer;
begin
    Result:= -1;
    L:= PKolXLGridData(FCustomObj).FTitleColWidth;
    for i:= PKolXLGridData(FCustomObj).FLeftCol to PKolXLGridData(FCustomObj).FColCount-1 do begin
      if (X >= L)and(X <= L + ColWidths[i]) then begin
        Result:= i;
        L:= L + ColWidths[i];
        Break;
      end;
      L:= L + ColWidths[i];
    end;
    if X > L then Result:= PKolXLGridData(FCustomObj).FColCount-1;
end;

function TmdvXLGrid.MouseToColBorder(X: Integer): Integer;
var i, L, C, S: Integer;
begin
    Result:= -1;
    if not (xlgColSizing in Options) then Exit;
    L:= PKolXLGridData(FCustomObj).FTitleColWidth;
    for i:= PKolXLGridData(FCustomObj).FLeftCol to PKolXLGridData(FCustomObj).FColCount-1 do begin
      C:= ColWidths[i];
      {$IFDEF Sizing} S:= Min(PKolXLGridData(FCustomObj).FResizeSensitivity, C div 3); {$ELSE} S:= 0; {$ENDIF}
      if PointInRect(MakePoint(X, 0), MakeRect(L+C-S, 0, L+C+S, 0)) then begin
        Result:= i;
        Break;
      end;
      L:= L + ColWidths[i];
    end;
end;

function TmdvXLGrid.MouseToRow(Y: Integer): Integer;
var i, T: Integer;
begin
    Result:= -1;
    T:= PKolXLGridData(FCustomObj).FTitleRowHeight;
    for i:= PKolXLGridData(FCustomObj).FTopRow to PKolXLGridData(FCustomObj).FRowCount-1 do begin
      if (Y >= T)and(Y <= T+RowHeights[i]) then begin
        Result:= i;
        T:= T + RowHeights[i];
        Break;
      end;
      T:= T + RowHeights[i];
    end;
    if Y > T then Result:= PKolXLGridData(FCustomObj).FRowCount-1;
end;

function TmdvXLGrid.MouseToRowBorder(Y: Integer): Integer;
var i, T, R, S: Integer;
begin
    Result:= -1;
    if not (xlgRowSizing in Options) then Exit;
    T:= PKolXLGridData(FCustomObj).FTitleRowHeight;
    for i:= PKolXLGridData(FCustomObj).FTopRow to PKolXLGridData(FCustomObj).FRowCount-1 do begin
      R:= RowHeights[i];
      {$IFDEF Sizing} S:= Min(PKolXLGridData(FCustomObj).FResizeSensitivity, R div 3); {$ELSE} S:= 0; {$ENDIF}
      if PointInRect(MakePoint(0, Y), MakeRect(0, T+R-S, 0, T+R+S)) then begin
        Result:= i;
        Break;
      end;
      T:= T + RowHeights[i];
    end;
end;

procedure TmdvXLGrid.MoveCol(Index, NewIndex: Integer);
var i: Integer;
    Cell: PmdvXLCell;
begin
    EndEdit(True, True);
    NewIndex:= Max(0, Min(PKolXLGridData(FCustomObj).FColCount-1, NewIndex));
    if (Index <> NewIndex) and not HasMerge(MakeRect(NewIndex, 0, NewIndex, PKolXLGridData(FCustomObj).FRowCount-1) ) then begin
      BeginUpdate;
      Cell:= Cells[Position.X, Position.Y];
      PKolXLGridData(FCustomObj).FTitleCol.Move(Index, NewIndex);
      PKolXLGridData(FCustomObj).FColWidths.MoveItem(Index, NewIndex);
      {$IFDEF ColsSelect} PKolXLGridData(FCustomObj).FSelectedCols.MoveItem(Index, NewIndex); {$ENDIF}
      for i:= 0 to PKolXLGridData(FCustomObj).FRows.Count-1 do PList(PKolXLGridData(FCustomObj).FRows.Items[i]).MoveItem(Index, NewIndex);
      PKolXLGridData(FCustomObj).FPosition:= MakePoint(PList(PKolXLGridData(FCustomObj).FRows.Items[Position.Y]).IndexOf(Cell), Position.Y);;
      PKolXLGridData(FCustomObj).FSelected:= MakeRect(-1, -1, -1, -1);
      if Assigned(PKolXLGridData(FCustomObj).FOnMoved) then PKolXLGridData(FCustomObj).FOnMoved(@Self, dCol, Index, NewIndex);
      EndUpdate;
    end;
end;

procedure TmdvXLGrid.MoveRow(Index, NewIndex: Integer);
var Cell: Pointer;
begin
    EndEdit(True, True);
    NewIndex:= Max(0, Min(PKolXLGridData(FCustomObj).FRowCount-1, NewIndex));
    if (Index <> NewIndex) and not HasMerge(MakeRect(0, NewIndex, PKolXLGridData(FCustomObj).FColCount-1, NewIndex) ) then begin
      BeginUpdate;
      Cell:= PKolXLGridData(FCustomObj).FRows.Items[Position.Y];
      PKolXLGridData(FCustomObj).FTitleRow.Move(Index, NewIndex);
      PKolXLGridData(FCustomObj).FRowHeights.MoveItem(Index, NewIndex);
      {$IFDEF RowsSelect} PKolXLGridData(FCustomObj).FSelectedRows.MoveItem(Index, NewIndex); {$ENDIF}
      PKolXLGridData(FCustomObj).FRows.MoveItem(Index, NewIndex);
      PKolXLGridData(FCustomObj).FPosition:= MakePoint(Position.X, PKolXLGridData(FCustomObj).FRows.IndexOf(Cell));
      PKolXLGridData(FCustomObj).FSelected:= MakeRect(-1, -1, -1, -1);
      if Assigned(PKolXLGridData(FCustomObj).FOnMoved) then PKolXLGridData(FCustomObj).FOnMoved(@Self, dRow, Index, NewIndex);
      EndUpdate;
    end;
end;

procedure TmdvXLGrid.OnEditorExit(ASender: PObj);
begin
    EndEdit(True);
end;

procedure TmdvXLGrid.OnEditorKeyDown(ASender: PControl; var AKey: Integer; AShift: DWORD);
begin
    case AKey of
      VK_RETURN, VK_F2: begin
        if EndEdit(True) then Windows.SetFocus(Handle);
      end;
      VK_ESCAPE: begin
        if EndEdit(False) then Windows.SetFocus(Handle);
      end;
    end;
end;

procedure TmdvXLGrid.Paint(DC: HDC);
procedure FillRect(ACanvas: PCanvas; AColor: TColor; ARect: TRect);
begin
    ACanvas.Brush.Color:= AColor; ACanvas.Brush.BrushStyle:= bsSolid; ACanvas.FillRect(ARect);
end;

procedure DrawFixeds(ACanvas: PCanvas; var ARect: TRect; AFirst, ALast, ANewSize, AResize, APosition, AButton: Integer;
                     ATitleButton: Boolean; ASizeList, ASelectedList: PList; ATitle: PStrList;
                     var AIncL, AIncR: Integer; AIsCol: Boolean);
var R: TRect;
    i, B, Clr, Cl, Rw: Integer;
    S: Boolean;
    Access: Boolean;
begin
      for i:= AFirst to ALast do begin
        if (ANewSize<>-1) and (AResize = i) then AIncR:= AIncL + ANewSize else AIncR:= AIncL + Integer(ASizeList.Items[i]);
        R:= ARect;
        if ASelectedList<>nil then S:= Integer(ASelectedList.Items[i]) > 0 else S:= False;
        Clr:= PKolXLGridData(FCustomObj).FTitleColor;
        if ATitleButton or not S then begin
          ACanvas.Font.Color:= PKolXLGridData(FCustomObj).FTitleFont.Color;
          if APosition = i then ACanvas.Font.FontStyle:= ACanvas.Font.FontStyle + [fsBold] else ACanvas.Font.FontStyle:= ACanvas.Font.FontStyle - [fsBold];
          if (AButton = i) and (dsButtonDown in PKolXLGridData(FCustomObj).FDrawStates) then begin
            inc(R.Left, 2); inc(R.Top, 2); B:= BDR_SUNKENINNER;
          end
          else if APosition = i then B:= BDR_RAISEDINNER or BDR_RAISEDOUTER else B:= BDR_RAISEDINNER;
        end
        else begin
          {$IFDEF Select}
          Clr:= PKolXLGridData(FCustomObj).FTitleSelectedColor;
          ACanvas.Font.Color:= PKolXLGridData(FCustomObj).FTitleSelectedFontColor;
          ACanvas.Font.FontStyle:= ACanvas.Font.FontStyle + [fsBold];
          {$ENDIF}
          B:= BDR_SUNKENOUTER;
        end;
        FillRect(ACanvas, Clr, ARect);
        ACanvas.RequiredState(HandleValid or ChangingCanvas or BrushValid or FontValid or PenValid);
        DrawText(ACanvas.Handle, PChar(ATitle.Items[i]), -1, ARect, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
        DrawEdge(ACanvas.Handle, ARect, B, BF_RECT);


        if Assigned(PKolXLGridData(FCustomObj).FOnDrawTitle) then begin
          Cl:= -1; Rw:= -1;
          if AIsCol then Cl:= i else Rw:= i;
          PKolXLGridData(FCustomObj).FOnDrawTitle(@Self, Cl, Rw, nil, ACanvas, ARect, S, S, Access);
        end;
        AIncL:= AIncR;
      end;
end;

procedure DrawFixed(ACanvas: PCanvas);
var Rect: TRect;
    B, Clr: Integer;
    Last: Integer;
    Access: Boolean;
begin
    if (ColCount = 0)or(RowCount = 0) then Exit;

    if (PKolXLGridData(FCustomObj).FTitleColWidth > 0) and (PKolXLGridData(FCustomObj).FTitleRowHeight > 0) then begin
      Rect:= ClientRect; Rect.Right:= Rect.Left + PKolXLGridData(FCustomObj).FTitleColWidth; Rect.Bottom:= Rect.Top + PKolXLGridData(FCustomObj).FTitleRowHeight;
      Access:= False;
      Clr:= PKolXLGridData(FCustomObj).FTitleColor; B:= BDR_RAISEDINNER;
      if dsDeadDown in PKolXLGridData(FCustomObj).FDrawStates then
      begin {$IFDEF Select} Clr:= PKolXLGridData(FCustomObj).FTitleSelectedColor; B:= BDR_SUNKENOUTER; {$ENDIF} end;
      FillRect(ACanvas, Clr, Rect);
      ACanvas.RequiredState(HandleValid or ChangingCanvas or BrushValid or FontValid or PenValid);
      DrawEdge(ACanvas.Handle, Rect, B, BF_RECT);
      if Assigned(PKolXLGridData(FCustomObj).FOnDrawTitle) then PKolXLGridData(FCustomObj).FOnDrawTitle(@Self, -1, -1, nil, ACanvas, Rect, dsDeadDown in PKolXLGridData(FCustomObj).FDrawStates, dsDeadDown in PKolXLGridData(FCustomObj).FDrawStates, Access);
    end;

    ACanvas.Font.Assign(PKolXLGridData(FCustomObj).FTitleFont);

    if PKolXLGridData(FCustomObj).FTitleRowHeight > 0 then begin
      Rect:= ClientRect; Rect.Left:= Rect.Left + PKolXLGridData(FCustomObj).FTitleColWidth; Rect.Bottom:= Rect.Top + PKolXLGridData(FCustomObj).FTitleRowHeight;
      {$IFDEF ColSizing}if PKolXLGridData(FCustomObj).FResizeCol <> -1 then Last:= ColCount-1 else {$ENDIF}Last:= Min(ColCount-1, LeftCol + VisibleColCount);
      DrawFixeds(ACanvas, Rect, PKolXLGridData(FCustomObj).FLeftCol, Last,
                 {$IFDEF ColSizing}PKolXLGridData(FCustomObj).FNewSizeCol{$ELSE}-1{$ENDIF}, {$IFDEF ColSizing}PKolXLGridData(FCustomObj).FResizeCol{$ELSE}-1{$ENDIF},
                 Position.x, PKolXLGridData(FCustomObj).FRowButton, {$IFDEF RowButton} PKolXLGridData(FCustomObj).FTitleRowButton{$ELSE}False{$ENDIF},
                 PKolXLGridData(FCustomObj).FColWidths, {$IFDEF ColsSelect} PKolXLGridData(FCustomObj).FSelectedCols{$ELSE}nil{$ENDIF},
                 PKolXLGridData(FCustomObj).FTitleCol,
                 Rect.Left, Rect.Right, True);
    end;

    if (PKolXLGridData(FCustomObj).FTitleColWidth > 0) then begin
      Rect:= ClientRect; Rect.Right:= Rect.Left + PKolXLGridData(FCustomObj).FTitleColWidth; Rect.Top:= Rect.Top + PKolXLGridData(FCustomObj).FTitleRowHeight;
      {$IFDEF RowSizing}if PKolXLGridData(FCustomObj).FResizeRow <> -1 then Last:= PKolXLGridData(FCustomObj).FRowCount-1 else {$ENDIF}Last:= Min(PKolXLGridData(FCustomObj).FRowCount-1, PKolXLGridData(FCustomObj).FTopRow + VisibleRowCount);
      DrawFixeds(ACanvas, Rect, PKolXLGridData(FCustomObj).FTopRow, Last,
                 {$IFDEF RowSizing}PKolXLGridData(FCustomObj).FNewSizeRow{$ELSE}-1{$ENDIF}, {$IFDEF RowSizing}PKolXLGridData(FCustomObj).FResizeRow{$ELSE}-1{$ENDIF},
                 Position.y, PKolXLGridData(FCustomObj).FColButton, {$IFDEF ColButton} PKolXLGridData(FCustomObj).FTitleColButton{$ELSE}False{$ENDIF},
                 PKolXLGridData(FCustomObj).FRowHeights, {$IFDEF RowsSelect} PKolXLGridData(FCustomObj).FSelectedRows{$ELSE}nil{$ENDIF},
                 PKolXLGridData(FCustomObj).FTitleRow,
                 Rect.Top, Rect.Bottom, False);
    end;
end;

procedure DrawCells(ACanvas: PCanvas);
var R: TRect;
    j, i, Row, Col: Integer;
begin
    if (ColCount = 0)or(RowCount = 0) then Exit;
    for i:= PKolXLGridData(FCustomObj).FTopRow to Min(PKolXLGridData(FCustomObj).FRowCount-1, PKolXLGridData(FCustomObj).FTopRow + VisibleRowCount) do begin
      for j:= PKolXLGridData(FCustomObj).FLeftCol to Min(PKolXLGridData(FCustomObj).FColCount-1, PKolXLGridData(FCustomObj).FLeftCol + VisibleColCount) do begin
        Col:= j - Cells[j, i].FMergePos.X; Row:= i - Cells[j, i].FMergePos.Y;
        R:= CellToRect(Col, Row);
        Cells[Col, Row].Draw(R, Col, Row, ACanvas, IsCellSelected[Col, Row], False);
      end;
    end;
end;

procedure DrawSelect(ACanvas: PCanvas);
var Rect, R: TRect;
    {$IFDEF Sizing} i: Integer; {$ENDIF}
    {$IFDEF ColSizing} H: Integer; {$ENDIF} {$IFDEF RowSizing} V: Integer; {$ENDIF}
begin
    if (ColCount = 0)or(RowCount = 0) then Exit;

    Rect:= ClientRect;
    {$IFDEF RowSizing}
    if PKolXLGridData(FCustomObj).FResizeRow <> -1 then begin
      V:= Rect.Top + PKolXLGridData(FCustomObj).FTitleRowHeight;
      for i:= PKolXLGridData(FCustomObj).FTopRow to Min(PKolXLGridData(FCustomObj).FRowCount-1, PKolXLGridData(FCustomObj).FTopRow + VisibleRowCount) do begin
        if PKolXLGridData(FCustomObj).FResizeRow = i then Break;
        V:= V + RowHeights[i];
      end;
    end else V:= -1;
    {$ENDIF}
    {$IFDEF ColSizing}
    if PKolXLGridData(FCustomObj).FResizeCol <> -1 then begin
      H:= Rect.Left + PKolXLGridData(FCustomObj).FTitleColWidth;
      for i:= LeftCol to Min(ColCount-1, LeftCol + VisibleColCount) do begin
        if PKolXLGridData(FCustomObj).FResizeCol = i then Break;
        H:= H + ColWidths[i];
      end;
    end else H:= -1;
    {$ENDIF}
    if Selected.Right = -1 then R:= CellToRect(Position.x, Position.y) else begin
      R:= CellToRect(Selected.Left, Selected.Top);
      Rect:= CellToRect(Selected.Right, Selected.Bottom);
      R.Right:= Rect.Right; R.Bottom:= Rect.Bottom; InflateRect(R, 1, 1);
    end;
    Rect:= CellToRect(Position.x, Position.y);

    if GridStyle = gsXL then begin
      Cells[Position.x, Position.y].Draw(Rect, Position.x, Position.y, ACanvas, IsCellSelected[Position.x, Position.y], True);
      ACanvas.Pen.PenWidth:= 5;
      ACanvas.Pen.PenMode:= pmNot;
      ACanvas.Brush.BrushStyle:= bsClear;
//      inc(R.Right, 1); inc(R.Bottom, 1);
      ACanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
    end
    else begin
      if (Selected.Left <> Selected.Right)or(Selected.Top <> Selected.Bottom) then begin
        ACanvas.Brush.BrushStyle:= bsSolid;
        ACanvas.Brush.Color:= PKolXLGridData(FCustomObj).FSelectedColorLine;
        dec(R.Right, 1); dec(R.Bottom, 1); inc(R.Top, 2); inc(R.Left, 2);
        FrameRect(ACanvas.Handle, R, ACanvas.Brush.Handle);
      end;
      Cells[Position.x, Position.y].Draw(Rect, Position.x, Position.y, ACanvas, IsCellSelected[Position.x, Position.y], True);
    end;

    ACanvas.Brush.Color:= FColor; ACanvas.Brush.BrushStyle:= bsSolid;
    {$IFDEF ColSizing}
    if (PKolXLGridData(FCustomObj).FNewSizeCol<>-1) and (H<>-1) then begin
      Rect:= MakeRect(H, -1, H+1 + PKolXLGridData(FCustomObj).FNewSizeCol, -1 + Height+1);
      ACanvas.DrawFocusRect(Rect);
    end;
    {$ENDIF}
    {$IFDEF RowSizing}
    if (PKolXLGridData(FCustomObj).FNewSizeRow<>-1) and (V<>-1) then begin
      Rect:= MakeRect(-1, V, -1 + Width+1, V+1 + PKolXLGridData(FCustomObj).FNewSizeRow);
      ACanvas.DrawFocusRect(Rect);
    end;
    {$ENDIF}
end;
begin
    PKolXLGridData(FCustomObj).FPaintBmp.Width:= ClientWidth; PKolXLGridData(FCustomObj).FPaintBmp.Height:= ClientHeight;
    FillRect(PKolXLGridData(FCustomObj).FPaintBmp.Canvas, Color, ClientRect);
    DrawCells(PKolXLGridData(FCustomObj).FPaintBmp.Canvas);
    DrawSelect(PKolXLGridData(FCustomObj).FPaintBmp.Canvas);
    DrawFixed(PKolXLGridData(FCustomObj).FPaintBmp.Canvas);
    BitBlt(DC, 0, 0, ClientWidth, ClientHeight, PKolXLGridData(FCustomObj).FPaintBmp.Canvas.Handle, 0, 0, SRCCOPY);
end;
{$IFDEF Sizing}
procedure TmdvXLGrid.RestoreCursor;
begin
    if not PKolXLGridData(FCustomObj).FCursorChanged then Exit;
    Cursor:= PKolXLGridData(FCustomObj).FDefaultCursor;
    PKolXLGridData(FCustomObj).FCursorChanged:= False;
end;
{$ENDIF}
procedure TmdvXLGrid.SetAlignmentHor(const Value: ThAlignmentText);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FAlignmentHor := Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do for j:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do Cells[i,j].HAlignment:= Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetAlignmentVert(const Value: TvAlignmentText);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FAlignmentVert := Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do for j:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do Cells[i,j].VAlignment:= Value;
    EndUpdate;
end;

{procedure TmdvXLGrid.SetBorderStyle(const Value: TBorderStyle);
begin
  FBorderStyle := Value;
end;
}
procedure TmdvXLGrid.SetColCount(const Value: Word);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FPosition:= MakePoint(Min(Position.X, Value-1), Position.Y);
    PKolXLGridData(FCustomObj).FColCount := Value;
    for i:= PKolXLGridData(FCustomObj).FTitleCol.Count to Value-1 do PKolXLGridData(FCustomObj).FTitleCol.Add('');
    if PKolXLGridData(FCustomObj).FTitleCol.Count > Value then
      for i:= PKolXLGridData(FCustomObj).FTitleCol.Count downto Value+1 do PKolXLGridData(FCustomObj).FTitleCol.Delete(i-1);

    for i:= PKolXLGridData(FCustomObj).FColWidths.Count to Value-1 do PKolXLGridData(FCustomObj).FColWidths.Add(Pointer(DefaultColWidth));
    if PKolXLGridData(FCustomObj).FColWidths.Count > Value then
      for i:= PKolXLGridData(FCustomObj).FColWidths.Count downto Value+1 do PKolXLGridData(FCustomObj).FColWidths.Delete(i-1);
    {$IFDEF ColsSelect}
    for i:= PKolXLGridData(FCustomObj).FSelectedCols.Count to Value-1 do PKolXLGridData(FCustomObj).FSelectedCols.Add(Pointer(0));
    if PKolXLGridData(FCustomObj).FSelectedCols.Count > Value then
      for i:= PKolXLGridData(FCustomObj).FSelectedCols.Count downto Value+1 do PKolXLGridData(FCustomObj).FSelectedCols.Delete(i-1);
    {$ENDIF}

    for j:= 0 to PKolXLGridData(FCustomObj).FRows.Count-1 do begin
      for i:= PList(PKolXLGridData(FCustomObj).FRows.Items[j]).Count to Value-1 do PList(PKolXLGridData(FCustomObj).FRows.Items[j]).Add(NewmdvXLCell(@Self));
      if PList(PKolXLGridData(FCustomObj).FRows.Items[j]).Count > Value then
        for i:= PList(PKolXLGridData(FCustomObj).FRows.Items[j]).Count downto Value+1 do begin
          PmdvXLCell(PList(PKolXLGridData(FCustomObj).FRows.Items[j]).Items[i-1]).Free;
          PList(PKolXLGridData(FCustomObj).FRows.Items[j]).Delete(i-1);
        end;
    end;
    EndUpdate;
    UpdateScrollBars;
end;

procedure TmdvXLGrid.SetColor(const Value: TColor);
var i, j: Integer;
begin
    BeginUpdate;
    FColor:= Value;
    for i:= 0 to ColCount-1 do for j:= 0 to RowCount-1 do Cells[i,j].Color:= Value;
    EndUpdate;
end;

function TmdvXLGrid.SetColsWidths(Values: array of Integer): PmdvXLGrid;
var i: Integer;
begin
    BeginUpdate;
    for i:= 0 to Min(PKolXLGridData(FCustomObj).FColCount-1, High(Values)) do
      PKolXLGridData(FCustomObj).FColWidths.Items[i]:= Pointer(Values[i]);
    EndUpdate;
    Result:= @Self;
    UpdateScrollBars;
end;

procedure TmdvXLGrid.SetColWidths(Index: Integer; const Value: Integer);
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FColWidths.Items[Index]:= Pointer(Value);
    {$IFDEF ColSizing}
    PKolXLGridData(FCustomObj).FNewSizeCol:= -1;
    PKolXLGridData(FCustomObj).FResizeCol:= -1;
    {$ENDIF}
    if Assigned(PKolXLGridData(FCustomObj).FOnSized) then PKolXLGridData(FCustomObj).FOnSized(@Self, dCol, Index, Value);
    EndUpdate;
    UpdateScrollBars;
end;

procedure TmdvXLGrid.SetDefaultColWidth(const Value: Integer);
var i: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FDefaultColWidth := Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do PKolXLGridData(FCustomObj).FColWidths.Items[i]:= Pointer(Value);
    EndUpdate;
    UpdateScrollBars;
end;

procedure TmdvXLGrid.SetDefaultRowHeight(const Value: Integer);
var i: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FDefaultRowHeight := Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do PKolXLGridData(FCustomObj).FRowHeights.Items[i]:= Pointer(Value);
    EndUpdate;
    UpdateScrollBars;
end;

function TmdvXLGrid.SetDefColWidths(AColWidths: Integer): PmdvXLGrid;
begin
    SetDefaultColWidth(AColWidths);
    Result:= @Self;
end;

function TmdvXLGrid.SetDefRowHeights(ARowWidths: Integer): PmdvXLGrid;
begin
    SetDefaultRowHeight(ARowWidths);
    Result:= @Self;
end;

procedure TmdvXLGrid.SetGridStyle(const Value: TmdvGridStyle);
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FGridStyle:= Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetIndentBottom(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FIndent.Bottom := Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do for j:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do Cells[i,j].IndentBottom:= Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetIndentLeft(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FIndent.Left:= Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do for j:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do Cells[i,j].IndentLeft:= Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetIndentRight(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FIndent.Right := Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do for j:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do Cells[i,j].IndentRight:= Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetIndentTop(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FIndent.Top := Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do for j:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do Cells[i,j].IndentTop:= Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetLeftCol(const Value: Integer);
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FLeftCol := Value;
    UpdateScrollBars;
    EndUpdate;
end;

procedure TmdvXLGrid.SetLineColor(const Value: TColor);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FLineColor:= Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do
      for j:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do begin
        Cells[i,j].LineLeft.Color:= Value; Cells[i,j].LineRight.Color:= Value;
        Cells[i,j].LineTop.Color:= Value; Cells[i,j].LineBottom.Color:= Value;
      end;
    EndUpdate;
end;

procedure TmdvXLGrid.SetLineWidthBottom(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FLineWidth.Bottom := Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do for j:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do Cells[i,j].LineBottom.Width:= Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetLineWidthLeft(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FLineWidth.Left := Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do for j:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do Cells[i,j].LineLeft.Width:= Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetLineWidthRight(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FLineWidth.Right := Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do for j:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do Cells[i,j].LineRight.Width:= Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetLineWidthTop(const Value: Integer);
var i, j: Integer;
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FLineWidth.Top := Value;
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do for j:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do Cells[i,j].LineTop.Width:= Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetOnBeginEdit(const Value: TOnBeginEdit);
begin
    PKolXLGridData(FCustomObj).FOnBeginEdit:= Value;
end;

procedure TmdvXLGrid.SetOnFocusChange(const Value: TOnFocusChange);
begin
    PKolXLGridData(FCustomObj).FOnFocusChange:= Value;
end;

procedure TmdvXLGrid.SetOnMoved(const Value: TOnMoved);
begin
    PKolXLGridData(FCustomObj).FOnMoved:= Value;
end;

procedure TmdvXLGrid.SetOnSized(const Value: TOnSized);
begin
    PKolXLGridData(FCustomObj).FOnSized:= Value;
end;

procedure TmdvXLGrid.SetOptions(const Value: TxlgOptions);
var i, j: Integer;
begin
    BeginUpdate;
    if not (xlgRangeSelect in Value) then begin
      PKolXLGridData(FCustomObj).FDrawStates:= PKolXLGridData(FCustomObj).FDrawStates - [dsDeadDown];
      for i:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do
        for j:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do Cells[j, i].FSelected:= 0;
      Position:= PKolXLGridData(FCustomObj).FPosition;
    end;
    {$IFDEF ColsSelect}
    if not (xlgColsSelect in Value) then
      for i:= 0 to PKolXLGridData(FCustomObj).FColCount - 1 do PKolXLGridData(FCustomObj).FSelectedCols.Items[i]:= Pointer(0);
    {$ENDIF}
    {$IFDEF RowsSelect}
    if not (xlgRowsSelect in Value) then
      for i:= 0 to PKolXLGridData(FCustomObj).FRowCount - 1 do PKolXLGridData(FCustomObj).FSelectedRows.Items[i]:= Pointer(0);
    {$ENDIF}
    PKolXLGridData(FCustomObj).FOptions := Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetPos(const Value: TPoint);
begin
    if (PKolXLGridData(FCustomObj).FColCount<=0)or(PKolXLGridData(FCustomObj).FRowCount<=0) then Exit;
    BeginUpdate;
    EndEdit(True);
    PKolXLGridData(FCustomObj).FPosition:= Value;
    PKolXLGridData(FCustomObj).FPosition:= MakePoint(Min(PKolXLGridData(FCustomObj).FColCount-1, Max(0, PKolXLGridData(FCustomObj).FPosition.x)), Min(PKolXLGridData(FCustomObj).FRowCount-1, Max(0, PKolXLGridData(FCustomObj).FPosition.y)));
    while Position.y > TopRow + VisibleRowCount-1 do TopRow:= TopRow+1;
    while Position.x > LeftCol + VisibleColCount-1 do LeftCol:= LeftCol+1;
    if Position.x < LeftCol then LeftCol:= LeftCol-1;
    if Position.y < TopRow then TopRow:= TopRow-1;

    PKolXLGridData(FCustomObj).FPosition:= MakePoint(PKolXLGridData(FCustomObj).FPosition.x - Cells[PKolXLGridData(FCustomObj).FPosition.x, PKolXLGridData(FCustomObj).FPosition.y].FMergePos.x, PKolXLGridData(FCustomObj).FPosition.y - Cells[PKolXLGridData(FCustomObj).FPosition.x, PKolXLGridData(FCustomObj).FPosition.y].FMergePos.y);

    Selected:= MakeRect(PKolXLGridData(FCustomObj).FPosition.x, PKolXLGridData(FCustomObj).FPosition.y, PKolXLGridData(FCustomObj).FPosition.x + Cells[PKolXLGridData(FCustomObj).FPosition.x, PKolXLGridData(FCustomObj).FPosition.y].FBoundsWidth, PKolXLGridData(FCustomObj).FPosition.y+ Cells[PKolXLGridData(FCustomObj).FPosition.x, PKolXLGridData(FCustomObj).FPosition.y].FBoundsHeight);

    if (TopRow > Value.y) then TopRow := Value.y;
    if (LeftCol > Value.x) then LeftCol:= Value.x;

    if Assigned(PKolXLGridData(FCustomObj).FOnFocusChange) then PKolXLGridData(FCustomObj).FOnFocusChange(@Self, Position.x, Position.y);
    if Assigned(PKolXLGridData(FCustomObj).FOnSelectedChange) then PKolXLGridData(FCustomObj).FOnSelectedChange(@Self, PKolXLGridData(FCustomObj).FSelected);

    UpdateScrollBars;
    EndUpdate;
end;

procedure TmdvXLGrid.SetRowCount(const Value: Word);
var i, j, k: Integer;
begin
    BeginUpdate;

    PKolXLGridData(FCustomObj).FRowCount := Value;
    PKolXLGridData(FCustomObj).FPosition:= MakePoint(Position.X, Min(Position.Y, Value-1));
    for i:= PKolXLGridData(FCustomObj).FTitleRow.Count to Value-1 do PKolXLGridData(FCustomObj).FTitleRow.Add('');
    if PKolXLGridData(FCustomObj).FTitleRow.Count > Value then
      for i:= PKolXLGridData(FCustomObj).FTitleRow.Count-1 downto Value do PKolXLGridData(FCustomObj).FTitleRow.Delete(i);

    for i:= PKolXLGridData(FCustomObj).FRowHeights.Count to Value-1 do PKolXLGridData(FCustomObj).FRowHeights.Add(Pointer(DefaultRowHeight));
    if PKolXLGridData(FCustomObj).FRowHeights.Count > Value then
      for i:= PKolXLGridData(FCustomObj).FRowHeights.Count-1 downto Value do PKolXLGridData(FCustomObj).FRowHeights.Delete(i);
    {$IFDEF RowsSelect}
    for i:= PKolXLGridData(FCustomObj).FSelectedRows.Count to Value-1 do PKolXLGridData(FCustomObj).FSelectedRows.Add(Pointer(0));
    if PKolXLGridData(FCustomObj).FSelectedRows.Count > Value then
      for i:= PKolXLGridData(FCustomObj).FSelectedRows.Count-1 downto Value do PKolXLGridData(FCustomObj).FSelectedRows.Delete(i);
    {$ENDIF}
    for i:= PKolXLGridData(FCustomObj).FRows.Count to Value-1 do begin
      PKolXLGridData(FCustomObj).FRows.Add(NewList); k:= PKolXLGridData(FCustomObj).FRows.Count-1;
      for j:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do PList(PKolXLGridData(FCustomObj).FRows.Items[k]).Add(NewmdvXLCell(@Self));
    end;
    if PKolXLGridData(FCustomObj).FRows.Count > Value then
      for i:= PKolXLGridData(FCustomObj).FRows.Count-1 downto Value do begin
        for j:= PList(PKolXLGridData(FCustomObj).FRows.Items[i]).Count-1 downto 0 do begin
          PmdvXLCell(PList(PKolXLGridData(FCustomObj).FRows.Items[i]).Items[j]).Free;
        end;
        PList(PKolXLGridData(FCustomObj).FRows.Items[i]).Free;
        PKolXLGridData(FCustomObj).FRows.Delete(i);
      end;
    EndUpdate;
    UpdateScrollBars;
end;

procedure TmdvXLGrid.SetRowHeights(Index: Integer; const Value: Integer);
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FRowHeights.Items[Index]:= Pointer(Value);
    if Assigned(PKolXLGridData(FCustomObj).FOnSized) then PKolXLGridData(FCustomObj).FOnSized(@Self, dRow, Index, Value);
    EndUpdate;
    UpdateScrollBars;
end;

function TmdvXLGrid.SetRowsHeights(Values: array of Integer): PmdvXLGrid;
var i: Integer;
begin
    BeginUpdate;
    for i:= 0 to Min(PKolXLGridData(FCustomObj).FRowCount-1, High(Values)) do
      PKolXLGridData(FCustomObj).FRowHeights.Items[i]:= Pointer(Values[i]);
    EndUpdate;
    UpdateScrollBars;
    Result:= @Self;
end;

procedure TmdvXLGrid.SetSelected(Value: TRect);
var Cell_PointT, Cell_PointB, Cell_PointL, Cell_PointR: TPoint;
    i, j: Integer;
begin
    if (PKolXLGridData(FCustomObj).FColCount<=0)or(PKolXLGridData(FCustomObj).FRowCount<=0) then Exit;
    BeginUpdate;
    if PKolXLGridData(FCustomObj).FSelected.Top<>-1 then
    for i:= PKolXLGridData(FCustomObj).FSelected.Top to PKolXLGridData(FCustomObj).FSelected.Bottom do
      for j:= PKolXLGridData(FCustomObj).FSelected.Left to PKolXLGridData(FCustomObj).FSelected.Right do Cells[j, i].FSelected:= Max(0, Cells[j, i].FSelected - 1);
    PKolXLGridData(FCustomObj).FSelected:= Value;
    repeat
      Value:= PKolXLGridData(FCustomObj).FSelected;
      Cell_PointT:= GetCountRow(PKolXLGridData(FCustomObj).FSelected.Left, PKolXLGridData(FCustomObj).FSelected.Right, PKolXLGridData(FCustomObj).FSelected.Top);
      Cell_PointB:= GetCountRow(PKolXLGridData(FCustomObj).FSelected.Left, PKolXLGridData(FCustomObj).FSelected.Right, PKolXLGridData(FCustomObj).FSelected.Bottom);
      Cell_PointL:= GetCountCol(PKolXLGridData(FCustomObj).FSelected.Top, PKolXLGridData(FCustomObj).FSelected.Bottom, PKolXLGridData(FCustomObj).FSelected.Left);
      Cell_PointR:= GetCountCol(PKolXLGridData(FCustomObj).FSelected.Top, PKolXLGridData(FCustomObj).FSelected.Bottom, PKolXLGridData(FCustomObj).FSelected.Right);
      PKolXLGridData(FCustomObj).FSelected:= MakeRect(Min(Cell_PointL.x, Cell_PointR.x),
                                Min(Cell_PointT.x, Cell_PointB.x),
                                Max(Cell_PointL.y, Cell_PointR.y),
                                Max(Cell_PointT.y, Cell_PointB.y));
    until RectsEqual(PKolXLGridData(FCustomObj).FSelected, Value);
    for i:= PKolXLGridData(FCustomObj).FSelected.Top to PKolXLGridData(FCustomObj).FSelected.Bottom do
      for j:= PKolXLGridData(FCustomObj).FSelected.Left to PKolXLGridData(FCustomObj).FSelected.Right do Cells[j, i].FSelected:= Cells[j, i].FSelected + 1;
    if Assigned(PKolXLGridData(FCustomObj).FOnSelectedChange) then PKolXLGridData(FCustomObj).FOnSelectedChange(@Self, PKolXLGridData(FCustomObj).FSelected);
    EndUpdate;
end;

procedure TmdvXLGrid.SetSelectedAll(Value: Boolean);
var i, j: Integer;
begin
    BeginUpdate;
    {$IFDEF ColsSelect} for i:= 0 to PKolXLGridData(FCustomObj).FColCount - 1 do PKolXLGridData(FCustomObj).FSelectedCols.Items[i]:= Pointer(Ord(Value and (xlgColsSelect in PKolXLGridData(FCustomObj).FOptions))); {$ENDIF}
    {$IFDEF RowsSelect} for i:= 0 to PKolXLGridData(FCustomObj).FRowCount - 1 do PKolXLGridData(FCustomObj).FSelectedRows.Items[i]:= Pointer(Ord(Value and (xlgRowsSelect in PKolXLGridData(FCustomObj).FOptions))); {$ENDIF}
    for i:= 0 to PKolXLGridData(FCustomObj).FRowCount-1 do
      for j:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do Cells[j, i].FSelected:= Ord(Value);
    EndUpdate;
end;

procedure TmdvXLGrid.SetSelectedColor(const Value: TColor);
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FSelectedColor:= Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetSelectedCols(Index: Integer; const Value: Boolean);
begin
    {$IFDEF ColsSelect}
    BeginUpdate;
    if Value then PKolXLGridData(FCustomObj).FSelectedCols.Items[Index]:= Pointer(Integer(PKolXLGridData(FCustomObj).FSelectedCols.Items[Index]) + 1)
    else PKolXLGridData(FCustomObj).FSelectedCols.Items[Index]:= Pointer(Max(0, Integer(PKolXLGridData(FCustomObj).FSelectedCols.Items[Index]) - 1));
    if Assigned(PKolXLGridData(FCustomObj).FOnSelectedChange) then PKolXLGridData(FCustomObj).FOnSelectedChange(@Self, PKolXLGridData(FCustomObj).FSelected);
    EndUpdate;
    {$ENDIF}
end;

procedure TmdvXLGrid.SetSelectedRows(Index: Integer; const Value: Boolean);
begin
    {$IFDEF RowsSelect}
    BeginUpdate;
    if Value then PKolXLGridData(FCustomObj).FSelectedRows.Items[Index]:= Pointer(Integer(PKolXLGridData(FCustomObj).FSelectedRows.Items[Index]) + 1)
    else PKolXLGridData(FCustomObj).FSelectedRows.Items[Index]:= Pointer(Max(0, Integer(PKolXLGridData(FCustomObj).FSelectedRows.Items[Index]) - 1));
    if Assigned(PKolXLGridData(FCustomObj).FOnSelectedChange) then PKolXLGridData(FCustomObj).FOnSelectedChange(@Self, PKolXLGridData(FCustomObj).FSelected);
    EndUpdate;
    {$ENDIF}
end;

function DecimalToRoman(Decimal: Integer): String;
const Romans: Array[1..13] of String =   ( 'I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C', 'CD', 'D', 'CM', 'M' );
      Arabics: Array[1..13] of Integer = ( 1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000);
var i: Integer;
    scratch: String;
begin
    scratch := '';
    for i := 13 downto 1 do
      while ( Decimal >= Arabics[i] ) do begin
        Decimal := Decimal - Arabics[i];
        scratch := scratch + Romans[i];
      end;
    Result := scratch;
end;

procedure TmdvXLGrid.SetTitleColor(const Value: TColor);
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FTitleColor := Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetTitleCols(Index: Integer; const Value: String);
begin
    if (Index>=0)and(Index<PKolXLGridData(FCustomObj).FTitleCol.Count) then begin
      EndUpdate;
      PKolXLGridData(FCustomObj).FTitleCol.Items[Index]:= Value;
      EndUpdate;
    end;
end;

function TmdvXLGrid.SetTitleCol(Values: array of String): PmdvXLGrid;
var i: Integer;
begin
    BeginUpdate;
    for i:= 0 to Min(PKolXLGridData(FCustomObj).FTitleCol.Count-1, High(Values)) do
      PKolXLGridData(FCustomObj).FTitleCol.Items[i]:= Values[i];
    EndUpdate;
    Result:= @Self;
end;

procedure TmdvXLGrid.SetTitleColWidth(const Value: Integer);
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FTitleColWidth := Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetTitleRowHeight(const Value: Integer);
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FTitleRowHeight := Value;
    EndUpdate;
end;

procedure TmdvXLGrid.SetTitleRows(Index: Integer; const Value: String);
begin
    if (Index>=0)and(Index<PKolXLGridData(FCustomObj).FTitleRow.Count) then begin
      EndUpdate;
      PKolXLGridData(FCustomObj).FTitleRow.Items[Index]:= Value;
      EndUpdate;
    end;
end;

function TmdvXLGrid.SetTitleRow(Values: array of String): PmdvXLGrid;
var i: Integer;
begin
    BeginUpdate;
    for i:= 0 to Min(PKolXLGridData(FCustomObj).FTitleRow.Count-1, High(Values)) do
      PKolXLGridData(FCustomObj).FTitleRow.Items[i]:= Values[i];
    EndUpdate;
    Result:= @Self;
end;

procedure TmdvXLGrid.SetTitleSelectedColor(const Value: TColor);
begin
    {$IFDEF Select}
    BeginUpdate;
    PKolXLGridData(FCustomObj).FTitleSelectedColor := Value;
    EndUpdate;
    {$ENDIF}
end;

procedure TmdvXLGrid.SetTitleSelectedFontColor(const Value: TColor);
begin
    {$IFDEF Select}
    BeginUpdate;
    PKolXLGridData(FCustomObj).FTitleSelectedFontColor := Value;
    EndUpdate;
    {$ENDIF}
end;

procedure TmdvXLGrid.SetTopRow(const Value: Integer);
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FTopRow := Value;
    UpdateScrollBars;
    EndUpdate;
end;

procedure TmdvXLGrid.ShowPosX(X: Integer);
begin
    if (X<PKolXLGridData(FCustomObj).FLeftCol)or(X > PKolXLGridData(FCustomObj).FLeftCol + VisibleColCount-1) then LeftCol:= Max(0, Min(X, PKolXLGridData(FCustomObj).FColCount-VisibleColCount));
end;

procedure TmdvXLGrid.ShowPosY(Y: Integer);
begin
    if (Y<TopRow)or(Y > PKolXLGridData(FCustomObj).FTopRow + VisibleRowCount-1) then TopRow:= Max(0, Min(Y, PKolXLGridData(FCustomObj).FRowCount-VisibleColCount));
end;

procedure TmdvXLGrid.Split(APos: TPoint);
var i, j: Integer;
    AMergeRect: TRect;
begin
    if not Cells[APos.X, APos.Y].FIsMerge then Exit;
    BeginUpdate;
    EndEdit(True, True);
    AMergeRect.Left:= APos.X - Cells[APos.X, APos.Y].FMergePos.X;
    AMergeRect.Top:= APos.Y - Cells[APos.X, APos.Y].FMergePos.Y;
    AMergeRect.Right:= AMergeRect.Left + Cells[AMergeRect.Left, AMergeRect.Top].FBoundsWidth;
    AMergeRect.Bottom:= AMergeRect.Top + Cells[AMergeRect.Left, AMergeRect.Top].FBoundsHeight;
    for i:= AMergeRect.Top to AMergeRect.Bottom do begin
      for j:= AMergeRect.Left to AMergeRect.Right do begin
        Cells[j, i].FIsMerge:= False;
        Cells[j, i].FShow:= True;
        Cells[j, i].FBoundsWidth:= 0;
        Cells[j, i].FBoundsHeight:= 0;
        Cells[j, i].FMergePos:= MakePoint(0, 0);
      end;
    end;
    EndUpdate;
end;

procedure TmdvXLGrid.UpdateScrollBars;
var ScrollInfo: TScrollInfo;
begin             
    EndEdit(True, True);
    ScrollInfo.nMin:= 0;
    ScrollInfo.nMax:= PKolXLGridData(FCustomObj).FRowCount-1;
    ScrollInfo.nPos:= PKolXLGridData(FCustomObj).FTopRow;
    ScrollInfo.nPage:= VisibleRowCount;
    ScrollInfo.fMask:= SIF_ALL;
    ScrollInfo.cbSize:= SizeOf(ScrollInfo);
    SetScrollInfo(Handle, SB_VERT, ScrollInfo, True);

    ScrollInfo.nMin:= 0;
    ScrollInfo.nMax:= PKolXLGridData(FCustomObj).FColCount-1;
    ScrollInfo.nPos:= PKolXLGridData(FCustomObj).FLeftCol;
    ScrollInfo.nPage:= VisibleColCount;
    ScrollInfo.fMask:= SIF_ALL;
    ScrollInfo.cbSize:= SizeOf(ScrollInfo);
    SetScrollInfo(Handle, SB_HORZ, ScrollInfo, True);
end;

procedure TmdvXLGrid.BeginUpdate;
begin
    Inc(fUpdCount);
end;

procedure TmdvXLGrid.EndUpdate;
begin
    fUpdCount:= Max(0, fUpdCount-1);
    if fUpdCount = 0 then Invalidate;
end;

function TmdvXLGrid.GetOnDrawCell: TOnDrawCell;
begin
    Result:= PKolXLGridData(FCustomObj).FOnDrawCell;
end;

procedure TmdvXLGrid.SetOnDrawCell(const Value: TOnDrawCell);
begin
    PKolXLGridData(FCustomObj).FOnDrawCell:= Value;
end;

function TmdvXLGrid.GetOnDrawTitle: TOnDrawCell;
begin
    Result:= PKolXLGridData(FCustomObj).FOnDrawTitle;
end;

procedure TmdvXLGrid.SetOnDrawTitle(const Value: TOnDrawCell);
begin
    PKolXLGridData(FCustomObj).FOnDrawTitle:= Value;
end;

{$IFDEF Sizing}
function TmdvXLGrid.GetResizeSensitivity: Byte;
begin
    Result:= PKolXLGridData(FCustomObj).FResizeSensitivity;
end;

procedure TmdvXLGrid.SetResizeSensitivity(const Value: Byte);
begin
    PKolXLGridData(FCustomObj).FResizeSensitivity:= Value;
end;
{$ENDIF}

function TmdvXLGrid.GetDefEditorEvents: Boolean;
begin
    Result:= PKolXLGridData(FCustomObj).FDefEditorEvents;
end;

procedure TmdvXLGrid.SetDefEditorEvents(const Value: Boolean);
begin
    PKolXLGridData(FCustomObj).FDefEditorEvents:= Value;
end;

{ TmdvXLCell }

destructor TmdvXLCell.Destroy;
begin
    FText:= '';
    FFont.Free;
    Dispose(FLineLeft);
    Dispose(FLineTop);
    Dispose(FLineBottom);
    Dispose(FLineRight);
    inherited Destroy;
end;

procedure TmdvXLCell.DrawLineAttr(ACanvas: PCanvas; ARect: TRect; ACol, ARow: Integer; AFocus: Boolean; var AResRect: TRect);
var WidthLine: Integer;
    Space: TRect;
begin
    AResRect:= ARect;
    if ACol = 0 then WidthLine:= Max(Ord(FLineLeft.Width>0), Round(FLineLeft.Width/2))
    else WidthLine:= Max(FLineLeft.Width, Grid.Cells[ACol-1, ARow].FLineRight.Width);
    if WidthLine>0 then begin
      Space:= ARect; if ACol = 0 then Space.Right:= Space.Left + WidthLine else Space.Right:= Space.Left + Max(1, Round(WidthLine/2));
//      if not AFocus then begin
        ACanvas.Brush.Color:= FLineLeft.Color;
        ACanvas.FillRect(Space);
//      end;
      AResRect.Left:= Space.Right;
    end;
    if ACol+FBoundsWidth = Grid.ColCount-1 then WidthLine:= Max(Ord(FLineRight.Width>0), Round(FLineRight.Width/2))
    else WidthLine:= Max(FLineRight.Width, Grid.Cells[ACol+FBoundsWidth + 1, ARow].FLineLeft.Width);
    if WidthLine>0 then begin
      Space:= ARect; if ACol+FBoundsWidth = Grid.ColCount-1 then Space.Left:= Space.Right - WidthLine else Space.Left:= Space.Right - (WidthLine - Max(1, Round(WidthLine/2)));
//      if not AFocus then begin
        ACanvas.Brush.Color:= FLineRight.Color;
        ACanvas.FillRect(Space);
//      end;
      AResRect.Right:= Space.Left;
    end;

    if ARow = 0 then WidthLine:= Max(Ord(FLineTop.Width>0), Round(FLineTop.Width/2))
    else WidthLine:= Max(FLineTop.Width, Grid.Cells[ACol, ARow-1].FLineBottom.Width);
    if WidthLine>0 then begin
      Space:= ARect; if ARow = 0 then Space.Bottom:= Space.Top + WidthLine else Space.Bottom:= Space.Top + Max(1, Round(WidthLine/2));
//      if not AFocus then begin
        ACanvas.Brush.Color:= FLineTop.Color;
        ACanvas.FillRect(Space);
//      end;
      AResRect.Top:= Space.Bottom;
    end;
    if ARow+FBoundsHeight = Grid.RowCount-1 then WidthLine:= Max(Ord(FLineBottom.Width>0), Round(FLineBottom.Width/2))
    else WidthLine:= Max(FLineBottom.Width, Grid.Cells[ACol, ARow+FBoundsHeight+1].FLineTop.Width);
    if WidthLine>0 then begin
      Space:= ARect; if ARow+FBoundsHeight = Grid.RowCount-1 then Space.Top:= Space.Bottom - WidthLine else Space.Top:= Space.Bottom - (WidthLine - Max(1, Round(WidthLine/2)));
//      if not AFocus then begin
        ACanvas.Brush.Color:= FLineBottom.Color;
        ACanvas.FillRect(Space);
//      end;
      AResRect.Bottom:= Space.Top;
    end;
end;

procedure TmdvXLCell.Draw(ARect: TRect; ACol, ARow: Integer; ACanvas: PCanvas; ASelect, AFocus: Boolean);
const hAlign : array[ThAlignmentText] of Integer = (DT_LEFT, DT_RIGHT, DT_CENTER, DT_LEFT, DT_LEFT);
const vAlign : array[TvAlignmentText] of Integer = (DT_TOP, DT_BOTTOM, DT_VCENTER, DT_TOP);
var Rect: TRect;
    Access: Boolean;
begin
    if not FShow then Exit;

    if (PKolXLGridData(Grid.FCustomObj).FGridStyle = gsStandard) and (ASelect or AFocus) then ACanvas.Brush.Color:= PKolXLGridData(Grid.FCustomObj).FSelectedColor
    else ACanvas.Brush.Color:= Color;
    ACanvas.Brush.BrushStyle:= bsSolid;
    ACanvas.FillRect(ARect);

    DrawLineAttr(ACanvas, ARect, ACol, ARow, AFocus, Rect);

    ARect:= Rect;
    Rect.Left:= Rect.Left + FIndent.Left;
    Rect.Right:= Rect.Right - FIndent.Right;
    Rect.Top:= Rect.Top + FIndent.Top;
    Rect.Bottom:= Rect.Bottom - FIndent.Bottom;

    if (PKolXLGridData(Grid.FCustomObj).FGridStyle = gsStandard) and AFocus then
    begin
      ACanvas.Brush.Color:= Color;
      ACanvas.Pen.PenMode:= pmCopy;
      ACanvas.DrawFocusRect(ARect);
    end;

    ACanvas.Brush.BrushStyle:= bsClear;
    ACanvas.Font.Assign(Font);
    if (PKolXLGridData(Grid.FCustomObj).FGridStyle = gsStandard) and (ASelect or AFocus) then ACanvas.Font.Color:= PKolXLGridData(Grid.FCustomObj).FSelectedFontColor;
    ACanvas.RequiredState(HandleValid or ChangingCanvas or BrushValid or FontValid or PenValid);

    Access:= False;
    if Assigned(PKolXLGridData(Grid.FCustomObj).FOnDrawCell) then
      PKolXLGridData(Grid.FCustomObj).FOnDrawCell(Grid, ACol, ARow, @Self, ACanvas, ARect, ASelect, AFocus, Access);
    if not Access then DrawText(ACanvas.Handle, PChar(FText), -1, Rect, DT_SINGLELINE or hAlign[HAlignment] or vAlign[VAlignment]);

    ACanvas.Font.Assign(Font);

    ACanvas.RequiredState(HandleValid or ChangingCanvas or BrushValid or FontValid or PenValid);
    if (PKolXLGridData(Grid.FCustomObj).FGridStyle = gsXL) and ASelect and not AFocus then InvertRect(ACanvas.Handle, ARect);

end;

procedure TmdvXLCell.SetFont(const Value: PGraphicTool);
begin
    Grid.BeginUpdate;
    FFont.Assign(Value);
    Grid.EndUpdate;
end;

procedure TmdvXLCell.SetColor(const Value: TColor);
begin
    Grid.BeginUpdate;
    FColor := Value;
    Grid.EndUpdate;
end;

procedure TmdvXLCell.SetText(const Value: String);
begin
    Grid.BeginUpdate;
    FText := Value;
    Grid.EndUpdate;
end;

procedure TmdvXLCell.SetHAlignment(const Value: ThAlignmentText);
begin
    Grid.BeginUpdate;
    FHAlignment := Value;
    Grid.EndUpdate;
end;

procedure TmdvXLCell.SetIndentBottom(const Value: Integer);
begin
    Grid.BeginUpdate;
    FIndent.Bottom := Value;
    Grid.EndUpdate;
end;

procedure TmdvXLCell.SetIndentLeft(const Value: Integer);
begin
    Grid.BeginUpdate;
    FIndent.Left := Value;
    Grid.EndUpdate;
end;

procedure TmdvXLCell.SetIndentRight(const Value: Integer);
begin
    Grid.BeginUpdate;
    FIndent.Right := Value;
    Grid.EndUpdate;
end;

procedure TmdvXLCell.SetIndentTop(const Value: Integer);
begin
    Grid.BeginUpdate;
    FIndent.Top := Value;
    Grid.EndUpdate;
end;

procedure TmdvXLCell.SetVAlignment(const Value: TvAlignmentText);
begin
    Grid.BeginUpdate;
    FVAlignment := Value;
    Grid.EndUpdate;
end;

function TmdvXLGrid.GetTitleColButton: Boolean;
begin
    {$IFDEF ColButton} Result:= PKolXLGridData(FCustomObj).FTitleColButton; {$ELSE}Result:= False;{$ENDIF}
end;

function TmdvXLGrid.GetTitleRowButton: Boolean;
begin
    {$IFDEF RowButton} Result:= PKolXLGridData(FCustomObj).FTitleRowButton; {$ELSE}Result:= False;{$ENDIF}
end;

procedure TmdvXLGrid.SetTitleColButton(const Value: Boolean);
{$IFDEF RowsSelect} var i: Integer; {$ENDIF}
begin
    BeginUpdate;
    {$IFDEF ColButton} PKolXLGridData(FCustomObj).FTitleColButton:= Value; {$ENDIF}
    {$IFDEF RowsSelect} for i:= 0 to PKolXLGridData(FCustomObj).FRowCount - 1 do PKolXLGridData(FCustomObj).FSelectedRows.Items[i]:= Pointer(0); {$ENDIF}
    EndUpdate;
end;

procedure TmdvXLGrid.SetTitleRowButton(const Value: Boolean);
{$IFDEF ColsSelect} var i: Integer; {$ENDIF}
begin
    BeginUpdate;
    {$IFDEF RowButton} PKolXLGridData(FCustomObj).FTitleRowButton:= Value; {$ENDIF}
    {$IFDEF ColsSelect} for i:= 0 to PKolXLGridData(FCustomObj).FColCount - 1 do PKolXLGridData(FCustomObj).FSelectedCols.Items[i]:= Pointer(0); {$ENDIF}
    EndUpdate;
end;

function TmdvXLGrid.GetOnSelectedChange: TOnSelectedChange;
begin
    Result:= PKolXLGridData(FCustomObj).FOnSelectedChange;
end;

procedure TmdvXLGrid.SetOnSelectedChange(const Value: TOnSelectedChange);
begin
    PKolXLGridData(FCustomObj).FOnSelectedChange:= Value;
end;

function TmdvXLGrid.GetSelectedFontColor: TColor;
begin
    Result:= PKolXLGridData(FCustomObj).FSelectedFontColor;
end;

procedure TmdvXLGrid.SetSelectedFontColor(const Value: TColor);
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FSelectedFontColor:= Value;
    EndUpdate;
end;

function TmdvXLGrid.GetOnButtonDown: TOnButtonDown;
begin
    Result:= PKolXLGridData(FCustomObj).FOnButtonDown;
end;

procedure TmdvXLGrid.SetOnButtonDown(const Value: TOnButtonDown);
begin
    PKolXLGridData(FCustomObj).FOnButtonDown:= Value;
end;

function TmdvXLGrid.GetOnEndEdit: TOnEndEdit;
begin
    Result:= PKolXLGridData(FCustomObj).FOnEndEdit;
end;

procedure TmdvXLGrid.SetOnEndEdit(const Value: TOnEndEdit);
begin
    PKolXLGridData(FCustomObj).FOnEndEdit:= Value;
end;

procedure TmdvXLGrid.DeleteCol(Index: Integer);
var i: Integer;
    P: TPoint;
begin
    EndEdit(True, True);
    if (Index>PKolXLGridData(FCustomObj).FColCount-1) or (Index<0) then Exit;
    BeginUpdate;
    P:= Position;
    PKolXLGridData(FCustomObj).FColCount:= PKolXLGridData(FCustomObj).FColCount-1;
    PKolXLGridData(FCustomObj).FTitleCol.Delete(Index);
    PKolXLGridData(FCustomObj).FColWidths.Delete(Index);
    {$IFDEF ColsSelect} PKolXLGridData(FCustomObj).FSelectedCols.Delete(Index); {$ENDIF}
    for i:= 0 to PKolXLGridData(FCustomObj).FRows.Count-1 do PList(PKolXLGridData(FCustomObj).FRows.Items[i]).Delete(Index);
    PKolXLGridData(FCustomObj).FSelected:= MakeRect(-1, -1, -1, -1);
    Position:= P;
    EndUpdate;
end;

procedure TmdvXLGrid.DeleteRow(Index: Integer);
var i: Integer;
    P: TPoint;
begin
    EndEdit(True, True);
    if (Index>PKolXLGridData(FCustomObj).FRowCount-1) or (Index<0) then Exit;
    BeginUpdate;
    P:= Position;
    PKolXLGridData(FCustomObj).FRowCount:= PKolXLGridData(FCustomObj).FRowCount-1;
    PKolXLGridData(FCustomObj).FTitleRow.Delete(Index);
    PKolXLGridData(FCustomObj).FRowHeights.Delete(Index);
    {$IFDEF RowsSelect} PKolXLGridData(FCustomObj).FSelectedRows.Delete(Index); {$ENDIF}
    for i:= 0 to PKolXLGridData(FCustomObj).FColCount-1 do Cells[i, Index].Free;

    PList(PKolXLGridData(FCustomObj).FRows.Items[Index]).Free;

    PKolXLGridData(FCustomObj).FRows.Delete(Index);
    PKolXLGridData(FCustomObj).FSelected:= MakeRect(-1, -1, -1, -1);
    Position:= P;
    EndUpdate;
end;

function TmdvXLGrid.GetSelectedColorLine: TColor;
begin
    Result:= PKolXLGridData(FCustomObj).FSelectedColorLine;
end;

procedure TmdvXLGrid.SetSelectedColorLine(const Value: TColor);
begin
    BeginUpdate;
    PKolXLGridData(FCustomObj).FSelectedColorLine:= Value;
    EndUpdate;
end;

{ TKolXLGridData }

destructor TKolXLGridData.Destroy;
begin
    FGrid.EndEdit(True, True);
    FGrid.RowCount:= 0;
    FPaintBmp.Free;
    FTitleCol.Free; FTitleRow.Free;
    FColWidths.Free; FRowHeights.Free;
    {$IFDEF ColsSelect} FSelectedCols.Free; {$ENDIF}
    {$IFDEF RowsSelect} FSelectedRows.Free; {$ENDIF}

    {$IFDEF ColSizing} DestroyCursor(FCursor_hSplit); {$ENDIF}
    {$IFDEF RowSizing} DestroyCursor(FCursor_vSplit); {$ENDIF}

    FRows.Free;
    {$IFDEF Moving} ilMoving.Free; {$ENDIF}
    FTitleFont.Free;
    inherited;
end;

end.
