unit KOLVMHSyntaxEditor;
//  VMHSyntaxEdit Компонент (VMHSyntaxEdit Component)
//  Автор (Author):
//    Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//    Вокс (Vox)
//  Дата создания (Create date): 9-окт(oct)-2002
//  Дата коррекции (Last correction Date): 25-мар(mar)-2003
//  Версия (Version): 1.11
//  EMail:
//    Gandalf@kol.mastak.ru
//    vox@smtp.ru
//  WWW:
//    http://kol.mastak.ru
//  Благодарности (Thanks):
//    Mike Lischke
//
//  Новое в (New in):
//  V1.11
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V1.1
//  [!] Исправлены некоторые ошибки (Some bugs fixed) [KOL]
//  [*] Ресурсы, exe файл уменьшился на 5-50Кб (Resource, exe-file size 5-50Kb decrease) [KOL]
//  [+] Подсказка (Hint) [KOL]
//
//  V1.0
//  [N] Создан! (Created!)
//  [N] Держит Юникод (Unicode support)
//  [N] Поддержка подсветок (Highlighting support)
//  [N] Очень быстрая загрузка (Very fast load)
//  [N] Очень много возможностей (Very much different features)
//  [N] Правда довольно громозок, но это поправимо (Not small for KOL, but it be fix in future)
//  [N] KOLnMCK>=1.55
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Подчистить (Clear Stuff)
//  4. Ошибки (Errors)
//  5. Помощь (Help)
//  6. Полный перевод на KOL см. TO-DO (Full KOL tranlate see TO-DO)

interface

uses
  Windows, Messages, kol, err, KOLVMHEditorKeyCommands, {Highlighters,} KOLVMHSyntaxEditHighlighter, KOLVMHSyntaxEditTypes, KOLVMHUnicode;
const
  // these self defined cursors are added, the VCL does not a good job on cursors as there's no
  // way to determine which constants already have been occupied by other code
  crDragMove = 2910;
  crDragCopy = 3110;

type
  // eoSmartTabs and eoUseTabs are exclusive (avoid activating both, as this confuses the input),
  // to use any of the tab options you must also have eoWantTabs enabled, otherwise the TAB char
  // will never even reach the edit.
  TSyntaxEditOption = (
    eoAutoIndent,              // do auto indentation when inserting a new line
    eoAutoUnindent,            // do auto undindentation when deleting a character which
                               // is only preceded by whitespace characters
    eoCursorThroughTabs,       // move cursor as if tabulators were (TabSize) spaces
    eoGroupUndo,               // while executing undo/redo handle all continous changes of
                               // the same kind in one call instead undoing/redoing each command
                               // separately
    eoHideSelection,           // hide selection when unfocused
    eoInserting,               // denotes whether the control is in insert or in overwrite mode
                               // (this option in superseeded by eoReadOnly)
    eoKeepTrailingBlanks,      // don't remove automatically white spaces at the end of a line
    eoLineNumbers,             // show line numbers in gutter
    eoOptimalFill,             // not yet implemented
    eoReadOnly,                // prevent the content of the control from being changed
    eoReadOnlySelection,       // show selection if in read only mode (useful for simulation static text)
    eoScrollPastEOL,           // allow the cursor to go past the end of the line
    eoShowControlChars,        // show tabulators, spaces and line breaks (only if not eoScrollPastEOL) as glyphs
    eoShowCursorWhileReadOnly, // don't hide the cursor if control is in read only mode
    eoShowScrollHint,          // show a hint window with the current top line while scrolling with the thumb
    eoSmartTabs,               // automatically put in enough spaces when TAB has been pressed to move
                               // the cursor to the next non-white space character of the previous line
                               // (actually only the cursor is moved, the spaces are inserted later)
    eoTripleClicks,            // allow selecting an entire line with a triple click
    eoUndoAfterSave,           // don't clear the undo/redo stack after the control has been saved
    eoUseTabs,                 // don't covert TABs to spaces but use TAB with fixed distances (see TabSize)
    eoUseSyntaxHighlighting,   // switch on syntax highlighting (ignored if no highlighter is assigned)
    eoWantTabs);               // use TABs for input rather than moving the focus to the next control
  TSyntaxEditOptions = set of TSyntaxEditOption;

const                              
  DefaultTabGlyph = WideChar($2192);
  DefaultLineBreakGlyph = WideChar('¶');
  DefaultSpaceGlyph = WideChar($2219); // Note: $B7 should not be used here because it might be interpreted
                                       //       as valid identifier character (e.g. in Catalan)

  DefaultOptions = [eoAutoIndent, eoAutoUnindent, eoCursorThroughTabs, eoGroupUndo, eoHideSelection,
                    eoInserting, eoScrollPastEOL, eoSmartTabs, eoTripleClicks, eoUseSyntaxHighlighting, eoWantTabs];
  FSB_FLAT_MODE               = 2;
  FSB_ENCARTA_MODE            = 1;
  FSB_REGULAR_MODE            = 0;
  WSB_PROP_VSTYLE         = $00000100;
  WSB_PROP_HSTYLE         = $00000200;
type
  TReplaceAction = (raCancel, raSkip, raReplace, raReplaceAll);

  TIndexEvent = procedure(Index: Integer) of object;
  TCaretEvent = procedure(Sender: PObj; X, Y: Cardinal) of object;
  TReplaceTextEvent = procedure(Sender: PObj; const Search, Replace: WideString; Line, Start, Stop: Integer;
    var Action: TReplaceAction) of object;
  TProcessCommandEvent = procedure(var Command: TEditorCommand; var AChar: WideChar; Data: Pointer) of object;
  TScrollStyle = (ssNone, ssHorizontal, ssVertical, ssBoth);
  TCaretType = (ctVerticalLine, ctHorizontalLine, ctHalfBlock, ctBlock);
  
  // undo / redo
  TChangeReason = (ecrNone, ecrInsert, ecrDelete, ecrReplace, ecrDragMove, ecrDragCopy,
                   ecrCursorMove, ecrOverwrite, ecrIndentation);

  PChange = ^TChange;
  TChange = record
    Reason: TChangeReason;
    OldText: WideString;
    OldCaret,
    OldSelStart,
    OldSelEnd: TPoint;
    NewText: WideString;
    NewCaret,
    NewSelStart,
    NewSelEnd: TPoint;
  end;

  // used to record the current edit state for registering an undo/redo action
  TEditState = record
    Text: WideString;
    Caret,
    SelStart,
    SelEnd: TPoint;
  end;

  PVMHSyntaxEdit = ^TVMHSyntaxEdit;
  TKOLVMHSyntaxEdit = PVMHSyntaxEdit;

  TBookMarkEvent = procedure(Sender: PVMHSyntaxEdit; Index, X, Y: Integer; var Allowed: Boolean) of object;

  // undo and redo in one list
  PUndoList = ^TUndoList;
  TUndoList = object(TObj)
  private
    FList: PList;
    FCurrent: Integer;
    FMaxUndo: Integer;
    FOwner: PVMHSyntaxEdit;
    function GetCanRedo: Boolean;
    function GetCanUndo: Boolean;
    procedure SetMaxUndo(Value: Integer);
  protected
    procedure RemoveChange(Index: Integer);
  public
    destructor Destroy; virtual;

    procedure AddChange(AReason: TChangeReason; const AOldText: WideString; AOldCaret, AOldSelStart, AOldSelEnd: PPoint;
      const ANewText: WideString; ANewCaret, ANewSelStart, ANewSelEnd: PPoint); overload;
    procedure AddChange(AReason: TChangeReason; const AOldText: WideString; AOldCaret, AOldSelStart, AOldSelEnd: PPoint); overload;
    function GetUndoChange(var Change: PChange): TChangeReason;
    function GetRedoChange(var Change: PChange): TChangeReason;
    function GetCurrentRedoReason: TChangeReason;
    function GetCurrentUndoReason: TChangeReason;
    procedure ClearList;

    property CanRedo: Boolean read GetCanRedo;
    property CanUndo: Boolean read GetCanUndo;
    property MaxUndo: Integer read FMaxUndo write SetMaxUndo;
  end;

  PSyntaxEditorStrings = ^TSyntaxEditorStrings;
  TSyntaxEditorStrings = object(TWideStringList)
  private
    FOwner: PVMHSyntaxEdit;
    FModified: Boolean;
    FOnLoaded: TOnEvent;
    FAutoResetModified: Boolean;
  protected
    procedure Put(Index: Integer; const S: WideString); virtual;
  public
    function Add(const S: WideString): Integer; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Insert(Index: Integer; const S: WideString); virtual;
    procedure LoadFromStream(Stream: PStream); virtual;
    procedure SaveToStream(Stream: PStream); virtual;
    procedure SetTextStr(const Value: WideString); virtual;

    property AutoResetModified: Boolean read FAutoResetModified write FAutoResetModified default True;
    property Modified: Boolean read FModified write FModified;
    property OnLoaded: TOnEvent read FOnLoaded write FOnLoaded;
  end;

  PColors = ^TColors;
  TColors = object(TObj)
  private
    FBackground: TColor;
    FForeground: TColor;
    FOwner: PVMHSyntaxEdit;
    procedure SetBackground(Value: TColor);
    procedure SetForeground(Value: TColor);
  public
    property Background: TColor read FBackground write SetBackground default clHighLight;
    property Foreground: TColor read FForeground write SetForeground default clHighLightText;
  end;

  TBookmark = record
    Visible: Boolean;
    X, Y: Integer;
  end;

  PBookmarkOptions = ^TBookmarkOptions;
  TBookmarkOptions = object(TObj)
  private
    FEnableKeys: Boolean;
    FGlyphsVisible: Boolean;
    FLeftMargin: Integer;
    FOwner: PVMHSyntaxEdit;
    procedure SetGlyphsVisible(Value: Boolean);
    procedure SetLeftMargin(Value: Integer);
  public
    property EnableKeys: Boolean read FEnableKeys write FEnableKeys default True;
    property GlyphsVisible: Boolean read FGlyphsVisible write SetGlyphsVisible default True;
    property LeftMargin: Integer read FLeftMargin write SetLeftMargin default 2;
  end;

 { TODO : ScrollWindow object declaration }
//  TScrollHintWindow = class(THintWindow)
//  protected
//    procedure Paint; override;
//  end;

  TDistanceArray = array of Cardinal;

  TScrollBarMode = (sbmRegular, sbmFlat, sbm3D);

  TSearchOption = (
    soBackwards,             // search backwards instead of forward
    soEntireScope,           // search in entire text
    soIgnoreNonSpacing,      // ignore non-spacing characters in search
    soMatchCase,             // case sensitive search
    soPrompt,                // ask user for each replace action
    soRegularExpression,     // search using regular expressions
    soReplace,               // do a replace
    soReplaceAll,            // replace all occurences
    soSelectedOnly,          // search in selected text only
    soSpaceCompress,         // handle several consecutive white spaces as one white space
                             // so "ab   cd" will match "ab cd" and "ab        cd"
    soWholeWord);            // match whole words only
  TSearchOptions = set of TSearchOption;

  TVMHSyntaxEdit = object(TControl)
  private
    procedure ShowHint(Pos : Word);
    function CaretXPix: Integer;
    function CaretYPix: Integer;
    procedure ComputeCaret(X, Y: Integer);
    function GetBlockBegin: TPoint;
    function GetBlockEnd: TPoint;
    function GetFont: PGraphicTool;
    function GetLineCount: Integer;
    function GetLineText: WideString;
    function GetSelAvail: Boolean;
    function GetText: WideString;
    function GetTopLine: Integer;
    procedure FontChanged(Sender: PGraphicTool);
    procedure LineNumberFontChanged(Sender: PGraphicTool);
    procedure LinesChanged(Sender: PObj);
    procedure SetBlockBegin(Value: TPoint);
    procedure SetBlockEnd(Value: TPoint);
    procedure SetWordBlock(Value: TPoint);
    procedure SetCaretX(Value: Integer);
    procedure SetCaretY(Value: Integer);
    procedure SetGutterWidth(Value: Integer);
    procedure SetFont(const Value: PGraphicTool);
    procedure SetOffsetX(Value: Integer);
    procedure SetOffsetY(Value: Integer);
    procedure SetLines(Value: PSyntaxEditorStrings);
    procedure SetLineText(Value: WideString);
    procedure SetScrollBars(const Value: TScrollStyle);
    procedure SetText(const Value: WideString);
    procedure SetTopLine(Value: Integer);
    procedure OnScrollTimer(Sender: PObj);
    procedure UpdateCaret;
    procedure UpdateScrollBars;
    function GetSelText: WideString;
    procedure SetSelText(const Value: WideString);
    procedure ScanFrom(Index: Integer);
    procedure PaintHighlighted(TextCanvas: PCanvas);
    function GetCanUndo: Boolean;
    function GetCanRedo: Boolean;
    procedure SetGutterColor(Value: TColor);
    procedure SetRightMargin(Value: Integer);
    procedure SetMaxUndo(const Value: Integer);
    function GetMaxUndo: Integer;
    procedure SetHighlighter(const Value: PVMHCustomHighlighter);
    procedure SetInsertCaret(const Value: TCaretType);
    procedure SetOverwriteCaret(const Value: TCaretType);
    function GetCaretXY: TPoint;
    procedure SetCaretXY(const Value: TPoint);
    procedure SetKeystrokes(const Value: PKeyStrokes);
    procedure SetMaxRightChar(const Value: Integer);
    procedure SetCharWidth(const Value: Integer);
    procedure SetExtraLineSpacing(const Value: Integer);
    procedure SetSelTextExternal(const Value: WideString);
    procedure SetOptions(const Value: TSyntaxEditOptions);
    procedure SetTabSize(Value: Integer);
    function GetMaxRightChar: Integer;
    procedure SetMarginColor(const Value: TColor);
    function NextTabPos(Index: Integer): Integer;
    function Unindent(X, Y: Cardinal): Cardinal;
    procedure SetScrollBarMode(const Value: TScrollBarMode);
    procedure CalcCharWidths(Index: Integer); overload;
    procedure CalcCharWidths(const S: WideString; TabSz, CharWth: Cardinal); overload;
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
    procedure SetMarkLine(Value: Integer);
    procedure SetMarkColor(const Value: PColors);
    function NextCharPos(ThisPosition: Cardinal; ForceNonDefault: Boolean = False): Cardinal; overload;
    function NextCharPos(ThisPosition, Line: Cardinal; ForceNonDefault: Boolean = False): Cardinal; overload;
    function PreviousCharPos(ThisPosition: Cardinal): Cardinal; overload;
    function PreviousCharPos(ThisPosition, Line: Cardinal): Cardinal; overload;
    function GetLineEnd: Cardinal; overload;
    function GetLineEnd(Index: Cardinal): Cardinal; overload;
    function ColumnToCharIndex(X: Cardinal): Cardinal; overload;
    function ColumnToCharIndex(Pos: TPoint): Cardinal; overload;
    function CharIndexToColumn(X: Cardinal): Cardinal; overload;
    function CharIndexToColumn(X: Cardinal; const S: WideString; TabSz, CharWth: Cardinal): Cardinal; overload;
    function CharIndexToColumn(Pos: TPoint): Cardinal; overload;
    procedure SetIndentSize(Value: Cardinal); overload;
    procedure ReplaceLeftTabs(var S: WideString);
    function LeftSpaces(const S: WideString): Cardinal;
    function RecordState(IncludeText: Boolean): TEditState;
    function PosInSelection(Pos: TPoint): Boolean;
    procedure TripleClick;
    procedure SetUpdateState(Updating: Boolean);
    function CopyOnDrop(Source: PObj): Boolean;
    procedure SetLineNumberFont(const Value: PGraphicTool);
    procedure SetScrollHintColor(const Value: PColors);
    procedure SetSelectedColor(const Value: PColors);

    function GetBookmarkOptions: PBookmarkOptions;
    function GetCharWidth: Integer;
    function GetExtraLineSpacing: Integer;
    function GetGutterColor: TColor;
    function GetGutterWidth: Integer;
    function GetHighLighter: PVMHCustomHighlighter;
    function GetIndentSize: Cardinal;
    function GetInsertCaret: TCaretType;
    function GetKeyStrokes: PKeyStrokes;
    function GetLineNumberFont: PGraphicTool;
    function GetLines: PSyntaxEditorStrings;
    function GetMarginColor: TColor;
    function GetMarkColor: PColors;
    function GetMarkLine: Integer;
    function GetOnBookmark: TBookmarkEvent;
    function GetOnCaretChange: TCaretEvent;
    function GetOnProcessCommand: TProcessCommandEvent;
    function GetOnProcessUserCommand: TProcessCommandEvent;
    function GetOnReplaceText: TReplaceTextEvent;
    function GetOnSettingChange: TOnEvent;
    function GetOptions: TSyntaxEditOptions;
    function GetOverwriteCaret: TCaretType;
    function GetRightMargin: Integer;
    function GetScrollBarMode: TScrollBarMode;
    function GetScrollBars: TScrollStyle;
    function GetScrollHintColor: PColors;
    function GetSelectedColor: PColors;
    function GetUndoList: PUndoList;
    //function GetUpdateCount: Integer;
    procedure SetBookmarkOptions(const Value: PBookmarkOptions);
    procedure SetOnBookmark(const Value: TBookmarkEvent);
    procedure SetOnCaretChange(const Value: TCaretEvent);
    procedure SetOnProcessCommand(const Value: TProcessCommandEvent);
    procedure SetOnProcessUserCommand(const Value: TProcessCommandEvent);
    procedure SetOnReplaceText(const Value: TReplaceTextEvent);
    procedure SetOnSettingChange(const Value: TOnEvent);
    function GetTabSize: Integer;
    function GetCaretX: Integer;
    function GetCaretY: Integer;
    function GetCharsInWindow: Integer;
    function GetInfo: WideString;
    function GetLinesInWindow: Integer;
    procedure SetInfo(const Value: WideString);
    function DragCallback(Sender: PControl; ScrX, ScrY: Integer; var CursorShape: Integer;
            var Stop: Boolean): Boolean;
    function GetCharAddon: Integer;
    procedure SetCharAddon(const Value: Integer);
    function GetBookmarksIL:PImageList;
    procedure SetBookmarksIL(const Value:PImageList);
  protected
    //procedure CreateParams(var Params: TCreateParams); override;
    procedure DeleteSelection(NeedRescan: Boolean);
    procedure DoChange;
    procedure DoSettingChanged;
    function NextSmartTab(X, Y: Integer; SkipNonWhite: Boolean): Integer;
    procedure HideCaret;
    procedure InsertText(const Value: WideString);
    function IsIdentChar(const AChar: WideChar; IdChars: TSynIdentChars): Boolean;
    procedure ListAdded(Sender: PObj);
    procedure ListDeleted(Index: Integer);
    procedure ListInserted(Index: Integer);
    procedure ListLoaded(Sender: PObj);
    procedure ListPutted(Index: Integer);
    procedure PaintGutter(TextCanvas: PCanvas);
    procedure PaintText(TextCanvas: PCanvas);
    procedure Paint;
    procedure ShowCaret;
    procedure DoCaretChange;
    //procedure DragCanceled; override;
    //procedure DragOver(Source: PObj; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    procedure InitializeCaret;
    procedure InvalidateLine(Index: Integer);
    procedure InvalidateLines(Start, Stop: Integer);
    procedure InvalidateToBottom(Index: Integer);
    procedure MarkListChange(Sender: PObj);
    procedure ProcessCommand(var Command: TEditorCommand; var AChar: WideChar; Data: Pointer);
    // If the translations requires Data, memory will be allocated for it via a
    // GetMem call. The client must call FreeMem on Data if it is not nil.
    function TranslateKeyCode(Code: Word; ShiftState: TShiftState; var Data: Pointer): TEditorCommand;
  public
    property BookMarkOptions: PBookmarkOptions read GetBookmarkOptions write SetBookmarkOptions;
    property CharWidth: Integer read GetCharWidth write SetCharWidth;
    property ExtraLineSpacing: Integer read GetExtraLineSpacing write SetExtraLineSpacing default 0;
    property Font: PGraphicTool read GetFont write SetFont;
    property GutterColor: TColor read GetGutterColor write SetGutterColor;
    property GutterWidth: Integer read GetGutterWidth write SetGutterWidth;
    property HighLighter: PVMHCustomHighlighter read GetHighLighter write SetHighlighter;
    property IndentSize: Cardinal read GetIndentSize write SetIndentSize default 2;
    property InsertCaret: TCaretType read GetInsertCaret write SetInsertCaret default ctVerticalLine;
    property Keystrokes: PKeyStrokes read GetKeyStrokes write SetKeystrokes;
    property LineNumberFont: PGraphicTool read GetLineNumberFont write SetLineNumberFont;
    property Lines: PSyntaxEditorStrings read GetLines write SetLines;
    property LineCount: Integer read GetLineCount;
    property MarginColor: TColor read GetMarginColor write SetMarginColor default clSilver;
    property MarkColor: PColors read GetMarkColor write SetMarkColor;
    property MarkLine: Integer read GetMarkLine write SetMarkLine default -1;
    property MaxRightChar: Integer read GetMaxRightChar write SetMaxRightChar;
    property MaxUndo: Integer read GetMaxUndo write SetMaxUndo;
    property Options: TSyntaxEditOptions read GetOptions write SetOptions default DefaultOptions;
    property OverwriteCaret: TCaretType read GetOverwriteCaret write SetOverwriteCaret default ctBlock;
    //property UpdateLock: Integer read GetUpdateCount;
    property RightMargin: Integer read GetRightMargin write SetRightMargin default 80;
    property ScrollBarMode: TScrollBarMode read GetScrollBarMode write SetScrollBarMode;
    property ScrollBars: TScrollStyle read GetScrollBars write SetScrollBars default ssBoth;
    property ScrollHintColor: PColors read GetScrollHintColor write SetScrollHintColor;
    property SelectedColor: PColors read GetSelectedColor write SetSelectedColor;
    property TabSize: Integer read GetTabSize write SetTabSize default 8;
    property Tabstop: Boolean read fTabstop write fTabstop default True;

    property OnCaretChange: TCaretEvent read GetOnCaretChange write SetOnCaretChange;
    property OnBookmark: TBookmarkEvent read GetOnBookmark write SetOnBookmark;
    property OnProcessCommand: TProcessCommandEvent read GetOnProcessCommand write SetOnProcessCommand;
    property OnProcessUserCommand: TProcessCommandEvent read GetOnProcessUserCommand write SetOnProcessUserCommand;
    property OnReplaceText: TReplaceTextEvent read GetOnReplaceText write SetOnReplaceText;
    property OnSettingChange: TOnEvent read GetOnSettingChange write SetOnSettingChange;
    property BookmarksIL: PImageList read GetBookmarksIL write SetBookmarksIL;
  public
    destructor Destroy; virtual;
    procedure Recreate;
    function ActivateKeyboard(const C: WideChar): Boolean;
    function CharPositionToRowColumn(Pos: Cardinal): TPoint;
    procedure ClearAll(RegisterUndo, KeepUndoList: Boolean);
    procedure ClearBookMark(BookMark: Integer);
    procedure ClearUndo;
    procedure CommandProcessor(Command: TEditorCommand; AChar: WideChar; Data: Pointer);
    procedure CopyToClipboard;
    procedure CutToClipboard;
    //procedure DragDrop(Source: PObj; X, Y: Integer); override;
    procedure EnsureCursorPosVisible;
    function GetBookMark(BookMark: Integer; var X, Y: Integer): Boolean;
    function GetSelEnd: Integer;
    function GetSelStart: Integer;
    function GetWordAndBounds(Pos: TPoint; var BB, BE: TPoint): WideString;
    procedure GotoBookMark(BookMark: Integer);
    procedure BlockIndent;
    procedure BlockUnindent;
    function IsBookmark(BookMark: Integer): Boolean;
    function LastWordPos: TPoint;
    function LineFromPos(Pos: TPoint): Integer;
    function NextWordPos: TPoint;
    procedure PasteFromClipboard;
    function PositionFromPoint(X, Y: Integer): TPoint;
    procedure Redo;
    function RowColumnToCharPosition(P: TPoint): Cardinal;
    function SearchReplace(const SearchText, ReplaceText: WideString; Opts: TSearchOptions): Integer;
    procedure SelectAll;
    procedure SetBookMark(BookMark: Integer; X: Integer; Y: Integer);
    procedure SetDefaultKeystrokes;
    procedure SetSelEnd(const Value: Integer);
    procedure SetSelStart(const Value: Integer);
    procedure Undo;
    procedure BeginUpdate;
    procedure EndUpdate;
    function WordAtPos(X, Y: Integer): WideString;

    property BlockBegin: TPoint read GetBlockBegin write SetBlockBegin;
    property BlockEnd: TPoint read GetBlockEnd write SetBlockEnd;
    property CanUndo: Boolean read GetCanUndo;
    property CanRedo: Boolean read GetCanRedo;
    property CaretX: Integer read GetCaretX write SetCaretX;
    property CaretY: Integer read GetCaretY write SetCaretY;
    property CaretXY: TPoint read GetCaretXY write SetCaretXY;
    property CharsInWindow: Integer read GetCharsInWindow;
    property Info: WideString read GetInfo write SetInfo;
    property LineText: WideString read GetLineText write SetLineText;
    property LinesInWindow: Integer read GetLinesInWindow;
    property Modified: Boolean read GetModified write SetModified;
    property SelAvail: Boolean read GetSelAvail;
    property SelText: WideString read GetSelText write SetSelTextExternal;
    property Text: WideString read GetText write SetText;
    property TopLine: Integer read GetTopLine write SetTopLine;
    property UndoList: PUndoList read GetUndoList;
    property CharAddon: Integer read GetCharAddon write SetCharAddon;
  end;

  function WndProcSyntaxEdit( Self_: PControl; var Msg: TMsg; var Rslt:Integer ): Boolean;
// Constructors
  function NewUndoList(AOwner: PVMHSyntaxEdit):PUndoList;
  function NewBookmarkOptions(AOwner: PVMHSyntaxEdit):PBookmarkOptions;
  function NewColors(AOwner: PVMHSyntaxEdit):PColors;
  function NewSyntaxEditorStrings(AOwner: PVMHSyntaxEdit):PSyntaxEditorStrings;
  function NewVMHSyntaxEdit(AParent: PControl) : PVMHSyntaxEdit;
//----------------------------------------------------------------------------------------------------------------------
{$EXTERNALSYM FlatSB_EnableScrollBar}
function FlatSB_EnableScrollBar(hWnd: HWND; wSBflags, wArrows: UINT): BOOL; stdcall;
{$EXTERNALSYM FlatSB_SetScrollProp}
function FlatSB_SetScrollProp(p1: HWND; index: Integer; newValue: Integer;
  p4: Bool): Bool; stdcall;
{$EXTERNALSYM FlatSB_SetScrollInfo}
function FlatSB_SetScrollInfo(hWnd: HWND; BarFlag: Integer;
  const ScrollInfo: TScrollInfo; Redraw: BOOL): Integer; stdcall;
{$EXTERNALSYM InitializeFlatSB}
function InitializeFlatSB(hWnd: HWND): Bool; stdcall;
implementation

//{$R SyntaxEdit.res}

uses IMM;

type
  PSyntaxEditData = ^TSyntaxEditData;
  TSyntaxEditData = packed record
    FCharAddon: Integer;
    FBlockBegin: TPoint;
    FBlockEnd: TPoint;
    FCaretX: Integer;
    FCaretY: Integer;
    FCaretVisible,
    FDragWasStarted: Boolean;
    FCharsInWindow: Integer;
    FCharWidth: Integer;
    FMultiClicked: Boolean;
    FScrollTimer: PTimer;
    FFontDummy,
    FLineNumberFont: PGraphicTool;
    FGutterColor: TColor;
    FGutterRect: TRect;
    FGutterWidth: Integer;
    FLines: PSyntaxEditorStrings;
    FLinesInWindow: Integer;
    FOffsetX,
    FOffsetY: Integer;
    FMaxRightPos: Integer;
    //FUpdateCount: Integer;
    FRightMargin: Integer;
    FScrollBars: TScrollStyle;
    FTextHeight: Integer;
    FHighLighter: PVMHCustomHighlighter;
    FMarkColor,
    FSelectedColor,
    FScrollHintColor: PColors;
    FUndoList : PUndoList;
    FBookMarks: array[0..9] of TBookMark;
    FBookmarksIL:PImageList;
    FLastCaret: TPoint;
    FBookmarkOptions: PBookmarkOptions;
    FOverwriteCaret: TCaretType;
    FInsertCaret: TCaretType;
    FCaretOffset: TPoint;
    FKeyStrokes: PKeyStrokes;
    FModified: Boolean;
    FCharWidthArray: TDistanceArray;
    FInternalBMList: PImageList;
    FExtraLineSpacing: Integer;
    FOptions: TSyntaxEditOptions;
    FTabSize: Integer;
    FMarginColor: TColor;
    FScrollFactor: Single;
    FScrollBarMode: TScrollBarMode;
    FLastValidLine: Integer;
    FMarkLine: Integer;
    FLastCalcIndex: Integer;
    FIndentSize: Cardinal;
    FKeyHandled,
    FDropTarget: Boolean;              // needed to know in the scroll timer event whether to change
                                       // the selection block end or just the cursor position
    FDoubleClickTime: UINT;
    FLastDblClick: UINT;
    FScrollHint: HWND;
    FInfo: WideString;                 // this is a placeholder for application defined data
                                       // like a file name or something similar

    FOnCaretChange: TCaretEvent;
    FOnSettingChange: TOnEvent;
    FOnProcessCommand: TProcessCommandEvent;
    FOnProcessUserCommand: TProcessCommandEvent;
    FOnBookmark: TBookmarkEvent;
    FOnReplaceText: TReplaceTextEvent;
  end;
//----------------------------------------------------------------------------------------------------------------------
function KeyDataToShiftState(KeyData: Longint): TShiftState;
const
  AltMask = $20000000;
begin
  Result := [];
  if GetKeyState(VK_SHIFT) < 0 then Include(Result, ssShift);
  if GetKeyState(VK_CONTROL) < 0 then Include(Result, ssCtrl);
  if KeyData and AltMask <> 0 then Include(Result, ssAlt);
end;

procedure ConvertAndAddImages(IL: PImageList);

// loads the internal bookmark image list

var
  OI: PBitmap;
  I: Integer;
  //MaskColor: TColor;
  Name: String;
  //OneImg: PImageList;
begin
  // Since we want our bookmark images looking in the correct system colors,
  // we have to remap their colors. I really would like to use
  // IL.GetInstRes(HInstance, rtBitmap, Resname, 16, [lrMap3DColors], clWhite) for this task,
  // but could not get it working under NT. It seems that image lists are not very well
  // supported under WinNT 4.
  //OneImage := NewBitmap(0, 0);
  try
    // it is assumed that the image height determines also the width of
    // one entry in the image list
    //OneImg := NewImageList(nil);
    OI := NewBitmap(0, 0);
    IL.Clear;
    IL.ImgHeight := 16;
    IL.ImgWidth := 16;
    IL.DrawingStyle := [dsTransparent];
    for I := 0 to 9 do
    begin
      Name := 'MARK_' + Int2Str(I);
      //OneImg.Handle := ImageList_LoadImage(HInstance, PChar(Name), 16, 1, CLR_NONE, IMAGE_BITMAP, LR_LOADMAP3DCOLORS);

      //MaskColor := OneImage.Canvas.Pixels[0, 0];
      OI.LoadFromResourceName(HInstance, PChar(Name));
      IL.AddMasked(OI.Handle, clFuchsia);
    end;
  finally
    //OneImg.Free;
    OI.Free;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function Min(X, Y: Integer): Integer;

begin
  if X < Y then Result := X
           else Result := Y;
end;

//----------------------------------------------------------------------------------------------------------------------

function MaxPoint(P1, P2: TPoint): TPoint;

begin
  if P1.Y > P2.Y then Result := P1
                 else
    if P1.Y < P2.Y then Result := P2
                   else
      if P1.X > P2.X then Result := P1
                     else Result := P2;
end;

//----------------------------------------------------------------------------------------------------------------------

function MaxPointAsReference(var P1, P2: TPoint): PPoint;

begin
  if P1.Y > P2.Y then Result := @P1
                 else
    if P1.Y < P2.Y then Result := @P2
                   else
      if P1.X > P2.X then Result := @P1
                     else Result := @P2;
end;

//----------------------------------------------------------------------------------------------------------------------

function MinPoint(P1, P2: TPoint): TPoint;

begin
  if P1.Y < P2.Y then Result := P1
                 else
    if P1.Y > P2.Y then Result := P2
                   else
      if P1.X < P2.X then Result := P1
                     else Result := P2;
end;

//----------------------------------------------------------------------------------------------------------------------

function MinPointAsReference(var P1, P2: TPoint): PPoint;

begin
  if P1.Y < P2.Y then Result := @P1
                 else
    if P1.Y > P2.Y then Result := @P2
                   else
      if P1.X < P2.X then Result := @P1
                     else Result := @P2;
end;

//----------------------------------------------------------------------------------------------------------------------

function PointsAreEqual(P1, P2: TPoint): Boolean;

begin
  Result := (P1.X = P2.X) and (P1.Y = P2.Y);
end;

//----------------- TUndoList ------------------------------------------------------------------------------------------

function NewUndoList(AOwner: PVMHSyntaxEdit):PUndoList;

begin
  New(Result, Create);
  Result.FOwner := AOwner;
  Result.FList := NewList;
  Result.FMaxUndo := 10;
  Result.FCurrent := -1;
end;

//----------------------------------------------------------------------------------------------------------------------

destructor TUndoList.Destroy;

begin
  ClearList;
  FList.Free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TUndoList.AddChange(AReason: TChangeReason; const AOldText: WideString; AOldCaret, AOldSelStart,
  AOldSelEnd: PPoint; const ANewText: WideString; ANewCaret, ANewSelStart, ANewSelEnd: PPoint);

// adds a new change into the undo list;
// The parameter list looks rather messy, but should serve all possible combination
// which can appear. By using pointers instead of just the records we can pass
// nil values where we don't need a value in the undo list. This is particularly useful
// to avoid creating dummy records just to fill the paramter list.
// Note: There's an overloaded funtion variant to avoid passing in the current
//       edit state (text, caret, selection).

var
  NewChange: PChange;

begin
  if FMaxUndo > 0 then
  begin
    if FList.Count >= FMaxUndo then RemoveChange(0);

    // a new undo record deletes all redo records if there are any
    while FCurrent < FList.Count - 1 do RemoveChange(FList.Count - 1);

    // add a new entry
    New(NewChange);
    FillChar(NewChange^, SizeOf(NewChange^), 0);
    with NewChange^ do
    begin
      Reason := AReason;
      OldText := AOldText;
      if Assigned(AOldCaret) then OldCaret := AOldCaret^;
      if Assigned(AOldSelStart) then OldSelStart := AOldSelStart^;
      if Assigned(AOldSelEnd) then OldSelEnd := AOldSelEnd^;
      NewText := ANewText;
      if Assigned(ANewCaret) then NewCaret := ANewCaret^;
      if Assigned(ANewSelStart) then NewSelStart := ANewSelStart^;
      if Assigned(ANewSelEnd) then NewSelEnd := ANewSelEnd^;
    end;
    FList.Add(NewChange);
    // advance current undo index
    Inc(FCurrent);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TUndoList.AddChange(AReason: TChangeReason; const AOldText: WideString; AOldCaret, AOldSelStart, AOldSelEnd: PPoint);

// adds a new change into the undo list, all new values are taken from current state
// Note: There's an overloaded function variant to allow passing other New* values
//       than the ones of the editor.

var
  NewChange: PChange;

begin
  if FMaxUndo > 0 then
  begin
    if FList.Count >= FMaxUndo then RemoveChange(0);

    // a new undo record deletes all redo records if there are any
    while FCurrent < FList.Count - 1 do RemoveChange(FList.Count - 1);

    // add a new entry
    New(NewChange);
    FillChar(NewChange^, SizeOf(NewChange^), 0);
    with NewChange^ do
    begin
      Reason := AReason;
      OldText := AOldText;
      if Assigned(AOldCaret) then OldCaret := AOldCaret^;
      if Assigned(AOldSelStart) then OldSelStart := AOldSelStart^;
      if Assigned(AOldSelEnd) then OldSelEnd := AOldSelEnd^;
      with FOwner^ do
      begin
        NewText := GetSelText;
        NewCaret := CaretXY;
        NewSelStart := PSyntaxEditData(FOwner.CustomData).FBlockBegin;
        NewSelEnd := PSyntaxEditData(FOwner.CustomData).FBlockEnd;
      end;
    end;
    FList.Add(NewChange);
    // advance current undo index
    Inc(FCurrent);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TUndoList.GetUndoChange(var Change: PChange): TChangeReason;

begin
  if FCurrent = -1 then Result := ecrNone
                   else
  begin
    Change := FList.Items[FCurrent];
    Result := Change.Reason;
    Dec(FCurrent);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TUndoList.GetRedoChange(var Change: PChange): TChangeReason;

begin
  if FCurrent = FList.Count - 1 then Result := ecrNone
                                else
  begin
    Inc(FCurrent);
    Change := FList.Items[FCurrent];
    Result := Change.Reason;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TUndoList.GetCanRedo: Boolean;

begin
  Result := FCurrent < FList.Count - 1;
end;

//----------------------------------------------------------------------------------------------------------------------

function TUndoList.GetCanUndo: Boolean;

begin
  Result := FCurrent > -1;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TUndoList.SetMaxUndo(Value: Integer);

begin
  if Value > 32767 then Value := 32767;
  if FMaxUndo <> Value then
  begin
    FMaxUndo := Value;
    // FCurrent ist automatically updated
    while FMaxUndo < FList.Count - 1 do RemoveChange(0);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TUndoList.RemoveChange(Index: Integer);

var
  AChange: PChange;

begin
  if (Index > -1) and (Index < FList.Count) then
  begin
    AChange := FList.Items[Index];
    Dispose(AChange);
    FList.Delete(Index);
  end;
  if FCurrent > FList.Count - 1 then FCurrent := FList.Count - 1;
end;

//----------------------------------------------------------------------------------------------------------------------

function TUndoList.GetCurrentUndoReason: TChangeReason;

begin
  if FCurrent = -1 then Result := ecrNone
                   else Result := PChange(FList.Items[FCurrent]).Reason;
end;

//----------------------------------------------------------------------------------------------------------------------

function TUndoList.GetCurrentRedoReason: TChangeReason;

begin
  if FCurrent = FList.Count - 1 then Result := ecrNone
                                else Result := PChange(FList.Items[FCurrent + 1]).Reason;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TUndoList.ClearList;

var
  I: Integer;

begin
  for I := FList.Count - 1 downto 0 do RemoveChange(I);
end;

//----------------- TBookmarkOptions -----------------------------------------------------------------------------------

function NewBookmarkOptions(AOwner: PVMHSyntaxEdit):PBookmarkOptions;

begin
  New(Result, Create);
  Result.FOwner := AOwner;
  Result.FEnableKeys := True;
  Result.FGlyphsVisible := True;
  Result.FLeftMargin := 2;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TBookmarkOptions.SetGlyphsVisible(Value: Boolean);

begin
  if FGlyphsVisible <> Value then
  begin
    FGlyphsVisible := Value;
    FOwner.Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TBookmarkOptions.SetLeftMargin(Value: Integer);

begin
  if FLeftMargin <> Value then
  begin
    FLeftMargin := Value;
    FOwner.Invalidate;
  end;
end;

//----------------- TKOLVMHSyntaxEditorStrings -------------------------------------------------------------------------------

function NewSyntaxEditorStrings(AOwner: PVMHSyntaxEdit):PSyntaxEditorStrings;

begin
  New(Result, Create);
  Result.FOwner := AOwner;
  Result.FAutoResetModified := True;
end;

//----------------------------------------------------------------------------------------------------------------------

function TSyntaxEditorStrings.Add(const S: WideString): Integer;

begin
  if eoKeepTrailingBlanks in PSyntaxEditData(FOwner.CustomData).FOptions then Result := inherited Add(S)
                                             else Result := inherited Add(WideTrimRight(S));
  FModified := True;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TSyntaxEditorStrings.Delete(Index: Integer);

begin
  inherited Delete(Index);
  if Index = PSyntaxEditData(FOwner.CustomData).FLastCalcIndex then PSyntaxEditData(FOwner.CustomData).FLastCalcIndex := -1;
  FModified := True;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TSyntaxEditorStrings.Insert(Index: Integer; const S: WideString);

begin
  inherited Insert(Index, S);
  if Index = PSyntaxEditData(FOwner.CustomData).FLastCalcIndex then PSyntaxEditData(FOwner.CustomData).FLastCalcIndex := -1;
  if Length(Strings[Index]) >= FOwner.MaxRightChar then
  begin
    FOwner.MaxRightChar := FOwner.MaxRightChar + FOwner.CharAddon;
    FOwner.Perform(WM_HSCROLL, SB_BOTTOM, 0);
  end;
  FModified := True;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TSyntaxEditorStrings.Put(Index: Integer; const S: WideString);

begin
  if Get(Index) <> S then
  begin
    inherited Put(Index, S);
    FModified := True;
    if Length(Strings[Index]) >= FOwner.MaxRightChar then
    begin
      FOwner.MaxRightChar := FOwner.MaxRightChar + FOwner.CharAddon;
      FOwner.Perform(WM_HSCROLL, SB_BOTTOM, 0);
    end;
    FOwner.InvalidateLine(Index);
    if Index = PSyntaxEditData(FOwner.CustomData).FLastCalcIndex then PSyntaxEditData(FOwner.CustomData).FLastCalcIndex := -1;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TSyntaxEditorStrings.LoadFromStream(Stream: PStream);

begin
  // clear entire text buffer plus some other variables and the undo stack,
  // do not register an undo action for it
  FOwner.ClearAll(False, False);
  inherited;
  PSyntaxEditData(FOwner.CustomData).FLastCalcIndex := -1;
  PSyntaxEditData(FOwner.CustomData).FUndoList.ClearList;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TSyntaxEditorStrings.SaveToStream(Stream: PStream);

begin
  inherited;
  if Saved and AutoResetModified then
  begin
    FModified := False;
    PSyntaxEditData(FOwner.CustomData).FModified := False;
  end;
  if not (eoUndoAfterSave in PSyntaxEditData(FOwner.CustomData).FOptions) then PSyntaxEditData(FOwner.CustomData).FUndoList.ClearList;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TSyntaxEditorStrings.SetTextStr(const Value: WideString);

begin
  inherited SetTextStr(Value);
  PSyntaxEditData(FOwner.CustomData).FLastCalcIndex := -1;
  FOwner.Invalidate;
  FModified := True;
  if Assigned(FOnLoaded) then FOnLoaded(@Self);
end;

//----------------- TColors --------------------------------------------------------------------------------------------

function NewColors(AOwner: PVMHSyntaxEdit):PColors;

begin
  New(Result, Create);
  Result.FOwner := AOwner;
  Result.FBackground := clHighLight;
  Result.FForeground := clHighLightText;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TColors.SetBackground(Value: TColor);

begin
  if FBackground <> Value then
  begin
    FBackground := Value;
    if Assigned(FOwner) then FOwner.Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TColors.SetForeground(Value: TColor);

begin
  if FForeground <> Value then
  begin
    FForeground := Value;
    if Assigned(FOwner) then FOwner.Invalidate;
  end;
end;

//----------------- TScrollHintWindow ----------------------------------------------------------------------------------

{procedure TScrollHintWindow.Paint;

var
  R: TRect;
  
begin
  R := ClientRect;
  Inc(R.Left, 2);
  Inc(R.Top, 2);
  Canvas.Font := Font;
  DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
    DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
end; }
const
  ScrollBarProp: array[TScrollBarMode] of Integer = (FSB_REGULAR_MODE, FSB_FLAT_MODE, FSB_ENCARTA_MODE);
//----------------- TKOLVMHSyntaxEdit ----------------------------------------------------------------------------------

function NewVMHSyntaxEdit(AParent: PControl) : PVMHSyntaxEdit;
type TBorderStyle = (bsNone, bsSingle);
const
  ScrollBar: array[TScrollStyle] of DWORD = (0, WS_HSCROLL, WS_VSCROLL, WS_HSCROLL or WS_VSCROLL);

  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);

var
  I: Integer;
  Style : Integer;
  D : PSyntaxEditData;
begin
  Style := WS_CHILD or WS_VISIBLE;// or WS_CLIPCHILDREN or WS_CLIPSIBLINGS and not WS_BORDER;
  Result := PVMHSyntaxEdit(_NewControl(AParent, 'SyntaxEditor', Style, True, nil));
  AParent.Add2AutoFree(Result);
  GetMem(D, Sizeof(D^));
  FillChar(D^,Sizeof(D^),0);
  Result.CustomData := D;
  //Result.Style := ScrollBar[D.FScrollBars] or BorderStyles[D.FBorderStyle];
  Result.ExStyle := Result.ExStyle or WS_EX_CLIENTEDGE;
  Result.ClsStyle := Result.ClsStyle or CS_DBLCLKS and not (CS_HREDRAW or CS_VREDRAW);
  Result.DoubleBuffered := False;
  D.FOptions := DefaultOptions;
  D.FLines := NewSyntaxEditorStrings(Result);
  D.FLines.Add('');
  D.FFontDummy := NewFont;
  D.FLineNumberFont := NewFont;
  D.FLineNumberFont.FontName := 'Terminal';
  D.FLineNumberFont.FontHeight := -8;
  D.FLineNumberFont.Color := clBlack;
  D.FLineNumberFont.FontStyle := [];
  D.FLineNumberFont.OnChange := Result.LineNumberFontChanged;

  D.FUndoList := NewUndoList(Result);
  D.FLines.OnLoaded := Result.ListLoaded;
  D.FSelectedColor := NewColors(Result);
  D.FMarkColor := NewColors(Result);
  D.FScrollHintColor := NewColors(Result);
  D.FScrollHintColor.FBackground := clAppWorkSpace;
  D.FScrollHintColor.FForeground := clInfoText;
  D.FBookmarkOptions := NewBookmarkOptions(Result);

  D.FScrollTimer := NewTimer(20);
  D.FScrollTimer.enabled := False;
  D.FScrollTimer.OnTimer := Result.OnScrollTimer;

  D.FCharsInWindow := 10;
  // FRightMargin, FCharWidth and MaxRight have to be set before FontChanged
  // is called for the first time.
  D.FRightMargin := 80;
  // this char width value is only a dummy and will be updated later
  D.FCharWidth := 8;
  Result.MaxRightChar := 500;
  D.FMarginColor := clSilver;
  D.FGutterWidth := 50;
  //Result.Style := Result.ControlStyle + [csOpaque, csSetCaption, csReflector];

  //Result.Height := 150;
  //Result.Width := 400;
  Result.Cursor := LoadCursor(0, IDC_IBEAM);
  Result.Color := clWindow;
  D.FCaretX := 0;
  D.FCaretY := 0;
  D.FCaretOffset := MakePoint(0, 0);
  D.FGutterColor := clBtnFace;
  D.FFontDummy.FontName := 'Courier New';
  D.FFontDummy.FontHeight := -13;

  Result.Font.OnChange := Result.FontChanged;
  Result.Font.Assign(D.FFontDummy);
  Result.TabStop := True;
  D.FLines.OnChange := Result.LinesChanged;
  with D.FGutterRect do
  begin
    Left := 0;
    Top := 0;
    Right := D.FGutterWidth - 1;
    Bottom := Result.Height;
  end;
  D.FTabSize := 8;
  D.FCharAddon := 5;
  //D.FUpdateCount := 0;
  D.FIndentSize := 2;
  D.FScrollBars := ssBoth;
  D.FBlockBegin := MakePoint(0, 0);
  D.FBlockEnd := MakePoint(0, 0);
  D.FInternalBMList := NewImageList(nil);
  D.FInternalBMList.DrawingStyle := [dsTransparent];
  ConvertAndAddImages(D.FInternalBMList);
  for I := 0 to 9 do D.FBookmarks[I].Y := -1;
  Result.HasBorder := True;
  D.FInsertCaret := ctVerticalLine;
  D.FOverwriteCaret := ctBlock;
  D.FKeyStrokes := NewKeyStrokes;
  D.FScrollFactor := 1;
  D.FMarkLine := -1;
  D.FLastCalcIndex := -1;
  D.FCaretVisible := Windows.ShowCaret(Result.Handle);
  // retrive double click time to be used in triple clicks,
  // make this time smaller to avoid triple clicks in cases of double clicks and drag'n drop start
  D.FDoubleClickTime := GetDoubleClickTime;
  Result.AttachProc(WndProcSyntaxEdit);
  Result.SetDefaultKeystrokes;
  Result.UpdateScrollBars;

  D.FScrollBarMode := sbmFlat;
  InitializeFlatSB(Result.Handle);
  FlatSB_EnableScrollBar(Result.Handle, SB_BOTH, ESB_ENABLE_BOTH);
  FlatSB_SetScrollProp(Result.Handle, WSB_PROP_HSTYLE, ScrollBarProp[D.FScrollBarMode], True);
  FlatSB_SetScrollProp(Result.Handle, WSB_PROP_VSTYLE, ScrollBarProp[D.FScrollBarMode], True);

  D.FScrollHint := CreateWindowEx(0,TOOLTIPS_CLASS,'',0,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,Result.GetWindowHandle,0,HInstance,nil);
  SendMessage(D.FScrollHint, TTM_SETDELAYTIME, 5, 1);
end;

//----------------------------------------------------------------------------------------------------------------------

{procedure TKOLVMHSyntaxEdit.CreateParams(var Params: TCreateParams);

const
  ScrollBar: array[TScrollStyle] of DWORD = (0, WS_HSCROLL, WS_VSCROLL, WS_HSCROLL or WS_VSCROLL);
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);

  CS_OFF = CS_HREDRAW or CS_VREDRAW;

begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or ScrollBar[FScrollBars] or BorderStyles[FBorderStyle] or WS_CLIPCHILDREN or WS_CLIPSIBLINGS;
    WindowClass.Style := WindowClass.Style and not CS_OFF;
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
end;}

//----------------------------------------------------------------------------------------------------------------------

destructor TVMHSyntaxEdit.Destroy;
var D : PSyntaxEditData;
begin
  D := CustomData;
  D.FKeyStrokes.Free;
  D.FLineNumberFont.Free;
  D.FFontDummy.Free;
  D.FLines.Free;
  D.FSelectedColor.Free;
  D.FScrollHintColor.Free;
  D.FBookmarkOptions.Free;
  D.FScrollTimer.Free;
  D.FUndoList.Free;
  D.FCharWidthArray := nil;
  D.FInternalBMList.Free;
  // scroll hint window is automatically destroyed
  inherited Destroy;
end;

//----------------------------------------------------------------------------------------------------------------------

function WndProcSyntaxEdit( Self_: PControl; var Msg: TMsg; var Rslt:Integer ): Boolean;
var D: PSyntaxEditData;
    SEdit: PVMHSyntaxEdit;
    IntVar, Size: Integer;
    P: TPoint;
    Data: Pointer;
    Cmd: TEditorCommand;
    PS : TPaintStruct;
    LogFont: TLogFont;
begin
  Result := FALSE;
  SEdit := PVMHSyntaxEdit(Self_);
  case Msg.Message of
  WM_MOUSEWHEEL: begin
                   if SEdit <> nil then
                   begin
                     Rslt := 1;
                     D := SEdit.CustomData;
                     SystemParametersInfo(SPI_GETWHEELSCROLLLINES, 0, @IntVar, 0);
                     if (GetKeyState(VK_CONTROL) < 0) then IntVar := D.FLinesInWindow * (Msg.wParam div $FFFF div WHEEL_DELTA)
                                                      else IntVar := IntVar * (Msg.wParam div $FFFF div WHEEL_DELTA);
                     SEdit.TopLine := SEdit.TopLine - IntVar;
                     SEdit.Update;
                   end;
                 end;
  WM_SYSCOLORCHANGE: begin
                       if SEdit <> nil then
                       begin
                         D := SEdit.CustomData;
                         ConvertAndAddImages(D.FInternalBMList);
                       end;
                     end;
  WM_ERASEBKGND: Rslt := 1;
  WM_GETDLGCODE: begin
                   Rslt := DLGC_WANTARROWS or DLGC_WANTCHARS;
                   if SEdit <> nil then
                   begin
                     D := SEdit.CustomData;
                     if eoWantTabs in D.FOptions then Rslt := DLGC_WANTTAB;
                   end;
                 end;
  WM_HSCROLL: begin
                if SEdit <> nil then
                begin
                  D := SEdit.CustomData;
                  case LoWord(Msg.wParam) of
                  SB_BOTTOM:
                    SEdit.SetOffsetX(-D.FMaxRightPos);
                  SB_ENDSCROLL:
                    ;
                  SB_LINELEFT:
                    if D.FOffsetX < 0 then SEdit.SetOffsetX(D.FOffsetX + D.FCharWidth);
                  SB_LINERIGHT:
                    if -D.FOffsetX < (D.FMaxRightPos - SEdit.ClientWidth + D.FGutterRect.Right) then SEdit.SetOffsetX(D.FOffsetX - D.FCharWidth);
                  SB_PAGELEFT:
                    SEdit.SetOffsetX(D.FOffsetX + SEdit.ClientWidth - D.FGutterRect.Right + 1);
                  SB_PAGERIGHT:
                    SEdit.SetOffsetX(D.FOffsetX - SEdit.ClientWidth + D.FGutterRect.Right + 1);
                  SB_THUMBPOSITION,
                  SB_THUMBTRACK:
                    SEdit.SetOffsetX(-HiWord(Cardinal(Msg.wParam)));
                  SB_TOP:
                    SEdit.SetOffsetX(0);
                  end;
                  Rslt := 0;
                end;
              end;
  WM_IME_COMPOSITION: if SEdit <> nil then
                      begin
                        if (Msg.lParam and GCS_RESULTSTR) <> 0 then
                        begin
                          IntVar := ImmGetContext(SEdit.Handle);
                          try
                            Size := ImmGetCompositionString(IntVar, GCS_RESULTSTR, nil, 0);
                            Inc(Size, 2);
                            Data := AllocMem(Size);
                            try
                              ImmGetCompositionString(IntVar, GCS_RESULTSTR, Data, Size);
                              PChar(Data)[Size] := #0;
                              // implicitly convert DBCS to Unicode
                              SEdit.InsertText(PChar(Data));
                            finally
                              FreeMem(Data);
                            end;
                          finally
                            ImmReleaseContext(SEdit.Handle, IntVar);
                          end;
                          Rslt := 0;
                        end;
                      end;
  WM_IME_NOTIFY: if SEdit <> nil then
                   if Msg.wParam = IMN_SETOPENSTATUS then
                   begin
                     IntVar := ImmGetContext(SEdit.Handle);
                     if IntVar <> 0 then
                     begin
                       // need to tell the composition window what font we are using currently
                       GetObject(SEdit.Canvas.Font.Handle, SizeOf(TLogFont), @LogFont);
                       ImmSetCompositionFont(IntVar, @LogFont);
                       ImmReleaseContext(SEdit.Handle, IntVar);
                     end;
                     Rslt := 0;
                   end;
  WM_KILLFOCUS: begin
                  if SEdit <> nil then
                  begin
                    D := SEdit.CustomData;
                    SEdit.HideCaret;
                    DestroyCaret;
                    if (eoHideSelection in D.FOptions) and SEdit.SelAvail then SEdit.Invalidate;
                  end;
                end;
  WM_SETCURSOR: begin
                  if SEdit <> nil then
                  begin
                    D := SEdit.CustomData;
                    GetCursorPos(P);
                    P := SEdit.Screen2Client(P);
                    if (LoWord(Msg.lParam) <> HTCLIENT) or PtInRect(D.FGutterRect, P) then
                      SEdit.Cursor:=LoadCursor(0, IDC_ARROW)
                    else begin
                      P := SEdit.PositionFromPoint(P.X, P.Y);
                      if SEdit.PosInSelection(P) then SEdit.Cursor:=LoadCursor(0, IDC_ARROW)
                                                 else SEdit.Cursor:=LoadCursor(0, IDC_IBEAM);
                    end;
                  end;
                end;
  WM_SETFOCUS: begin
                 if SEdit <> nil then
                 begin
                   D := SEdit.CustomData;
                   SEdit.InitializeCaret;
                   SEdit.UpdateScrollBars;
                   if (eoHideSelection in D.FOptions) and SEdit.SelAvail then SEdit.Invalidate;
                 end;
               end;
  WM_SIZE: begin
             if SEdit <> nil then
             begin
               D := SEdit.CustomData;
               if SEdit.HandleAllocated then
               begin
                 D.FCharsInWindow := (SEdit.ClientWidth - D.FGutterRect.Right + 1) div D.FCharWidth;
                 D.FLinesInWindow := SEdit.ClientHeight div D.FTextHeight;
                 D.FGutterRect.Bottom := SEdit.ClientHeight;
                 if (D.FLines.Count - SEdit.TopLine + 1) < D.FLinesInWindow then SEdit.TopLine := D.FLines.Count - D.FLinesInWindow + 1;
                 SEdit.UpdateScrollBars;
               end;
             end;
           end;
  WM_VSCROLL: begin
                if SEdit <> nil then
                begin
                  D := SEdit.CustomData;
                  case LoWord(Msg.wParam) of
                  SB_BOTTOM:
                    SEdit.SetOffsetY(-D.FLines.Count);
                  SB_ENDSCROLL:
                    {D.FScrollHint.ReleaseHandle};
                  SB_LINEUP:
                    SEdit.SetOffsetY(D.FOffsetY + 1);
                  SB_LINEDOWN:
                    SEdit.SetOffsetY(D.FOffsetY - 1);
                  SB_PAGELEFT:
                    SEdit.SetOffsetY(D.FOffsetY + D.FLinesInWindow);
                  SB_PAGERIGHT:
                    SEdit.SetOffsetY(D.FOffsetY - D.FLinesInWindow);
                  SB_THUMBPOSITION: // indicates end of thumbtrack operation, no need to handle this
                    ;
                  SB_THUMBTRACK:
                  begin
                    SEdit.SetOffsetY(-Round(HiWord(Cardinal(Msg.wParam)) * D.FScrollFactor));
                    { TODO : Show Hint Window }
                    if eoShowScrollHint in D.FOptions then SEdit.ShowHint(HiWord(Cardinal(Msg.wParam)));
                  end;
                  SB_TOP:
                    SEdit.SetOffsetY(0);
                  end;
                  Rslt := 0;
                end;
              end;
  WM_MOUSEMOVE: begin
                   if SEdit <> nil then
                   begin
                     D := SEdit.CustomData;
                     if LoWord(Msg.lParam) > D.FGutterWidth then
                     begin
                       P := SEdit.PositionFromPoint(LoWord(Msg.lParam), HiWord(Cardinal(Msg.lParam)));
//                       if (Msg.wParam and MK_LBUTTON<>0) then
//                         ShowMessage('Mouse and LKM :)');
                       // don't use ssLeft in Shift as this parameter is not always reliable (mouse wheel!)
                       if (not Msg.wParam and MK_LBUTTON = 0) and not D.FMultiClicked then
                       begin
                         if not D.FScrollTimer.Enabled
                         and ((D.FLastCaret.X - P.X <> 0) or (D.FLastCaret.Y - P.Y <> 0)) then D.FScrollTimer.Enabled := True;
                       end
                       else D.FScrollTimer.Enabled := False;
                     end;
                   end;
                end;
  WM_LBUTTONDBLCLK: begin
                      if SEdit <> nil then
                      begin
                        D := SEdit.CustomData;
                        if D.FLines.Count > 0 then SEdit.SetWordBlock(SEdit.CaretXY);
                        D.FMultiClicked := True;
                        if not PtInRect(D.FGutterRect, MakePoint(LoWord(Msg.lParam), HiWord(Cardinal(Msg.lParam)))) then
                          D.FLastDblClick := GetTickCount;
                      end;
                    end;
  WM_LBUTTONDOWN: begin
                    if SEdit <> nil then
                    begin
                      D := SEdit.CustomData;
                      if not SEdit.Focused then
                      begin
                        SEdit.Focused := True;
                        // don't delete selection if the edit wasn't focused previously
                        if SEdit.SelAvail then Exit;
                      end;

                      if not PtInRect(D.FGutterRect, MakePoint(LoWord(Msg.lParam), HiWord(Cardinal(Msg.lParam)))) then
                      begin
                      // MouseDown will also be called when the mouse has been clicked twice (double click),
                      // hence we can handle the triple click stuff herein too
                      if (eoTripleClicks in D.FOptions) and (not Msg.wParam and MK_LBUTTON = 0) and (D.FLastDblClick > 0) then
                      begin
                        if (GetTickCount - D.FLastDblClick) < D.FDoubleClickTime then
                        begin
                          SEdit.TripleClick;
                          Exit;
                        end;
                        D.FLastDblClick := 0;
                      end;

                      SetCapture(SEdit.GetWindowHandle);
                      // keep last cursor position to restore it in case of cancelled drag operation
                      D.FLastCaret := SEdit.CaretXY;
                      SEdit.ComputeCaret(LoWord(Msg.lParam), HiWord(Cardinal(Msg.lParam)));
                      if {(not Msg.wParam and MK_CONTROL = 0) and}
                         SEdit.PosInSelection(SEdit.PositionFromPoint(LoWord(Msg.lParam), HiWord(Cardinal(Msg.lParam)))) then
                      begin
                        SEdit.DragItem(SEdit.DragCallback);
                        D.FDragWasStarted := False;
                      end
                      else begin
                        if (not Msg.wParam and MK_SHIFT = 0) then SEdit.SetBlockEnd(SEdit.CaretXY)
                                                             else SEdit.SetBlockBegin(SEdit.CaretXY);
                      end;
                    end;
                  end;
                  end;
  WM_LBUTTONUP: begin
                  if SEdit <> nil then
                    begin
                      D := SEdit.CustomData;
                      D.FMultiClicked := False;
                      D.FScrollTimer.enabled := False;
                      ReleaseCapture;
                    end;
                end;
  WM_KEYUP: begin
              if SEdit <> nil then
                begin
                  D := SEdit.CustomData;
                  D.FKeyHandled := False;
                  Rslt := 0;
                end;
            end;
  WM_KEYDOWN: begin
                if SEdit <> nil then
                begin
                  D := SEdit.CustomData;
                  Data := nil;
                  try
                    Cmd := SEdit.TranslateKeyCode(Msg.wParam, KeyDataToShiftState(0), Data);
                    if Cmd <> ecNone then
                    begin
                      D.FKeyHandled := True;
                      SEdit.CommandProcessor(Cmd, WideNull, Data);
                    end;
                  finally
                    if Data <> nil then FreeMem(Data);
                  end;
                  Rslt := 0;
                end;
              end;
  WM_CHAR: begin
                 if SEdit <> nil then
                 begin
                   D := SEdit.CustomData;
                   if not D.FKeyHandled then
                     SEdit.CommandProcessor(ecChar, KeyUnicode(Chr(Msg.wParam)), nil);
                   Rslt := 0;
                 end;
               end;
  WM_PAINT: begin
              if SEdit <> nil then
              begin
                BeginPaint(SEdit.Handle,PS);
                SEdit.Paint;
                if assigned( SEdit.Canvas ) then
                  SEdit.Canvas.Handle:=0;
                EndPaint(SEdit.Handle,PS);
                Result:=True;
                Rslt:=0;
              end;
            end;
  WM_SYSCHAR: if (Msg.wParam = VK_BACK) and ((Msg.lParam and $20000000) <> 0) then Rslt := 0;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.RecordState(IncludeText: Boolean): TEditState;

// prepare the result structure so it can be used for undo-regstration
begin
  with Result do
  begin
    if IncludeText then Text := GetSelText
                   else Text := '';
    Caret := CaretXY;
    SelStart := PSyntaxEditData(CustomData).FBlockBegin;
    SelEnd := PSyntaxEditData(CustomData).FBlockEnd;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.PositionFromPoint(X, Y: Integer): TPoint;

// calculates the column/line position from the given pixel coordinates (which must
// be in client coordinates)

begin
  // note: for the column value a real division with round is used (instead of
  // an integer div) to automatically switch to the proper column depending on
  // whether the position is before the half width of the column or after
  Result := MakePoint(Round((X - PSyntaxEditData(CustomData).FOffsetX - PSyntaxEditData(CustomData).FGutterRect.Right + 1) / PSyntaxEditData(CustomData).FCharWidth), Y div PSyntaxEditData(CustomData).FTextHeight - PSyntaxEditData(CustomData).FOffsetY);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ComputeCaret(X, Y: Integer);

// sets the caret to the line/column indicated by the given pixel position

var
  EditState: TEditState;
  NewCaret: TPoint;

begin
  EditState := RecordState(False);
  CaretXY := PositionFromPoint(X, Y);
  with EditState do
    if not PointsAreEqual(CaretXY, Caret) then
    begin
      NewCaret := CaretXY;
      PSyntaxEditData(CustomData).FUndoList.AddChange(ecrCursorMove, '', @Caret, @SelStart, @SelEnd,
                                         '', @NewCaret, nil, nil);
    end;
  UpdateWindow(Handle);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.PosInSelection(Pos: TPoint): Boolean;

// determines whether the given position (line/column reference) is in the currrent
// selection block

var
  BB, BE: PPoint;

begin
  Result := False;
  if SelAvail then
  begin
    BB := MinPointAsReference(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
    BE := MaxPointAsReference(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
    if BB.Y = BE.Y then Result := (Pos.Y = BB.Y) and (Pos.X >= BB.X) and (Pos.X <= BE.X)
                   else
      Result := ((Pos.Y > BB.Y) and (Pos.Y < BE.Y)) or
                ((Pos.Y = BB.Y) and (Pos.X >= BB.X)) or
                ((Pos.Y = BE.Y) and (Pos.X <= BE.X));
    // so far so good, let's also take into account when
    // the block end is beyond a line end
    if Result and (Pos.Y = BE.Y) then
      Result := Cardinal(Pos.X) < GetLineEnd(Pos.Y);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.CopyToClipboard;

var
  Data: THandle;
  DataPtr: Pointer;
  Sz: Cardinal;
  S: WideString;

begin
  // Delphi's TClipboard does not support Unicode (D5 and lower) hence we
  // need to handle the stuff "manually"
  if SelAvail then
  begin
    if not OpenClipboard( 0 ) then Exit;
    EmptyClipboard;
    S := SelText;
    Sz := Length(S);
    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, 2 * Sz + 2);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(PWideChar(S)^, DataPtr^, 2 * Sz + 2);
        SetClipboardData(CF_UNICODETEXT, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
    CloseClipboard;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.CutToClipboard;

var
  State: TEditState;

begin
  if SelAvail then
  begin
    State := RecordState(True);
    CopyToClipboard;
    SetSelText('');
    with State do
      PSyntaxEditData(CustomData).FUndoList.AddChange(ecrDelete, Text, @Caret, @SelStart, @SelEnd);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.PasteFromClipboard;

var
  State: TEditState;
  BB, BE: TPoint;
  Data: THandle;

begin
  if not OpenClipboard(0) then Exit;
  // normal text is automatically converted to Unicode if requested from the clipboard
  if IsClipboardFormatAvailable(CF_UNICODETEXT) then
  begin
    State := RecordState(True);
    // keep the position at which the new text will be inserted
    BB := MinPoint(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);

    // Delphi's TClipboard does not support Unicode (D5 and lower) hence we
    // need to handle the stuff "manually"
    Data := GetClipboardData(CF_UNICODETEXT);
    try
      if Data <> 0 then SetSelText(PWideChar(GlobalLock(Data)));
    finally
      if Data <> 0 then GlobalUnlock(Data);
    end;
    // keep end of text block we just inserted
    BE := CaretXY;

    Data := GetClipboardData(CF_TEXT);
    try
      if Data <> 0 then
        with State do PSyntaxEditData(CustomData).FUndoList.AddChange(ecrReplace, Text, @Caret, @SelStart, @SelEnd, PChar(GlobalLock(Data)), @BE, @BB, @BE);
    finally
      if Data <> 0 then GlobalUnlock(Data);
    end;
  end;
  CloseClipboard;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetBlockBegin: TPoint;

begin
  Result := MinPoint(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetBlockEnd: TPoint;

begin
  Result := MaxPoint(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.CaretXPix: Integer;

begin
  Result := PSyntaxEditData(CustomData).FCaretX * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FGutterRect.Right + 1 + PSyntaxEditData(CustomData).FOffsetX;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.CaretYPix: Integer;

begin
  Result := (PSyntaxEditData(CustomData).FCaretY + PSyntaxEditData(CustomData).FOffsetY) * PSyntaxEditData(CustomData).FTextHeight;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.FontChanged(Sender: PGraphicTool);

var
  DC: HDC;
  Save: THandle;
  Metrics: TTextMetric;
  TMFont: HFONT;
  TMLogFont: TLogFont;

begin
  //GetObject(Font.Handle, SizeOf(TLogFont), @TMLogFont);
  TMLogFont := Font.LogFontStruct;
  // We need to get the font with bold and italics set so we have enough room
  // for the widest character it will draw.  This is because fixed pitch fonts
  // always have the same character width, but ONLY when the same attributes
  // are being used.  That is, a bold character can be wider than a non-bold
  // character in a fixed pitch font.

  TMLogFont.lfWeight := FW_BOLD;
  TMLogFont.lfItalic := 1;
  TMFont := CreateFontIndirect(TMLogFont);
  try
    DC := GetDC(0);
    try
      Save := SelectObject(DC, TMFont);
      GetTextMetrics(DC, Metrics);
      SelectObject(DC, Save);
    finally
      ReleaseDC(0, DC);
    end;
  finally
    DeleteObject(TMFont);
  end;

  with Metrics do
  begin
    // Note:  Through trial-and-error I found that tmAveCharWidth should be used
    // instead of tmMaxCharWidth as you would think. I'm basing this behavior
    // on the Delphi IDE editor behavior. If tmMaxCharWidth is used, we end up
    // with chars being much farther apart than the same font in the IDE.
    //CharWidth := tmAveCharWidth;
    CharWidth := tmAveCharWidth;

    PSyntaxEditData(CustomData).FTextHeight := tmHeight + tmExternalLeading + PSyntaxEditData(CustomData).FExtraLineSpacing;
    if assigned(Parent) then
    begin
      PSyntaxEditData(CustomData).FLinesInWindow := ClientHeight div PSyntaxEditData(CustomData).FTextHeight;
      PSyntaxEditData(CustomData).FCharsInWindow := (ClientWidth - PSyntaxEditData(CustomData).FGutterRect.Right + 1) div PSyntaxEditData(CustomData).FCharWidth;
    end;
    if HandleAllocated then
    begin
      if Focused then
      begin
        HideCaret;
        InitializeCaret;
      end;
      UpdateScrollBars;
    end;
    Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetFont: PGraphicTool;

begin
  Result := inherited GetFont;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetLineCount: Integer;

begin
  Result := PSyntaxEditData(CustomData).FLines.Count;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetLineText: WideString;

// returns the text of the current line, makes sure there is a line by
// creating one if necessary

var
  WasModified: Boolean;

begin
  if PSyntaxEditData(CustomData).FLines.Count = 0 then
  begin
    WasModified := Modified;
    PSyntaxEditData(CustomData).FLines.Add('');
    // It's a dummy line we just have inserted hence we should restore the
    // previous modification state.
    Modified := WasModified;
    if Assigned(PSyntaxEditData(CustomData).FHighlighter) then
    begin
      PSyntaxEditData(CustomData).FHighlighter.ResetRange;
      PSyntaxEditData(CustomData).FLines.Objects[0] := PSyntaxEditData(CustomData).FHighlighter.GetRange;
    end;
  end;                                                 
  Result := PSyntaxEditData(CustomData).FLines.Strings[PSyntaxEditData(CustomData).FCaretY];
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetSelAvail: Boolean;

begin
  Result := ((PSyntaxEditData(CustomData).FBlockBegin.X <> PSyntaxEditData(CustomData).FBlockEnd.X) or (PSyntaxEditData(CustomData).FBlockBegin.Y <> PSyntaxEditData(CustomData).FBlockEnd.Y)) and
            (PSyntaxEditData(CustomData).FLines.Count > 0);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetSelText: WideString;

var
  BB, BE: TPoint;
  BeginX,
  EndX: Integer;
  First, Last: Integer;
  Helper: PWideStringList;

begin
  Result := '';
  if SelAvail then
  begin
    Helper := NewWideStringList;
    BB := BlockBegin;
    BeginX := ColumnToCharIndex(BB);
    BE := BlockEnd;
    EndX := ColumnToCharIndex(BE);
    if BB.Y = BE.Y then Result := Copy(PSyntaxEditData(CustomData).FLines.Strings[BB.Y], BeginX + 1, EndX - BeginX)
                   else
    begin
      First := BB.Y;
      Last := BE.Y;
      Helper.Add(Copy(PSyntaxEditData(CustomData).FLines.Strings[First], BeginX + 1, Length(PSyntaxEditData(CustomData).FLines.Strings[First])));
      Inc(First);
      while First < Last do
      begin
        Helper.Add(PSyntaxEditData(CustomData).FLines.Strings[First]);
        Inc(First);
      end;
      Result := Helper.Text;
      if First < PSyntaxEditData(CustomData).FLines.Count then Result := Result + Copy(PSyntaxEditData(CustomData).FLines.Strings[First], 1, EndX);
    end;
    Helper.Free;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetText: WideString;

begin
  Result := PSyntaxEditData(CustomData).FLines.Text;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetTopLine: Integer;

begin
  Result := -PSyntaxEditData(CustomData).FOffsetY + 1;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.HideCaret;

begin
  if PSyntaxEditData(CustomData).FCaretVisible then PSyntaxEditData(CustomData).FCaretVisible := not Windows.HideCaret(Handle);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.LinesChanged(Sender: PObj);

begin
  if HandleAllocated then
  begin
    UpdateScrollBars;
    if Assigned(PSyntaxEditData(CustomData).FHighlighter) then ScanFrom(PSyntaxEditData(CustomData).FCaretY);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.TripleClick;

// mark entire line if the user clicked three times within the double click interval

begin
  PSyntaxEditData(CustomData).FMultiClicked := True;
  SetBlockBegin(MakePoint(0, CaretY));
  SetBlockEnd(MakePoint(0, CaretY + 1));
  PSyntaxEditData(CustomData).FLastDblClick := 0;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.Paint;

var
  WasVisible: Boolean;

begin
  WasVisible := PSyntaxEditData(CustomData).FCaretVisible;
  if WasVisible then HideCaret;
  PaintGutter(Canvas);
  Canvas.Font.Assign(Font);
  if PSyntaxEditData(CustomData).FLines.Count > 0 then
  begin
    if Assigned(PSyntaxEditData(CustomData).FHighLighter) and
       (eoUseSyntaxHighlighting in PSyntaxEditData(CustomData).FOptions) then PaintHighlighted(Canvas)
                                             else PaintText(Canvas);
  end
  else
    with Canvas^ do
    begin
      Brush.Color := Self.Color;
      FillRect(ClientRect);

      // draw the right margin marker
      Pen.Color := PSyntaxEditData(CustomData).FMarginColor;
      Pen.PenWidth := 1;
      MoveTo(PSyntaxEditData(CustomData).FRightMargin * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FGutterRect.Right + 1 + PSyntaxEditData(CustomData).FOffsetX, 0);
      LineTo(PSyntaxEditData(CustomData).FRightMargin * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FGutterRect.Right + 1 + PSyntaxEditData(CustomData).FOffsetX, ClientHeight);
    end;

  if Assigned(FOnPaint) then FOnPaint(@Self, Canvas.Handle);
  if WasVisible then ShowCaret;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.PaintGutter(TextCanvas: PCanvas);

var
  I: Integer;
  UpdateRect, R, T: TRect;
  StartLine,
  EndLine,
  LineIndex,
  YOffset: Integer;
  Number: String;

begin
  GetClipBox(TextCanvas.Handle, T);
  // draw only if (part of) gutter rect is invalid
  if IntersectRect(UpdateRect, T, PSyntaxEditData(CustomData).FGutterRect) then
  begin
    with TextCanvas^ do
    begin
      Brush.Color := PSyntaxEditData(CustomData).FGutterColor;
      UpdateRect.Left := PSyntaxEditData(CustomData).FGutterRect.Right - 5;
      FillRect(UpdateRect);

      UpdateRect.Right := PSyntaxEditData(CustomData).FGutterRect.Right - 3;
      Pen.Color := clBtnHighlight;
      Pen.PenStyle := psSolid;
      Pen.PenWidth := 1;
      MoveTo(UpdateRect.Right, 0);
      LineTo(UpdateRect.Right, UpdateRect.Bottom);

      Inc(UpdateRect.Right);
      Pen.Color := clBtnShadow;
      MoveTo(UpdateRect.Right, 0);
      LineTo(UpdateRect.Right, UpdateRect.Bottom);

      Inc(UpdateRect.Right, 2);
      Pen.Color := Self.Color;
      Pen.PenWidth := 2;
      MoveTo(UpdateRect.Right, 0);
      LineTo(UpdateRect.Right, UpdateRect.Bottom);

      StartLine := (UpdateRect.Top div PSyntaxEditData(CustomData).FTextHeight) - PSyntaxEditData(CustomData).FOffsetY;
      EndLine := (UpdateRect.Bottom div PSyntaxEditData(CustomData).FTextHeight) - PSyntaxEditData(CustomData).FOffsetY + 1;
      if EndLine > PSyntaxEditData(CustomData).FLines.Count - 1 then EndLine := PSyntaxEditData(CustomData).FLines.Count - 1;
      YOffset := (UpdateRect.Top div PSyntaxEditData(CustomData).FTextHeight) * PSyntaxEditData(CustomData).FTextHeight;
      R := MakeRect(0, YOffset, PSyntaxEditData(CustomData).FGutterRect.Right - 5, YOffset + PSyntaxEditData(CustomData).FTextHeight);

      if eoLineNumbers in PSyntaxEditData(CustomData).FOptions then
      begin
        Font.Assign(PSyntaxEditData(CustomData).FLineNumberFont);
        // make the line numbers showing one-based
        for LineIndex := StartLine + 1 to EndLine + 1 do
        begin
          Number := Int2Str(LineIndex);
          FillRect(R);
          RequiredState(HandleValid or FontValid or BrushValid or ChangingCanvas);
          DrawText(Number, R, DT_VCENTER or DT_RIGHT or DT_SINGLELINE);
          OffsetRect(R, 0, PSyntaxEditData(CustomData).FTextHeight);
        end;
      end;

      // fill rest of gutter rect if necessary
      if R.Top < UpdateRect.Bottom then
      begin
        R.Bottom := UpdateRect.Bottom;
        FillRect(R);
      end;

      if BookMarkOptions.GlyphsVisible then
      begin
        if PSyntaxEditData(CustomData).FBookmarksIL<>nil then
        for I := 0 to 9 do
          with PSyntaxEditData(CustomData).FBookMarks[I] do
            if Visible and (Y >= StartLine) and (Y <= EndLine) then
            begin
              PSyntaxEditData(CustomData).FBookmarksIL.Draw(I, TextCanvas.Handle, PSyntaxEditData(CustomData).FBookmarkOptions.LeftMargin, (Y + PSyntaxEditData(CustomData).FOffsetY) * PSyntaxEditData(CustomData).FTextHeight);
//              PSyntaxEditData(CustomData).FInternalBMList.Draw(I, TextCanvas.Handle, PSyntaxEditData(CustomData).FBookmarkOptions.LeftMargin, (Y + PSyntaxEditData(CustomData).FOffsetY) * PSyntaxEditData(CustomData).FTextHeight);
            end;
      end;
      ExcludeClipRect(Handle, 0, 0, PSyntaxEditData(CustomData).FGutterRect.Right, PSyntaxEditData(CustomData).FGutterRect.Bottom);
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.PaintHighlighted(TextCanvas: PCanvas);

// main drawing routine to paint the control if syntax highlighting is used

var
  YOffset,
  LineIndex,
  PaintOffset,
  OldOffset,
  StartIndex,
  StopIndex,
  TempIndex: Integer;
  BB, BE: PPoint;
  //TokenData: TTokenData;

  I,
  StartLine,
  EndLine: Integer;
  UpdateRect,
  Dummy,
  R: TRect;
  SelStrt,
  SelEnd: Cardinal;
  CurrentStyle: Cardinal; // to optimize drawing selected/unselected text
  ShowSelection,
  ShowLineBreak: Boolean;
  LineBase: PWideChar;

  //--------------- local functions -------------------------------------------

  procedure PaintToken(Start, Len: Cardinal);

  // paints the given string at current paint offset, no control chars are painted,
  // text attributes must be set up already on call;
  // side effects: current paint offset will be updated

  var
    Index,
    Counter: Cardinal;
    P: PWideChar;

  begin
    // replace non-printable characters,
    // calculate update rect for this token (-part) btw.
    P := LineBase + Start;
    OldOffset := PaintOffset;
    Index := Start;
    Counter := Len;
    while Counter > 0 do
    begin
      if P^ < ' ' then P^ := ' ';
      Inc(P);
      Inc(PaintOffset, PSyntaxEditData(CustomData).FCharWidthArray[Index]);
      Inc(Index);
      Dec(Counter);
    end;

    R := MakeRect(OldOffset, YOffset, PaintOffset, YOffset + PSyntaxEditData(CustomData).FTextHeight);
    // finally paint text
    TextCanvas.RequiredState(HandleValid or FontValid or BrushValid or ChangingCanvas);
    ExtTextOutW(TextCanvas.Handle, OldOffset, YOffset, ETO_OPAQUE, @R, LineBase + Start, Len, @PSyntaxEditData(CustomData).FCharWidthArray[Start]);
  end;

  //---------------------------------------------------------------------------

  procedure PaintTokenWithControlChars(Start, Len: Cardinal);

  // paints the given WideString at current paint offset, considers control characters,
  // text attributes must be set up already on call;
  // side effects: current paint offset will be updated

  var
    I,
    Counter: Cardinal;
    Run,
    TabPos: PWideChar;

  begin
    // replace space characters
    Run := LineBase + Start;
    Counter := Len; 
    while Counter > 0 do
    begin
      if Run^ = ' ' then Run^ := DefaultSpaceGlyph;
      Inc(Run);
      Dec(Counter);
    end;
    Run := LineBase + Start;

    Counter := Len;
    with TextCanvas^ do
      while Counter > 0 do
      begin
        // find TAB character
        TabPos := StrScanW(Run, Tabulator);
        // something to draw before tab?
        if Assigned(TabPos) then I := Min(Counter, TabPos - Run)
                            else I := Counter;
        if I > 0 then
        begin
          OldOffset := PaintOffset;
          Inc(PaintOffset, I * Cardinal(PSyntaxEditData(CustomData).FCharWidth));
          R := MakeRect(OldOffset, YOffset, PaintOffset, YOffset + PSyntaxEditData(CustomData).FTextHeight);
          TextCanvas.RequiredState(HandleValid or FontValid or BrushValid or ChangingCanvas);
          ExtTextOutW(Handle, OldOffset, YOffset, ETO_OPAQUE, @R, Run, I, @PSyntaxEditData(CustomData).FCharWidthArray[Start]);
          Inc(Start, I);
          Dec(Counter, I);
          Inc(Run, I);
        end;

        // tab to draw?
        if Assigned(TabPos) then
        begin
          while (TabPos^ = Tabulator) and (Counter > 0) do
          begin
            OldOffset := PaintOffset;
            Inc(PaintOffset, PSyntaxEditData(CustomData).FCharWidthArray[Start]);
            R := MakeRect(OldOffset, YOffset, PaintOffset, YOffset + PSyntaxEditData(CustomData).FTextHeight);

            Windows.SetTextAlign(Handle, TA_CENTER);
            TextCanvas.RequiredState(HandleValid or FontValid or BrushValid or ChangingCanvas);
            ExtTextOutW(Handle, (PaintOffset + OldOffset) div 2, YOffset, ETO_OPAQUE, @R, DefaultTabGlyph, 1, nil);
            Windows.SetTextAlign(Handle, TA_LEFT);
            Inc(Start);
            Dec(Counter);
            Inc(TabPos);
          end;
          Run := TabPos;
        end;
    end;
  end;

  //---------------------------------------------------------------------------

  procedure PaintLineBreak;

  begin
    R := MakeRect(PaintOffset, YOffset, PaintOffset + PSyntaxEditData(CustomData).FCharWidth, YOffset + PSyntaxEditData(CustomData).FTextHeight);
    if IntersectRect(Dummy, R, UpdateRect) then
    begin
      TextCanvas.RequiredState(HandleValid or FontValid or BrushValid or ChangingCanvas);
      ExtTextOutW(TextCanvas.Handle, PaintOffset, YOffset, ETO_OPAQUE, @R, DefaultLineBreakGlyph, 1, Pointer(PSyntaxEditData(CustomData).FCharWidthArray));
    end;
    Inc(PaintOffset, PSyntaxEditData(CustomData).FCharWidth);
  end;

  //--------------- end local functions ---------------------------------------

begin
  with TextCanvas^ do
  begin
    GetClipBox(Handle, UpdateRect);
    // optimize drawing by using the update area
    StartLine := (UpdateRect.Top div PSyntaxEditData(CustomData).FTextHeight) - PSyntaxEditData(CustomData).FOffsetY;
    EndLine := (UpdateRect.Bottom div PSyntaxEditData(CustomData).FTextHeight) - PSyntaxEditData(CustomData).FOffsetY + 1;
    if EndLine > PSyntaxEditData(CustomData).FLines.Count - 1 then EndLine := PSyntaxEditData(CustomData).FLines.Count - 1;

    // The vertical position we will paint at. Start at top and increment by
    // FTextHeight for each iteration of the loop (see bottom of for loop).
    YOffset := (UpdateRect.Top div PSyntaxEditData(CustomData).FTextHeight) * PSyntaxEditData(CustomData).FTextHeight;

    // we will update the highlighter start states for each line we touch to prevent
    // an extra run somewhere, hence unplug the change handler
    PSyntaxEditData(CustomData).FLines.OnChange := nil;

    // tell highlighter which state it should use from now on
    if StartLine < PSyntaxEditData(CustomData).FLines.Count - 1 then
      // already sanned?
      if StartLine <= PSyntaxEditData(CustomData).FLastValidLine then PSyntaxEditData(CustomData).FHighLighter.SetRange(PSyntaxEditData(CustomData).FLines.Objects[StartLine])
                                     else
      begin
        // not yet scanned, so do it now
        I := PSyntaxEditData(CustomData).FLastValidLine;
        // scan all lines up to the start line
        PSyntaxEditData(CustomData).FHighLighter.SetRange(PSyntaxEditData(CustomData).FLines.Objects[I]);
        repeat
          PSyntaxEditData(CustomData).FHighLighter.SetLine(PSyntaxEditData(CustomData).FLines.Strings[I], I);
          while not PSyntaxEditData(CustomData).FHighLighter.GetEOL do PSyntaxEditData(CustomData).FHighLighter.Next;
          Inc(I);
          PSyntaxEditData(CustomData).FLines.Objects[I] := PSyntaxEditData(CustomData).FHighLighter.GetRange;
        until I = StartLine;
        // on exit we have already the correct start state for our painting
      end;

    // determine correct start and end line of selection
    BB := MinPointAsReference(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
    BE := MaxPointAsReference(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);

    ShowLineBreak := (eoShowControlChars in PSyntaxEditData(CustomData).FOptions) and not (eoScrollPastEOL in PSyntaxEditData(CustomData).FOptions);

    // Determine in advance whether to show selection or not.
    // Note: We have four concurrent options determining when to show selection (apart
    //       from SelAvail). These are: focus state, eoReadOnly, eoReadOnlySelection and
    //       eoHideSelection. Given these states one can derive a logic table with 16 results
    //       and from this table get a logical equation. Optimizing this eq. leads to
    //       the four conditions written and described below. If we name the mentioned
    //       states (in the same order as above) with A, B, C and D, respectively, then
    //       the resulting eq. is: Sel = A¬B or AC or ¬B¬D or C¬D.
    // show selection if...
    ShowSelection := // selection is available and
                     SelAvail and (
                       // edit is focused and not read only (then both selection opts have no influence) or
                       (Focused and not (eoReadOnly in PSyntaxEditData(CustomData).FOptions)) or
                       // edit is focused and selection in r/o mode is allowed (then read only and
                       // hide selection when unfocused don't matter) or
                       (Focused and (eoReadOnlySelection in PSyntaxEditData(CustomData).FOptions)) or
                       // edit is not read only and selection will not be hidden when unfocused (then
                       // being focused doesn't matter and r/o selection has no influence) or
                       ((PSyntaxEditData(CustomData).FOptions * [eoReadOnly, eoHideSelection]) = []) or
                       // r/o selection is enabled and selection will not be hidden when unfocused
                       // (then being focused or in r/o mode don't matter)
                       ((eoReadOnlySelection in PSyntaxEditData(CustomData).FOptions) and not (eoHideSelection in PSyntaxEditData(CustomData).FOptions))
                     );

    // loop through the lines which needs repainting
    for LineIndex := StartLine to EndLine do
    begin
      // Tell highlighter what line we are working on.  This will get the first
      // token set up.
      PSyntaxEditData(CustomData).FHighLighter.SetLine(PSyntaxEditData(CustomData).FLines.Strings[LineIndex], LineIndex);
      LineBase := PWideChar(PSyntaxEditData(CustomData).FLines.Strings[LineIndex]);

      PaintOffset := PSyntaxEditData(CustomData).FOffsetX + PSyntaxEditData(CustomData).FGutterRect.Right + 1;
      CalcCharWidths(LineIndex);

      // line marker to draw (overrides selection)?
      if PSyntaxEditData(CustomData).FMarkLine = LineIndex then
      begin
        Font.Color := PSyntaxEditData(CustomData).FMarkColor.Foreground;
        Brush.Color := PSyntaxEditData(CustomData).FMarkColor.Background;
        while not PSyntaxEditData(CustomData).FHighLighter.GetEOL do
        begin
          //TokenData := PSyntaxEditData(CustomData).FHighLighter.GetTokenInfo;
          Font.FontStyle := PSyntaxEditData(CustomData).FHighLighter.GetTokenAttribute.Style;
          if eoShowControlChars in PSyntaxEditData(CustomData).FOptions then PaintTokenWithControlChars(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos, Length(PSyntaxEditData(CustomData).FHighLighter.GetToken))
                                              else PaintToken(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos, Length(PSyntaxEditData(CustomData).FHighLighter.GetToken));
          PSyntaxEditData(CustomData).FHighLighter.Next;
        end;

        Brush.Color := PSyntaxEditData(CustomData).FMarkColor.Background;
        if ShowLineBreak then
        begin
          Font.Color := PSyntaxEditData(CustomData).FMarkColor.Foreground;
          PaintLineBreak;
        end;
      end
      else
        // if no selection is to draw then go straight ahead
        if (LineIndex < BB.Y) or (LineIndex > BE.Y) or not ShowSelection then
        begin
          while not PSyntaxEditData(CustomData).FHighLighter.GetEOL do
          begin
            Font.FontStyle := PSyntaxEditData(CustomData).FHighLighter.GetTokenAttribute.Style;
            Font.Color := PSyntaxEditData(CustomData).FHighLighter.GetTokenAttribute.Foreground;
            Brush.Color := PSyntaxEditData(CustomData).FHighLighter.GetTokenAttribute.Background;
            if eoShowControlChars in PSyntaxEditData(CustomData).FOptions then PaintTokenWithControlChars(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos, Length(PSyntaxEditData(CustomData).FHighLighter.GetToken))
                                                else PaintToken(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos, Length(PSyntaxEditData(CustomData).FHighLighter.GetToken));
            PSyntaxEditData(CustomData).FHighLighter.Next;
          end;


          Brush.Color := Self.Color;
          if ShowLineBreak then
          begin
            Font.Color := Font.Color;
            PaintLineBreak;
          end;
        end
        else
        begin
          // selection parts are to be considered, so determine start and end position of
          // the selection on this particular line
          if BB.Y < LineIndex then SelStrt := 0
                              else SelStrt := ColumnToCharIndex(MakePoint(BB.X, LineIndex));
          if BE.Y > LineIndex then SelEnd := PSyntaxEditData(CustomData).FMaxRightPos // any large number makes it here
                              else SelEnd := ColumnToCharIndex(MakePoint(BE.X, LineIndex));

          CurrentStyle := 0;
          StopIndex := 0;
          while not PSyntaxEditData(CustomData).FHighLighter.GetEOL do
          begin
            // set styles which do not change between selected and non-selected parts
            Font.FontStyle := PSyntaxEditData(CustomData).FHighLighter.GetTokenAttribute.Style;
            // start with the beginning of the token
            StartIndex := 0;
            // stop at the end of the token
            StopIndex := Length(PSyntaxEditData(CustomData).FHighLighter.GetToken);
            // Paint up to selection start. That length will be the StopIndex
            // or the start of the selection mark, whichever is less.
            TempIndex := Min(StopIndex + Integer(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos), SelStrt) - StartIndex - Integer(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos);
            if TempIndex > 0 then
            begin
              // set needed styles
              Font.Color := PSyntaxEditData(CustomData).FHighLighter.GetTokenAttribute.Foreground;
              Brush.Color := PSyntaxEditData(CustomData).FHighLighter.GetTokenAttribute.Background;
              CurrentStyle := 1;
              if eoShowControlChars in PSyntaxEditData(CustomData).FOptions then PaintTokenWithControlChars(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos, TempIndex)
                                                else PaintToken(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos, TempIndex);

              // update the start index into the line text to skip past the
              // text we just painted.
              Inc(StartIndex, TempIndex);
            end;

            // Paint the selection text. That length will be the StopIndex or the
            // end of the selection mark, whichever is less.
            TempIndex := Min(StopIndex + Integer(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos), SelEnd) - StartIndex - Integer(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos);
            if TempIndex > 0 then // Have anything to paint?
            begin
              if CurrentStyle <> 2 then // other than selected style?
              begin
                // set the selection highlight colors
                with PSyntaxEditData(CustomData).FSelectedColor^ do
                begin
                  Font.Color := Foreground;
                  Brush.Color := Background;
                end;
                CurrentStyle := 2;
              end;
              // Paint the selection text
              if eoShowControlChars in PSyntaxEditData(CustomData).FOptions then PaintTokenWithControlChars(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos + StartIndex, TempIndex)
                                                  else PaintToken(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos + StartIndex, TempIndex);
              // Update the start index into the line text to skip past the
              // text we just painted.
              Inc(StartIndex, TempIndex);
            end;

            // Paint the post-selection text, the length is whatever is left over.
            TempIndex := StopIndex - StartIndex;
            if TempIndex > 0 then
            begin
              if CurrentStyle <> 1 then // other than unselected style?
              begin
                // set needed styles
                Font.Color := PSyntaxEditData(CustomData).FHighLighter.GetTokenAttribute.Foreground;
                Brush.Color := PSyntaxEditData(CustomData).FHighLighter.GetTokenAttribute.Background;
                CurrentStyle := 1;
              end;
              if eoShowControlChars in PSyntaxEditData(CustomData).FOptions then PaintTokenWithControlChars(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos + StartIndex, TempIndex)
                                                  else PaintToken(PSyntaxEditData(CustomData).FHighLighter.GetTokenPos + StartIndex, TempIndex);
            end;

            if CurrentStyle <> 2 then CurrentStyle := 0;
            PSyntaxEditData(CustomData).FHighLighter.Next;
          end;

          // prepare drawing of the rest of the line
          if LineIndex < BE.Y then Brush.Color := PSyntaxEditData(CustomData).FSelectedColor.Background
                              else Brush.Color := Self.Color;
          if ShowLineBreak then
          begin
            if StopIndex < Integer(SelEnd) then Font.Color := PSyntaxEditData(CustomData).FSelectedColor.Foreground
                                           else Font.Color := Font.Color;
            PaintLineBreak;
          end;
        end;

      // clear background of the rest of the line
      FillRect(MakeRect(PaintOffset, YOffset, UpdateRect.Right, YOffset + PSyntaxEditData(CustomData).FTextHeight));

      // draw the right margin marker
      Pen.Color := PSyntaxEditData(CustomData).FMarginColor;
      Pen.PenWidth := 1;
      MoveTo(PSyntaxEditData(CustomData).FRightMargin * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FOffsetX + PSyntaxEditData(CustomData).FGutterRect.Right + 1, YOffset);
      LineTo(PSyntaxEditData(CustomData).FRightMargin * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FOffsetX + PSyntaxEditData(CustomData).FGutterRect.Right + 1, YOffset + PSyntaxEditData(CustomData).FTextHeight);

      // This line has been painted, increment the vertical offset and loop back
      // for the next line of text.
      Inc(YOffset, PSyntaxEditData(CustomData).FTextHeight);

      // store state value to avoid later rescans
      if (LineIndex + 1) < PSyntaxEditData(CustomData).FLines.Count then PSyntaxEditData(CustomData).FLines.Objects[LineIndex + 1] := PSyntaxEditData(CustomData).FHighLighter.GetRange;
    end;

    // finally erase all the space not covered by lines
    if YOffset < UpdateRect.Bottom then
    begin
      Brush.Color := Self.Color;
      FillRect(MakeRect(UpdateRect.Left, YOffset, UpdateRect.Right, UpdateRect.Bottom));

      // draw the right margin marker
      Pen.Color := PSyntaxEditData(CustomData).FMarginColor;
      Pen.PenWidth := 1;
      MoveTo(PSyntaxEditData(CustomData).FRightMargin * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FOffsetX + PSyntaxEditData(CustomData).FGutterRect.Right + 1, YOffset);
      LineTo(PSyntaxEditData(CustomData).FRightMargin * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FOffsetX + PSyntaxEditData(CustomData).FGutterRect.Right + 1, UpdateRect.Bottom);
    end;

    if EndLine > PSyntaxEditData(CustomData).FLastValidLine then PSyntaxEditData(CustomData).FLastValidLine := EndLine;
    PSyntaxEditData(CustomData).FLines.OnChange := LinesChanged;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.PaintText(TextCanvas: PCanvas);

// main drawing routine to paint the control if no syntax highlighting is used

var
  YOffset,
  LineIndex,
  PaintOffset,
  OldOffset,
  StartIndex,
  StopIndex,
  TempIndex: Integer;
  BB, BE: PPoint;
  TokenLen : Integer;

  StartLine,
  EndLine: Integer;
  UpdateRect,
  Dummy,
  R: TRect;
  SelStrt,
  SelEnd: Integer;
  ShowSelection: Boolean;
  ShowLineBreak: Boolean;
  LineBase: PWideChar;

  //--------------- local functions -------------------------------------------

  procedure PaintToken(Start, Len: Cardinal);

  // paints the given WideString at current paint offset, no control chars are painted,
  // text attributes must be set up already on call;
  // side effects: current paint offset will be updated

  var
    Index,
    Counter: Cardinal;
    P: PWideChar;

  begin
    // replace non-printable characters,
    // calculate update rect for this token (-part) btw.
    P := LineBase + Start;
    OldOffset := PaintOffset;
    Index := Start;
    Counter := Len;
    while Counter > 0 do
    begin
      if P^ < ' ' then P^ := ' ';
      Inc(P);
      Inc(PaintOffset, PSyntaxEditData(CustomData).FCharWidthArray[Index]);
      Inc(Index);
      Dec(Counter);
    end;
    R := MakeRect(OldOffset, YOffset, PaintOffset, YOffset + PSyntaxEditData(CustomData).FTextHeight);
    // finally paint text
    TextCanvas.RequiredState(HandleValid or FontValid or BrushValid or ChangingCanvas);
    ExtTextOutW(TextCanvas.Handle, OldOffset, YOffset, ETO_OPAQUE, @R, LineBase + Start, Len, @PSyntaxEditData(CustomData).FCharWidthArray[Start]);
  end;

  //---------------------------------------------------------------------------

  procedure PaintTokenWithControlChars(Start, Len: Cardinal);

  // paints the given string at current paint offset, considers control characters,
  // text attributes must be set up already on call;
  // side effects: current paint offset will be updated

  var
    I,
    Counter: Cardinal;
    Run,
    TabPos: PWideChar;

  begin
    // replace space characters
    Run := LineBase + Start;
    Counter := Len;
    while Counter > 0 do
    begin
      if Run^ = ' ' then Run^ := DefaultSpaceGlyph;
      Inc(Run);
      Dec(Counter);
    end;

    Run := LineBase + Start;
    Counter := Len;
    with TextCanvas^ do
      while Counter > 0 do
      begin
        // find TAB character
        TabPos := StrScanW(Run, Tabulator);
        // something to draw before tab?
        if Assigned(TabPos) then I := Min(Counter, TabPos - Run)
                            else I := Counter;
        if I > 0 then
        begin
          OldOffset := PaintOffset;
          Inc(PaintOffset, I * Cardinal(PSyntaxEditData(CustomData).FCharWidth));
          R := MakeRect(OldOffset, YOffset, PaintOffset, YOffset + PSyntaxEditData(CustomData).FTextHeight);
          TextCanvas.RequiredState(HandleValid or FontValid or BrushValid or ChangingCanvas);
          ExtTextOutW(Handle, OldOffset, YOffset, ETO_OPAQUE, @R, Run, I, @PSyntaxEditData(CustomData).FCharWidthArray[Start]);
          Inc(Start, I);
          Dec(Counter, I);
          Inc(Run, I);
        end;

        // tab to draw?
        if Assigned(TabPos) then
        begin
          while (TabPos^ = Tabulator) and (Counter > 0) do
          begin
            OldOffset := PaintOffset;
            Inc(PaintOffset, PSyntaxEditData(CustomData).FCharWidthArray[Start]);
            R := MakeRect(OldOffset, YOffset, PaintOffset, YOffset + PSyntaxEditData(CustomData).FTextHeight);

            Windows.SetTextAlign(Handle, TA_CENTER);
            TextCanvas.RequiredState(HandleValid or FontValid or BrushValid or ChangingCanvas);
            ExtTextOutW(Handle, (PaintOffset + OldOffset) div 2, YOffset, ETO_OPAQUE, @R, DefaultTabGlyph, 1, nil);
            Windows.SetTextAlign(Handle, TA_LEFT);
            Inc(Start);
            Dec(Counter);
            Inc(TabPos);
          end;
          Run := TabPos;
        end;
      end;
  end;

  //---------------------------------------------------------------------------

  procedure PaintLineBreak;

  begin
    R := MakeRect(PaintOffset, YOffset, PaintOffset + PSyntaxEditData(CustomData).FCharWidth, YOffset + PSyntaxEditData(CustomData).FTextHeight);
    if IntersectRect(Dummy, R, UpdateRect) then
    begin
      TextCanvas.RequiredState(HandleValid or FontValid or BrushValid or ChangingCanvas);
      ExtTextOutW(TextCanvas.Handle, PaintOffset, YOffset, ETO_OPAQUE, @R, DefaultLineBreakGlyph, 1, Pointer(PSyntaxEditData(CustomData).FCharWidthArray));
    end;
    Inc(PaintOffset, PSyntaxEditData(CustomData).FCharWidth);
  end;

  //--------------- end local functions ---------------------------------------

begin
  with TextCanvas^ do
  begin
    //Font.Assign(PSyntaxEditData(CustomData).FFontDummy);
    Font.Assign(Self.Font);
    GetClipBox(Handle, UpdateRect);
    // optimize drawing by using the update area
    StartLine := (UpdateRect.Top div PSyntaxEditData(CustomData).FTextHeight) - PSyntaxEditData(CustomData).FOffsetY;
    EndLine := (UpdateRect.Bottom div PSyntaxEditData(CustomData).FTextHeight) - PSyntaxEditData(CustomData).FOffsetY + 1;
    if EndLine > PSyntaxEditData(CustomData).FLines.Count - 1 then EndLine := PSyntaxEditData(CustomData).FLines.Count - 1;

    // The vertical position we will paint at. Start at top and increment by
    // FTextHeight for each iteration of the loop (see bottom of for loop).
    YOffset := (UpdateRect.Top div PSyntaxEditData(CustomData).FTextHeight) * PSyntaxEditData(CustomData).FTextHeight;

    // determine correct start and end line of selection
    BB := MinPointAsReference(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
    BE := MaxPointAsReference(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);

    ShowLineBreak := (eoShowControlChars in PSyntaxEditData(CustomData).FOptions) and not (eoScrollPastEOL in PSyntaxEditData(CustomData).FOptions);

    // Determine in advance whether to show selection or not.
    // Note: We have four concurrent options determining when to show selection (apart
    //       from SelAvail). These are: focus state, eoReadOnly, eoReadOnlySelection and
    //       eoHideSelection. Given these states one can derive a logic table with 16 results
    //       and from this table get a logical equation. Optimizing this eq. leads to
    //       the four conditions written and described below. If we name the mentioned
    //       states (in the same order as above) with A, B, C and D, respectively, then
    //       the resulting eq. is: Sel = A¬B or AC or ¬B¬D or C¬D.
    // show selection if...
    ShowSelection := // selection is available and
                     SelAvail and (
                       // edit is focused and not read only (then both selection opts have no influence) or
                       (Focused and not (eoReadOnly in PSyntaxEditData(CustomData).FOptions)) or
                       // edit is focused and selection in r/o mode is allowed (then read only and
                       // hide selection when unfocused don't matter) or
                       (Focused and (eoReadOnlySelection in PSyntaxEditData(CustomData).FOptions)) or
                       // edit is not read only and selection will not be hidden when unfocused (then
                       // being focused doesn't matter and r/o selection has no influence) or
                       ((PSyntaxEditData(CustomData).FOptions * [eoReadOnly, eoHideSelection]) = []) or
                       // r/o selection is enabled and selection will not be hidden when unfocused
                       // (then being focused or in r/o mode don't matter)
                       ((eoReadOnlySelection in PSyntaxEditData(CustomData).FOptions) and not (eoHideSelection in PSyntaxEditData(CustomData).FOptions))
                     );

    // Loop from the top line in the window to the last line in the window.
    for LineIndex := StartLine to EndLine do
    begin
      PaintOffset := PSyntaxEditData(CustomData).FOffsetX + PSyntaxEditData(CustomData).FGutterRect.Right + 1;
      LineBase := PWideChar(PSyntaxEditData(CustomData).FLines.Strings[LineIndex]);
      TokenLen := Length(PSyntaxEditData(CustomData).FLines.Strings[LineIndex]);

      CalcCharWidths(LineIndex);

      // line marker to draw (overrides selection)?
      if (PSyntaxEditData(CustomData).FMarkLine = LineIndex) or
         ((LineIndex < BB.Y) or (LineIndex > BE.Y) or not ShowSelection) then
      begin
        if PSyntaxEditData(CustomData).FMarkLine = LineIndex then
        begin
          Font.Color := PSyntaxEditData(CustomData).FMarkColor.Foreground;
          Brush.Color := PSyntaxEditData(CustomData).FMarkColor.Background;
        end
        else
        begin
          Font.Color := Self.Font.Color;
          Brush.Color := Self.Color;
        end;

        if TokenLen > 0 then
          if eoShowControlChars in PSyntaxEditData(CustomData).FOptions then PaintTokenWithControlChars(0, TokenLen)
                                            else PaintToken(0, TokenLen);

        if ShowLineBreak then PaintLineBreak;
      end
      else
      begin
        // selection parts are to be considered, so determine start and end position of
        // the selection on this particular line
        if BB.Y < LineIndex then SelStrt := 0
                            else SelStrt := ColumnToCharIndex(MakePoint(BB.X, LineIndex));
        if BE.Y > LineIndex then SelEnd := PSyntaxEditData(CustomData).FMaxRightPos // any large number makes it here
                            else SelEnd := ColumnToCharIndex(MakePoint(BE.X, LineIndex));

        Font.Color := Font.Color;
        Brush.Color := Self.Color;
        // start with the beginning of the token
        StartIndex := 0;
        StopIndex := TokenLen;

        // Paint up to selection start. That length will be the StopIndex
        // or the start of the selection mark, whichever is less.
        TempIndex := Min(TokenLen, SelStrt);
        if TempIndex > 0 then
        begin
          // set needed styles
          Font.Color := Self.Font.Color;
          Brush.Color := Self.Color;
          if eoShowControlChars in PSyntaxEditData(CustomData).FOptions then PaintTokenWithControlChars(0, TempIndex)
                                            else PaintToken(0, TempIndex);
          // update the start index into the line text to skip past the
          // text we just painted.
          Inc(StartIndex, TempIndex);
        end;

        // Paint the selection text. That length will be the StopIndex or the
        // end of the selection mark, whichever is less.
        TempIndex := Min(StopIndex, SelEnd) - StartIndex;
        if TempIndex > 0 then // Have anything to paint?
        begin
          // set the selection highlight colors
          with PSyntaxEditData(CustomData).FSelectedColor^ do
          begin
            Font.Color := Foreground;
            Brush.Color := Background;
          end;
          // paint the selection text
          if eoShowControlChars in PSyntaxEditData(CustomData).FOptions then PaintTokenWithControlChars(StartIndex, TempIndex)
                                            else PaintToken(StartIndex, TempIndex);
          // Update the start index into the line text to skip past the
          // text we just painted.
          Inc(StartIndex, TempIndex);
        end;

        // Paint the post-selection text, the length is whatever is left over.
        TempIndex := StopIndex - StartIndex;
        if TempIndex > 0 then
        begin
            // set needed styles
          Font.Color := Self.Font.Color;
          Brush.Color := Self.Color;
          if eoShowControlChars in PSyntaxEditData(CustomData).FOptions then PaintTokenWithControlChars(StartIndex, TempIndex)
                                            else PaintToken(StartIndex, TempIndex);
        end;

        // prepare drawing of the rest of the line
        if LineIndex < BE.Y then Brush.Color := PSyntaxEditData(CustomData).FSelectedColor.Background
                            else Brush.Color := Self.Color;
        if ShowLineBreak then
        begin
          if StopIndex < Integer(SelEnd) then Font.Color := PSyntaxEditData(CustomData).FSelectedColor.Foreground
                                         else Font.Color := Font.Color;
          PaintLineBreak;
        end;
      end;

      // clear background of the rest of the line
      FillRect(MakeRect(PaintOffset, YOffset, UpdateRect.Right, YOffset + PSyntaxEditData(CustomData).FTextHeight));

      // draw the right margin marker
      Pen.Color := PSyntaxEditData(CustomData).FMarginColor;
      Pen.PenWidth := 1;
      MoveTo(PSyntaxEditData(CustomData).FRightMargin * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FOffsetX + PSyntaxEditData(CustomData).FGutterRect.Right + 1, YOffset);
      LineTo(PSyntaxEditData(CustomData).FRightMargin * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FOffsetX + PSyntaxEditData(CustomData).FGutterRect.Right + 1, YOffset + PSyntaxEditData(CustomData).FTextHeight);

      // This line has been painted, increment the vertical offset and loop back
      // for the next line of text.
      Inc(YOffset, PSyntaxEditData(CustomData).FTextHeight);
    end;

    // finally erase all the space not covered by lines
    if YOffset < UpdateRect.Bottom then
    begin
      Brush.Color := Self.Color;
      FillRect(MakeRect(UpdateRect.Left, YOffset, UpdateRect.Right, UpdateRect.Bottom));

      // draw the right margin marker
      Pen.Color := PSyntaxEditData(CustomData).FMarginColor;
      Pen.PenWidth := 1;
      MoveTo(PSyntaxEditData(CustomData).FRightMargin * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FOffsetX + PSyntaxEditData(CustomData).FGutterRect.Right + 1, YOffset);
      LineTo(PSyntaxEditData(CustomData).FRightMargin * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FOffsetX + PSyntaxEditData(CustomData).FGutterRect.Right + 1, UpdateRect.Bottom);
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SelectAll;

var
  State: TEditState;
  Caret: TPoint;

begin
  if PSyntaxEditData(CustomData).FLines.Count > 0 then
  begin
    State := RecordState(False);
    SetBlockBegin(MakePoint(0, 0));
    SetBlockEnd(MakePoint(Length(PSyntaxEditData(CustomData).FLines.Strings[PSyntaxEditData(CustomData).FLines.Count - 1]) + 1, PSyntaxEditData(CustomData).FLines.Count - 1));
    Caret := MakePoint(Length(PSyntaxEditData(CustomData).FLines.Strings[PSyntaxEditData(CustomData).FLines.Count - 1]) + 1, PSyntaxEditData(CustomData).FLines.Count - 1);
    CaretXY := Caret;
    Invalidate;

    PSyntaxEditData(CustomData).FUndoList.AddChange(ecrCursorMove, '', @State.Caret, @State.SelStart, @State.SelEnd,
                                       '', @Caret, @PSyntaxEditData(CustomData).FBlockBegin, @PSyntaxEditData(CustomData).FBlockEnd);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetBlockBegin(Value: TPoint);

begin
  if Value.X < 0 then Value.X := 0
                 else
    if Value.X > MaxRightChar then Value.X := MaxRightChar;
  if Value.Y < 0 then Value.Y := 0
                 else
    if Value.Y > PSyntaxEditData(CustomData).FLines.Count then Value.Y := PSyntaxEditData(CustomData).FLines.Count;
  if (FUpdateCount = 0) and SelAvail then InvalidateLines(PSyntaxEditData(CustomData).FBlockBegin.Y, PSyntaxEditData(CustomData).FBlockEnd.Y);
  PSyntaxEditData(CustomData).FBlockBegin := Value;
  PSyntaxEditData(CustomData).FBlockEnd := Value;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetBlockEnd(Value: TPoint);

begin
  if Value.X < 0 then Value.X := 0
                 else
    if Value.X > MaxRightChar then Value.X := MaxRightChar;
  if Value.Y < 0 then Value.Y := 0
                 else
    if Value.Y > PSyntaxEditData(CustomData).FLines.Count then Value.Y := PSyntaxEditData(CustomData).FLines.Count;

  if (PSyntaxEditData(CustomData).FBlockEnd.X <> Value.X) or (PSyntaxEditData(CustomData).FBlockEnd.Y <> Value.Y) then
  begin
    if FUpdateCount = 0 then InvalidateLines(Value.Y, PSyntaxEditData(CustomData).FBlockEnd.Y);
    PSyntaxEditData(CustomData).FBlockEnd := Value;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetCaretX(Value: Integer);

var
  I: Integer;

begin
  if Value < 0 then Value := 0;

  if PSyntaxEditData(CustomData).FCaretX <> Value then
  begin
    I := GetLineEnd + 1;
    if eoScrollPastEOL in PSyntaxEditData(CustomData).FOptions then
    begin
      if Value > MaxRightChar then Value := MaxRightChar;
    end
    else
    begin
      if Value > I then Value := I;
    end;
    PSyntaxEditData(CustomData).FCaretX := Value;
    EnsureCursorPosVisible;
    if FUpdateCount = 0 then
    begin
      UpdateCaret;
      DoCaretChange;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetCaretY(Value: Integer);

var
  Len: Integer;

begin
  if (Value < 0) or (PSyntaxEditData(CustomData).FLines.Count = 0) then Value := 0;
  if (PSyntaxEditData(CustomData).FLines.Count > 0) and (Value > PSyntaxEditData(CustomData).FLines.Count - 1) then Value := PSyntaxEditData(CustomData).FLines.Count - 1;
  if PSyntaxEditData(CustomData).FCaretY <> Value then
  begin
    // remove trailing blanks in line we just leaving
    if (PSyntaxEditData(CustomData).FCaretY > -1) and
       (PSyntaxEditData(CustomData).FCaretY < PSyntaxEditData(CustomData).FLines.Count) and
       not (eoKeepTrailingBlanks in PSyntaxEditData(CustomData).FOptions) then PSyntaxEditData(CustomData).FLines.Strings[PSyntaxEditData(CustomData).FCaretY] := WideTrimRight(PSyntaxEditData(CustomData).FLines.Strings[PSyntaxEditData(CustomData).FCaretY]);
    PSyntaxEditData(CustomData).FCaretY := Value;

    if not (eoScrollPastEOL in PSyntaxEditData(CustomData).FOptions) then
    begin
      Len := Length(LineText);
      if PSyntaxEditData(CustomData).FCaretX > Len then
      begin
        CaretX := Len;
        if PSyntaxEditData(CustomData).FCaretX < -PSyntaxEditData(CustomData).FOffsetX * PSyntaxEditData(CustomData).FCharWidth then SetOffsetX(PSyntaxEditData(CustomData).FCaretX * PSyntaxEditData(CustomData).FCharWidth);
        Exit;
      end;
    end;
    EnsureCursorPosVisible;
    if FUpdateCount = 0 then
    begin
      UpdateCaret;
      DoCaretChange;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetFont(const Value: PGraphicTool);

var
  SavePitch: TFontPitch;

begin
  SavePitch := Value.FontPitch;
  Value.FontPitch := fpFixed;
  Font.Assign(Value);
  Value.FontPitch := SavePitch;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetGutterWidth(Value: Integer);

var
  OldValue: Integer;

begin
  OldValue := GutterWidth;
  if OldValue <> Value then
  begin
    if Value < 0 then Value := 0;
    PSyntaxEditData(CustomData).FGutterWidth := Value;
    PSyntaxEditData(CustomData).FGutterRect.Right := Value - 1;
    PSyntaxEditData(CustomData).FCharsInWindow := (ClientWidth - PSyntaxEditData(CustomData).FGutterRect.Right + 1) div PSyntaxEditData(CustomData).FCharWidth;
    UpdateCaret;
    UpdateScrollBars;
    Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetOffsetX(Value: Integer);

var
  dX: Integer;
  R: TRect;

begin
  if -Value > (PSyntaxEditData(CustomData).FMaxRightPos - ClientWidth + PSyntaxEditData(CustomData).FGutterRect.Right) then Value := -(PSyntaxEditData(CustomData).FMaxRightPos - ClientWidth + PSyntaxEditData(CustomData).FGutterRect.Right);
  if Value > 0 then Value := 0;
  if PSyntaxEditData(CustomData).FOffsetX <> Value then
  begin
    dX := Value - PSyntaxEditData(CustomData).FOffsetX;
    PSyntaxEditData(CustomData).FOffsetX := Value;
    R := MakeRect(PSyntaxEditData(CustomData).FGutterRect.Right + 1, 0, ClientWidth, ClientHeight);
    ScrollWindow(Handle, dX, 0, nil, @R);
    if (CaretXPix + PSyntaxEditData(CustomData).FCaretOffset.X) < (PSyntaxEditData(CustomData).FGutterRect.Right + 1) then HideCaret
                                                              else ShowCaret;
    if FUpdateCount = 0 then
    begin
      UpdateWindow(Handle);
      UpdateScrollbars;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetOffsetY(Value: Integer);

// this offset is measured in lines not pixels

var
  dY: Integer;

begin
  // range check, order is important here
  if Value < (PSyntaxEditData(CustomData).FLinesInWindow - PSyntaxEditData(CustomData).FLines.Count) then Value := PSyntaxEditData(CustomData).FLinesInWindow - PSyntaxEditData(CustomData).FLines.Count;
  if Value > 0 then Value := 0;
  if PSyntaxEditData(CustomData).FOffsetY <> Value then
  begin
    dY := PSyntaxEditData(CustomData).FTextHeight * (Value - PSyntaxEditData(CustomData).FOffsetY);
    PSyntaxEditData(CustomData).FOffsetY := Value;
    ScrollWindow(Handle, 0, dY, nil, nil);
    if FUpdateCount = 0 then
    begin
      UpdateWindow(Handle);
      UpdateScrollbars;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetLines(Value: PSyntaxEditorStrings);

begin
  if HandleAllocated then
  begin
    PSyntaxEditData(CustomData).FLines := Value;
    Invalidate;
    Update;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetLineText(Value: WideString);

begin
  if PSyntaxEditData(CustomData).FLines.Count = 0 then
  begin
    PSyntaxEditData(CustomData).FLines.Add('');
    if Assigned(PSyntaxEditData(CustomData).FHighlighter) then
    begin
      PSyntaxEditData(CustomData).FHighlighter.ResetRange;
      PSyntaxEditData(CustomData).FLines.Objects[0] := PSyntaxEditData(CustomData).FHighlighter.GetRange;
    end;
  end;
  if PSyntaxEditData(CustomData).FCaretY < PSyntaxEditData(CustomData).FLines.Count then PSyntaxEditData(CustomData).FLines.Strings[PSyntaxEditData(CustomData).FCaretY] := Value;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetScrollBars(const Value: TScrollStyle);

begin
  if (PSyntaxEditData(CustomData).FScrollBars <> Value) then
  begin
    PSyntaxEditData(CustomData).FScrollBars := Value;
    Recreate;
    UpdateScrollBars;
    Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.DeleteSelection(NeedRescan: Boolean);

// Deletes all characters in the current selection and causes the highlighter
// to rescan modified lines if NeedRescan is True. Set this to False if you are going
// to insert new text at the current cursor position afterwards and start the rescan then.

var
  I,
  Cnt,
  Start: Integer;
  TempString,
  TempString2: WideString;
  BB, BE: TPoint;
  BeginX,
  EndX: Integer;

begin
  BB := MinPoint(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
  BeginX := ColumnToCharIndex(BB);
  BE := MaxPoint(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
  EndX := ColumnToCharIndex(BE);

  CaretX := BB.X;
  if BB.Y = BE.Y then
  begin
    TempString := Lines.Strings[BB.Y];
    System.Delete(TempString, BeginX + 1, EndX - BeginX);
    PSyntaxEditData(CustomData).FLines.Strings[BB.Y] := TempString;
    TempString := '';
  end
  else
  begin
    CaretY := BB.Y;
    TempString := PSyntaxEditData(CustomData).FLines.Strings[BB.Y];
    if Length(TempString) < BeginX then TempString := TempString + WideStringOfChar(' ', BeginX - Length(TempString))
                                   else System.Delete(TempString, BeginX + 1, Length(TempString));
    if BE.Y < PSyntaxEditData(CustomData).FLines.Count then
    begin
      TempString2 := PSyntaxEditData(CustomData).FLines.Strings[BE.Y];
      System.Delete(TempString2, 1, EndX);
      TempString := TempString + TempString2;
    end;
    Start := BB.Y;
    Cnt := BE.Y - BB.Y;
    for I:= 0 to 0 do
      if PSyntaxEditData(CustomData).FBookmarks[I].Y >= BE.Y then Dec(PSyntaxEditData(CustomData).FBookmarks[I].Y, Cnt)
                                 else
        if PSyntaxEditData(CustomData).FBookmarks[I].Y > BB.Y then PSyntaxEditData(CustomData).FBookmarks[I].Y := BB.Y;

    try
      for I := Cnt + Start - 1 downto Start do PSyntaxEditData(CustomData).FLines.Delete(I);
    finally
      // don't rescan if strings are empty now or something is to be inserted afterwards
      if Assigned(PSyntaxEditData(CustomData).FHighlighter) and (Start > 0) and NeedRescan then ScanFrom(Start - 1);
    end;
    // if all lines have been removed then TempString can only be an empty WideString
    if Start < PSyntaxEditData(CustomData).FLines.Count then PSyntaxEditData(CustomData).FLines.Strings[Start] := TempString
                                                        else PSyntaxEditData(CustomData).FLines.Add(TempString); 
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.InsertText(const Value: WideString);

var
  I,
  Len: Integer;
  TempString,
  TempString2: WideString;
  Helper: WideString;
  MaxChars: Integer;
  Truncated: Boolean;
  CX: Integer;
  Temp: PWideStringList;
  TempY: Integer;

begin
  if Value <> '' then
  begin
    Temp := NewWideStringList;
    try
      Truncated := False;
      Temp.Text := Value + CR + LF;
      CX := ColumnToCharIndex(PSyntaxEditData(CustomData).FCaretX);

      TempString := LineText;
      Len := CX - Length(TempString);

      if Temp.Count = 1 then
      begin
        if Len > 0 then TempString := TempString + WideStringOfChar(' ', Len);
        System.Insert(Temp.Strings[0], TempString, CX + 1);
        LineText := TempString;
        CaretX := CharIndexToColumn(CX + Length(Temp.Strings[0]));
      end
      else
      begin
        if Len > 0 then
        begin
          Helper := WideStringOfChar(' ', Len);
          TempString := TempString + Helper;
        end;
        TempString := Copy(TempString, 1, CX) + Temp.Strings[0];
        TempString2 := Copy(LineText, CX + 1, Length(LineText));
        MaxChars := PSyntaxEditData(CustomData).FMaxRightPos div PSyntaxEditData(CustomData).FCharWidth;
        if Length(TempString) > MaxChars then
        begin
          Truncated := True;
          TempString := Copy(TempString, 1, MaxChars);
        end;
        PSyntaxEditData(CustomData).FLines.Strings[PSyntaxEditData(CustomData).FCaretY] := TempString;
        TempY := PSyntaxEditData(CustomData).FCaretY + 1;
        for I := 1 to Temp.Count - 2 do
        begin
          if Length(Temp.Strings[I]) > MaxChars then
          begin
            Truncated := True;
            Temp.Strings[I] := Copy(Temp.Strings[I], 1, MaxChars);
          end;
          PSyntaxEditData(CustomData).FLines.Insert(TempY, Temp.Strings[I]);
          Inc(TempY);
        end;
        // relocate bookmarks
        for I:= 0 to 9 do
          if PSyntaxEditData(CustomData).FBookmarks[I].Y >= CaretY then Inc(PSyntaxEditData(CustomData).FBookmarks[I].Y, Temp.Count - 1);

        PSyntaxEditData(CustomData).FLines.Insert(TempY, Temp.Strings[Temp.Count - 1] + TempString2);
        if assigned(PSyntaxEditData(CustomData).FHighlighter) then ScanFrom(PSyntaxEditData(CustomData).FCaretY);
        CaretX := Length(Temp.Strings[Temp.Count - 1]);
        CaretY := TempY;
      end;
      if Truncated then ShowMsg('One or more lines have been truncated.!', MB_OK or MB_ICONWARNING);
    finally
      Temp.Free;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetSelText(const Value: WideString);

begin
  PSyntaxEditData(CustomData).FLines.BeginUpdate;
  InvalidateToBottom(Min(PSyntaxEditData(CustomData).FBlockBegin.Y, PSyntaxEditData(CustomData).FBlockEnd.Y));
  if SelAvail then DeleteSelection(Value = '');
  InsertText(Value);
  BlockBegin := CaretXY;
  PSyntaxEditData(CustomData).FLines.EndUpdate;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetText(const Value: WideString);

begin
  PSyntaxEditData(CustomData).FLines.Text := Value;
  Invalidate;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetTopLine(Value: Integer);

begin
  if Value < 1 then Value := 1;
  if TopLine <> Value then
  begin
    if Value > PSyntaxEditData(CustomData).FLines.Count then Value := PSyntaxEditData(CustomData).FLines.Count;
    SetOffsetY(1 - Value);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ShowCaret;

begin
  if not PSyntaxEditData(CustomData).FCaretVisible then PSyntaxEditData(CustomData).FCaretVisible := Windows.ShowCaret(Handle);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.OnScrollTimer(Sender: PObj);

// do autoscrolling while mouse down and set selection appropriately

var
  SP,
  CP: TPoint;
  NewCaret: TPoint;
  R: TRect;

begin
  Inc(FUpdateCount);
  // get current caret postion
  GetCursorPos(SP);
  GetWindowRect(Handle, R);
  InflateRect(R, -PSyntaxEditData(CustomData).FTextHeight, -PSyntaxEditData(CustomData).FTextHeight);
  CP := Screen2Client(SP);
  if not PtInRect(R, SP) then
  begin
    // scroll only if mouse is outside the specified rectangle (which is a bit smaller
    // than the client area in order to allow to stop scrolling if the mouse is moved
    // over an other edit to drop text to)
    if SP.X < R.Left then SetOffsetX(PSyntaxEditData(CustomData).FOffsetX + (R.Left - SP.X));
    if SP.X > R.Right then SetOffsetX(PSyntaxEditData(CustomData).FOffsetX + (R.Right - SP.X));
    if SP.Y < R.Top then SetOffsetY(PSyntaxEditData(CustomData).FOffsetY + (R.Top - SP.Y));
    if SP.Y > R.Bottom then SetOffsetY(PSyntaxEditData(CustomData).FOffsetY + (R.Bottom - SP.Y));
  end;
  NewCaret := PositionFromPoint(CP.X, CP.Y);
  Dec(FUpdateCount);
  if not PointsAreEqual(CaretXY, NewCaret) then
  begin
    if not PSyntaxEditData(CustomData).FDropTarget then SetBlockEnd(NewCaret);
    CaretXY := NewCaret;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.UpdateCaret;

var
  CX, CY: Integer;

begin
  CX := CaretXPix + PSyntaxEditData(CustomData).FCaretOffset.X;
  CY := CaretYPix + PSyntaxEditData(CustomData).FCaretOffset.Y;
  SetCaretPos(CX - 1, CY);
  if (CX < PSyntaxEditData(CustomData).FGutterRect.Right + 1) or (CX > ClientWidth) or
     (CY < 0) or (CY > ClientHeight - PSyntaxEditData(CustomData).FTextHeight) then HideCaret
                                                                               else ShowCaret;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.UpdateScrollBars;

var
  ScrollInfo: TScrollInfo;
  Page: Integer;

begin
  if (FUpdateCount = 0) and (ClientWidth > 0) then
  begin
    FillChar(ScrollInfo, SizeOf(ScrollInfo), 0);
    ScrollInfo.cbSize := SizeOf(ScrollInfo);
    ScrollInfo.fMask := SIF_ALL;
    ScrollInfo.nMin := 0;
    ScrollInfo.nTrackPos := 0;
    // vertical scrollbar
    if PSyntaxEditData(CustomData).FScrollBars in [ssBoth, ssVertical] then
    begin
      if (PSyntaxEditData(CustomData).FLinesInWindow > 0) and (PSyntaxEditData(CustomData).FLines.Count > PSyntaxEditData(CustomData).FLinesInWindow) then
      begin
        ScrollInfo.nPage := PSyntaxEditData(CustomData).FLinesInWindow + 1;

        ScrollInfo.nMax := PSyntaxEditData(CustomData).FLines.Count;
        // WM_VSCROLL can only handle values up to 65535,
        // consider this and leave some reserve
        if ScrollInfo.nMax > 65000 then
        begin
          PSyntaxEditData(CustomData).FScrollFactor := ScrollInfo.nMax / 65000;
          ScrollInfo.nMax := 65000;
        end
        else PSyntaxEditData(CustomData).FScrollFactor := 1;

        ScrollInfo.nPos := Round(-PSyntaxEditData(CustomData).FOffsetY / PSyntaxEditData(CustomData).FScrollFactor);
      end;
      FlatSB_SetScrollInfo(Handle, SB_VERT, ScrollInfo, True);
    end;

    if PSyntaxEditData(CustomData).FScrollBars in [ssBoth, ssHorizontal] then
    begin
      ScrollInfo.nMax := PSyntaxEditData(CustomData).FMaxRightPos;
      Page := ClientWidth - PSyntaxEditData(CustomData).FGutterRect.Right + 1;
      if Page >= 0 then ScrollInfo.nPage := Page
                   else ScrollInfo.nPage := 0;
      ScrollInfo.nPos := -PSyntaxEditData(CustomData).FOffsetX;
      FlatSB_SetScrollInfo(Handle, SB_HORZ, ScrollInfo, True);
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ScanFrom(Index: Integer);

var
  OldChange: TOnEvent;

begin
  if Index < PSyntaxEditData(CustomData).FLines.Count then
  begin
    OldChange := PSyntaxEditData(CustomData).FLines.OnChange;
    PSyntaxEditData(CustomData).FLines.OnChange := nil;
    try
      if (Index = 0) and (PSyntaxEditData(CustomData).FLines.Count > 0) then
      begin
        PSyntaxEditData(CustomData).FHighLighter.ResetRange;
        PSyntaxEditData(CustomData).FLines.Objects[0] := PSyntaxEditData(CustomData).FHighlighter.GetRange;
      end;
      PSyntaxEditData(CustomData).FLastValidLine := Index;
      InvalidateToBottom(Index);

    finally
      PSyntaxEditData(CustomData).FLines.OnChange := OldChange;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ListAdded(Sender: PObj);

begin
  if Assigned(PSyntaxEditData(CustomData).FHighLighter) then
  begin
    if PSyntaxEditData(CustomData).FLines.Count > 1 then
    begin
      PSyntaxEditData(CustomData).FLines.Objects[PSyntaxEditData(CustomData).FLines.Count - 1] := Pointer(-1);
    end
    else
    begin
      PSyntaxEditData(CustomData).FHighLighter.ReSetRange;
      PSyntaxEditData(CustomData).FLines.Objects[0] := PSyntaxEditData(CustomData).FHighLighter.GetRange;
    end;
  end
  else
    // the highlighter may not be assigned yet
    PSyntaxEditData(CustomData).FLines.Objects[PSyntaxEditData(CustomData).FLines.Count - 1] := Pointer(-1);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ListDeleted(Index: Integer);

begin
  if Assigned(PSyntaxEditData(CustomData).FHighLighter) then
  begin
    if PSyntaxEditData(CustomData).FLines.Count > 1 then ScanFrom(Index)
                       else
      if PSyntaxEditData(CustomData).FLines.Count = 1 then
      begin
        PSyntaxEditData(CustomData).FHighLighter.ResetRange;
        PSyntaxEditData(CustomData).FLines.Objects[0] := PSyntaxEditData(CustomData).FHighLighter.GetRange;
      end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ListInserted(Index: Integer);

begin
  if Assigned(PSyntaxEditData(CustomData).FHighLighter) then
  begin
    if PSyntaxEditData(CustomData).FLines.Count > 1 then ScanFrom(Index)
                       else
      if PSyntaxEditData(CustomData).FLines.Count = 1 then
      begin
        PSyntaxEditData(CustomData).FHighLighter.ResetRange;
        PSyntaxEditData(CustomData).FLines.Objects[0] := PSyntaxEditData(CustomData).FHighLighter.GetRange;
      end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ListLoaded(Sender: PObj);

begin
  CaretXY := MakePoint(0, 0);
  SetOffsetX(0);
  SetOffsetY(0);
  PSyntaxEditData(CustomData).FUndoList.ClearList;
  if Assigned(PSyntaxEditData(CustomData).FHighlighter) then ScanFrom(0);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ListPutted(Index: Integer);

begin
  if Assigned(PSyntaxEditData(CustomData).FHighLighter) then ScanFrom(Index);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetWordBlock(Value: TPoint);

var
  BB, BE: TPoint;

begin
  GetWordAndBounds(Value, BB, BE);
  SetBlockBegin(BB);
  SetBlockEnd(BE);
  CaretXY := BE;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetCanUndo: Boolean;

begin
  Result := PSyntaxEditData(CustomData).FUndoList.CanUndo;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetCanRedo: Boolean;

begin
  Result := PSyntaxEditData(CustomData).FUndoList.CanRedo;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.Redo;

var
  Change: PChange;
  LastReason: TChangeReason;

  //--------------- local functions -------------------------------------------

  procedure RedoAction;

  // redo the action currently recorded in Change

  begin
    with Change^ do
      case Reason of
        ecrInsert:
          begin
            CaretXY := OldCaret;
            BlockBegin := CaretXY;
            SetSelText(NewText);
            CaretXY := NewCaret;
            BlockEnd := NewCaret;
          end;
        ecrDelete:
          begin
            SetBlockBegin(OldSelStart);
            SetBlockEnd(OldSelEnd);
            SetSelText('');
            CaretXY := NewCaret;
          end;
        ecrCursorMove:
          begin
            SetBlockBegin(NewSelStart);
            SetBlockEnd(NewSelEnd);
            CaretXY := NewCaret;
          end;
        ecrReplace:
          begin
            CaretXY := OldCaret;
            SetBlockBegin(OldSelStart);
            SetBlockEnd(OldSelEnd);
            SetSelText(NewText);
            CaretXY := NewCaret;
          end;
        ecrDragCopy,
        ecrDragMove:
          begin
            if Reason = ecrDragMove then
            begin
              SetBlockBegin(OldSelStart);
              SetBlockEnd(OldSelEnd);
              SetSelText('');
            end;
            
            CaretXY := MinPoint(NewSelStart, NewSelEnd);
            SetBlockBegin(NewSelStart);
            SetSelText(NewText);

            CaretXY := NewCaret;
            SetBlockBegin(NewSelStart);
            SetBlockEnd(NewSelEnd);
          end;
        ecrOverwrite:
          begin
            // overwriting text is always replacing it with one char 
            CaretXY := OldCaret;
            SetBlockBegin(OldCaret);
            SetBlockEnd(MakePoint(OldCaret.X + 1, OldCaret.Y));
            SetSelText(NewText);
            SetBlockBegin(NewCaret);
            CaretXY := NewCaret;
          end;
        ecrIndentation:
          begin
            SetBlockBegin(MakePoint(0, Min(OldSelStart.Y, OldSelEnd.Y)));
            SetBlockEnd(MakePoint(0, Max(OldSelStart.Y, OldSelEnd.Y) + 1));
            SetSelText(NewText);
            CaretXY := NewCaret;
            SetBlockBegin(NewSelStart);
            SetBlockEnd(NewSelEnd);
          end;
      end;
  end;

  //--------------- end local functions ---------------------------------------

begin
  if CanRedo then
  begin
    BeginUpdate;
    repeat
      // pop last entry from undo stack and get its values
      LastReason := PSyntaxEditData(CustomData).FUndoList.GetRedoChange(Change);
      RedoAction;
    until not (eoGroupUndo in PSyntaxEditData(CustomData).FOptions) or not CanRedo or (LastReason <> PSyntaxEditData(CustomData).FUndoList.GetCurrentRedoReason);
    EndUpdate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.Undo;

var
  Change: PChange;
  LastReason: TChangeReason;

  //--------------- local functions -------------------------------------------

  procedure UndoAction;

  // undo the action currently recorded in Change

  var I, J: Cardinal;
      T: PWideStringList;

  begin
    with Change^ do
      case Reason of
        ecrInsert:
          begin
            SetBlockBegin(NewSelStart);
            SetBlockEnd(NewSelEnd);
            SetSelText('');
            CaretXY := OldCaret;
          end;
        ecrDelete:
          begin
            CaretXY := OldCaret;
            SetBlockBegin(MinPoint(OldSelStart, OldSelEnd));
            SetSelText(OldText);
            SetBlockBegin(OldSelStart);
            SetBlockEnd(OldSelEnd);
          end;
        ecrCursorMove:
          begin
            CaretXY := OldCaret;
            BlockBegin := OldSelStart;
            BlockEnd := OldSelEnd;
          end;
        ecrReplace:
          begin
            CaretXY := OldCaret;
            SetBlockBegin(NewSelStart);
            SetBlockEnd(NewSelEnd);
            SetSelText(OldText);
            SetBlockBegin(OldSelStart);
            SetBlockEnd(OldSelEnd);
          end;
        ecrDragCopy,
        ecrDragMove:
          begin
            SetBlockBegin(NewSelStart);
            SetBlockEnd(NewSelEnd);
            SetSelText('');

            if Reason = ecrDragMove then
            begin
              CaretXY := MinPoint(OldSelStart, OldSelEnd);
              SetSelText(OldText);
            end;

            CaretXY := OldCaret;
            SetBlockBegin(OldSelStart);
            SetBlockEnd(OldSelEnd);
          end;
        ecrOverwrite:
          begin
            // overwriting text is always replacing one char by another
            CaretXY := OldCaret;
            SetBlockBegin(OldCaret);
            SetBlockEnd(MakePoint(OldCaret.X + 1, OldCaret.Y));
            SetSelText(OldText);
            SetBlockBegin(OldCaret);
          end;
        ecrIndentation:
          begin
            // This is a special kind of replacement, as we set back entire lines.
            // With the consideration of some background information, it becomes
            // reasonably fast (no highlighter rescan necessary as we are modifying spaces
            // only, no partial line modifications).
            T := NewWideStringList;
            try
              T.Text := OldText;
              J := Min(NewSelStart.Y, NewSelEnd.Y);
              // restore old lines
              for I := 0 to T.Count - 1 do
                PSyntaxEditData(CustomData).FLines.Strings[I + J] := T.Strings[I];
            finally
              T.Free;
            end;
            CaretXY := OldCaret;
            SetBlockBegin(OldSelStart);
            SetBlockEnd(OldSelEnd);
          end;
      end;
  end;

  //--------------- end local functions ---------------------------------------

begin
  if CanUndo then
  begin
    BeginUpdate;
    repeat
      // pop last entry from undo stack and get its values
      LastReason := PSyntaxEditData(CustomData).FUndoList.GetUndoChange(Change);
      UndoAction;
    until not (eoGroupUndo in PSyntaxEditData(CustomData).FOptions) or not CanUndo or (LastReason <> PSyntaxEditData(CustomData).FUndoList.GetCurrentUndoReason);
    EndUpdate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ClearBookMark(BookMark: Integer);

var
  Allowed: Boolean;

begin
  if (BookMark in [0..9]) and PSyntaxEditData(CustomData).FBookMarks[BookMark].Visible then
    with PSyntaxEditData(CustomData).FBookMarks[BookMark] do
    begin
      Allowed := True;
      if Assigned(PSyntaxEditData(CustomData).FOnBookmark) then PSyntaxEditData(CustomData).FOnBookmark(@Self, Bookmark, X, Y, Allowed);
      Visible := not Allowed;
      if Allowed then
      begin
        InvalidateLine(Y);
        Y := -1;
      end;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.GotoBookMark(BookMark: Integer);

begin
  if BookMark in [0..9] then
  begin
    CaretXY := MakePoint(PSyntaxEditData(CustomData).FBookMarks[BookMark].X, PSyntaxEditData(CustomData).FBookMarks[BookMark].Y);
    EnsureCursorPosVisible;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetBookMark(BookMark: Integer; X: Integer; Y: Integer);

var
  Allowed: Boolean;

begin
  if (BookMark in [0..9]) and (Y <= PSyntaxEditData(CustomData).FLines.Count) then
  begin
    Allowed := True;
    if Assigned(PSyntaxEditData(CustomData).FOnBookmark) then PSyntaxEditData(CustomData).FOnBookmark(@Self, Bookmark, X, Y, Allowed);
    if Allowed then
    begin
      PSyntaxEditData(CustomData).FBookMarks[BookMark].X := X;
      PSyntaxEditData(CustomData).FBookMarks[BookMark].Y := Y;
      PSyntaxEditData(CustomData).FBookMarks[BookMark].Visible := True;
      InvalidateLine(Y); 
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.IsIdentChar(const AChar: WideChar; IdChars: TSynIdentChars): Boolean;

// Compatibility routine to check whether a given character is in the provided (SBCS) characters list.
// Works only if AChar is in the ANSI code page (value is < $100).
// Consider this function as being temporary until highlighters are ready which can deal with Unicode.

begin
  Result := Char(AChar) in IdChars;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetWordAndBounds(Pos: TPoint; var BB, BE: TPoint): WideString;

// Returns the word and its boundaries at position Pos. All positions are given
// as column/row values.
// Note: Compare Pos with BB and BE to determine whether the word is really at the
//       given position or has been automatically choosen because there was no word
//       at this position.

var
  CX: Integer;
  Line: WideString;
  IdChars: TSynIdentChars;
  Len: Integer;

begin
  // make sure the given position is valid
  if Pos.Y < 0 then Pos.Y := 0;
  if Pos.Y >= PSyntaxEditData(CustomData).FLines.Count then Pos.Y := PSyntaxEditData(CustomData).FLines.Count - 1;
  if Pos.X < 0 then Pos.X := 0;

  // determine WideString to be searched through
  if Pos.Y > - 1 then Line := PSyntaxEditData(CustomData).FLines.Strings[Pos.Y]
                 else Line := '';
  Len := Length(Line);
  BB.Y := Pos.Y;
  BE.Y := Pos.Y;

  if Len > 0 then
  begin
    // setup initial states
    CX := ColumnToCharIndex(Pos);
    if CX > Len - 1 then CX := Len - 1;
    if PSyntaxEditData(CustomData).FHighLighter <> nil then IdChars := PSyntaxEditData(CustomData).FHighLighter.IdentChars
                           else IDchars := [#33..#255];

    // four cases are to be considered:
    // 1. IdChar at current position
    if IsIdentChar(Line[CX + 1], IdChars) then
    begin
      // find start of word
      BB.X := CX;
      while (BB.X > 0) and IsIdentChar(Line[BB.X], IdChars) do Dec(BB.X);
      // find end of word
      BE.X := CX + 1;
      while (BE.X < Len) and IsIdentChar(Line[BE.X + 1], IdChars) do Inc(BE.X);
      // copy word
      Result := Copy(Line, BB.X + 1, BE.X - BB.X);
    end
    else
    begin
      // 2. no ID char at current position, so search to the left
      BE.X := CX;
      while (BE.X > 0) and not IsIdentChar(Line[BE.X], IdChars) do Dec(BE.X);
      if BE.X > 0 then
      begin
        CX := BE.X;
        // find start of word
        while (CX > 0) and IsIdentChar(Line[CX], IdChars) do Dec(CX);
        BB.X := CX;
        Result := Copy(Line, BB.X + 1, BE.X - BB.X);
      end
      else
      begin
        // 3. no ID char found to the left, so search to the right
        BB.X := CX + 1;
        while (BB.X < Len) and not IsIdentChar(Line[BB.X + 1], IdChars) do Inc(BB.X);
        if BB.X < Len then
        begin
          // find end of word
          BE.X := BB.X + 1;
          while (BE.X < Len) and IsIdentChar(Line[BE.X + 1], IdChars) do Inc(BE.X);
          Result := Copy(Line, BB.X + 1, BE.X - BB.X);
        end
        else
        begin
          // 4. nothing found, return all we have
          BB.X := 0;
          BE.X := Len;
          Result := Line;
        end;
      end;
    end;
	
    // finally turn char indices into columns
    BB.X := CharIndexToColumn(BB);
    BE.X := CharIndexToColumn(BE);
  end
  else
  begin
    Result := '';
    BB.X := 0;
    BE.X := 0;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.WordAtPos(X, Y: Integer): WideString;

// returns the word at the given position, X and Y must be given in client coordinates,

var
  BB, BE: TPoint;

begin
  Result := GetWordAndBounds(PositionFromPoint(X, Y), BB, BE);
end;

//----------------------------------------------------------------------------------------------------------------------

{procedure TKOLVMHSyntaxEdit.DragCanceled;

begin
  FScrollTimer.Enabled := False;
  CaretXY := FLastCaret; // restore previous caret position
  if not FDragWasStarted then SetBlockBegin(FLastCaret);
  inherited;
end;}

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.CopyOnDrop(Source: PObj): Boolean;

// determines wether a drag'n drop operation is a move or a copy

var
  Shft: TShiftState;

begin
  // determine move or copy operation
  Shft := KeyDataToShiftState(0);
  // w/o modifier keys the operation is determined source and target edit being the same or not
  if Shft = [] then Result := Source <> @Self
               else Result := (ssCtrl in Shft) or (Source <> @Self) and not (ssShift in Shft);
end;

//----------------------------------------------------------------------------------------------------------------------

{procedure TKOLVMHSyntaxEdit.DragOver(Source: PObj; X, Y: Integer; State: TDragState; var Accept: Boolean);

// drag operations are also allowed between different edits

begin
  FDragWasStarted := True;
  inherited;
  if Accept and (Source is TKOLVMHSyntaxEdit) then
  begin
    case State of
      dsDragLeave:
        begin
          FDropTarget := False;
          FScrollTimer.Enabled := False;
          // give the timer time to process its pending message
          Application.ProcessMessages;
        end;
      dsDragEnter:
        begin
          // remember that we are drag target currently as the originator of the
          // drag operation might be another syntax edit instance
          FDropTarget := True;
          SetFocus;
          FScrollTimer.Enabled := True;
        end;
    end;

    // If source and target are identical then we cannot drop on selected text.
    // If this edit is not the source then we accept the operation and will
    // replace the selected text by the incoming one.
    if Source = Self then Accept := not PosInSelection(PositionFromPoint(X, Y))
                     else Accept := True;

    if Accept then
    begin
      // if Ctrl is pressed or Source is not this control then change
      // cursor to indicate copy instead of move
      if CopyOnDrop(Source) then TKOLVMHSyntaxEdit(Source).DragCursor := crDragCopy
                            else TKOLVMHSyntaxEdit(Source).DragCursor := crDragMove;
    end;
  end;
end; }

//----------------------------------------------------------------------------------------------------------------------

{procedure TKOLVMHSyntaxEdit.DragDrop(Source: PObj; X, Y: Integer);

var
  DoMove,
  DoReplace: Boolean;
  NewCaret: TPoint;
  OldBB,
  OldBE: TPoint;
  OldText,
  NewText: WideString;
  ThisEditState,
  OtherEditState: TEditState;

begin
  if not (eoReadOnly in FOptions) then
  begin
    inherited;

    // determine move or copy operation
    DoMove := not CopyOnDrop(Source);
    ThisEditState := RecordState(True);

    if Source = Self then
    begin
      NewText := GetSelText;
      NewCaret := CaretXY;

      OldText := GetSelText;
      OldBB := MinPoint(FBlockBegin, FBlockEnd);
      OldBE := MaxPoint(FBlockBegin, FBlockEnd);

      if DoMove then
      begin
        if PosInSelection(NewCaret) then NewCaret := OldBB
                                    else
        begin
          // continue calculation with char indices
          NewCaret.X := ColumnToCharIndex(NewCaret);
          if (NewCaret.Y >= OldBB.Y) and (NewCaret.X >= OldBB.X) then
          begin
            // correct cursor position if the target pos is located after the selection start
            Dec(NewCaret.Y, OldBE.Y - OldBB.Y);
            if NewCaret.Y = OldBB.Y then Inc(NewCaret.X, OldBB.X);
            if NewCaret.Y = OldBE.Y then Dec(NewCaret.X, OldBE.X);
          end;
          // finally go back to columns
          NewCaret.X := CharIndexToColumn(NewCaret);
        end;
        // delete old text
        SetSelText('');
      end;

      // insert the text at new position...
      CaretXY := NewCaret;
      SetBlockBegin(NewCaret);
      SetSelText(NewText);

      // ...and mark it again as selected
      CaretXY := NewCaret;
      SetBlockBegin(NewCaret);
      SetBlockEnd(Point(NewCaret.X + OldBE.X - OldBB.X, NewCaret.Y + OldBE.Y - OldBB.Y));

      // finally register undo change
      if DoMove then FUndoList.AddChange(ecrDragMove, OldText, @FLastCaret, @OldBB, @OldBE)
                else FUndoList.AddChange(ecrDragCopy, NewText, @NewCaret, @OldBB, @OldBE);
      DoChange;
    end
    else
      if Source is TKOLVMHSyntaxEdit then
      begin
        // drag'n drop operation between different edits
        NewText := TKOLVMHSyntaxEdit(Source).GetSelText;
        NewCaret := CaretXY;
        DoReplace := PosInSelection(PositionFromPoint(X, Y));

        OldText := GetSelText;
        OldBB := MinPoint(FBlockBegin, FBlockEnd);
        OldBE := MaxPoint(FBlockBegin, FBlockEnd);

        // replace selected text here with selected text from other edit if the drag cursor
        // points to selected text, otherwise insert the new text
        if DoReplace then CaretXY := OldBB
                     else BlockBegin := CaretXY; // make sure nothing is selected anymore
        SetSelText(NewText);
        // if the user wants to move text then additionally delete the selected text in the other edit
        with Source as TKOLVMHSyntaxEdit do
        begin
          if DoMove then
          begin
            // retrieve text, selection bounds and cursor position from other edit for undo registration
            OtherEditState := RecordState(True);
            CaretXY := MinPoint(FBlockBegin, FBlockEnd);
            SetSelText('');
            // register undo action in other edit
            with OtherEditState do
              FUndoList.AddChange(ecrDelete, Text, @FLastCaret, @SelStart, @SelEnd);

            DoChange;
          end;
        end;

        // mark the new text as selected
        if DoReplace then BlockBegin := OldBB
                     else BlockBegin := NewCaret;
        BlockEnd := CaretXY;
        // If there's a move operation then there was also a caret update in the code above which
        // set the caret for the source edit. We need now to tell Windows to set back the caret (which
        // is a shared ressource) to the correct coordinates in this edit.
        if DoMove then UpdateCaret;

        // finally register undo change in this edit
        with ThisEditState do
          FUndoList.AddChange(ecrInsert, '', @Caret, @SelStart, @SelEnd,
                                         NewText, @FBlockBegin, @FBlockBegin, @FBlockEnd);
        DoChange;
      end;
  end;
end;}

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetGutterColor(Value: TColor);

begin
  if PSyntaxEditData(CustomData).FGutterColor <> Value then
  begin
    PSyntaxEditData(CustomData).FGutterColor := Value;
    Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetRightMargin(Value: Integer);

begin
  if (PSyntaxEditData(CustomData).FRightMargin <> Value) then
  begin
    PSyntaxEditData(CustomData).FRightMargin := Value;
    Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetMaxUndo: Integer;

begin
  Result := PSyntaxEditData(CustomData).FUndoList.MaxUndo;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetMaxUndo(const Value: Integer);

begin
  if Value > -1 then
  begin
    PSyntaxEditData(CustomData).FUndoList.MaxUndo := Value;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetHighlighter(const Value: PVMHCustomHighlighter);

begin
  if Value <> PSyntaxEditData(CustomData).FHighLighter then
  begin
    //if Assigned(PSyntaxEditData(CustomData).FHighLighter) then PSyntaxEditData(CustomData).FHighLighter.WindowList.Delete(PSyntaxEditData(CustomData).FHighLighter.WindowList.IndexOf(@Self));
    PSyntaxEditData(CustomData).FHighLighter := Value;
    if Assigned(PSyntaxEditData(CustomData).FHighLighter) then
    begin
      //Value.WindowList.Add(@Self);
      //Value.FreeNotification(@Self);
      ScanFrom(0);
    end
    else Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.InitializeCaret;

var
  ct: TCaretType;
  cw, ch: Integer;

begin
  if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) or
     (eoShowCursorWhileReadOnly in PSyntaxEditData(CustomData).FOptions) then
  begin
    // CreateCaret automatically destroys the previous one, so we don't have to
    // worry about cleaning up the old one here with DestroyCaret.
    // Ideally, we will have properties that control what these two carets look like.
    HideCaret;
    if eoInserting in PSyntaxEditData(CustomData).FOptions then ct := PSyntaxEditData(CustomData).FInsertCaret
                                                           else ct := PSyntaxEditData(CustomData).FOverwriteCaret;
    case ct of
      ctHorizontalLine:
        begin
          cw := PSyntaxEditData(CustomData).FCharWidth;
          ch := 2;
          PSyntaxEditData(CustomData).FCaretOffset := MakePoint(0, PSyntaxEditData(CustomData).FTextHeight-2);
        end;
      ctHalfBlock:
        begin
          cw := PSyntaxEditData(CustomData).FCharWidth;
          ch := (PSyntaxEditData(CustomData).FTextHeight - 2) div 2;
          PSyntaxEditData(CustomData).FCaretOffset := MakePoint(0, ch);
        end;
      ctBlock:
        begin
          cw := PSyntaxEditData(CustomData).FCharWidth;
          ch := PSyntaxEditData(CustomData).FTextHeight - 2;
          PSyntaxEditData(CustomData).FCaretOffset := MakePoint(0, 0);
        end;
    else // ctVerticalLine
      cw := 2;
      ch := PSyntaxEditData(CustomData).FTextHeight - 2;
      PSyntaxEditData(CustomData).FCaretOffset := MakePoint(0, 0);
    end;
    CreateCaret(Handle, 0, cw, ch);
    UpdateCaret;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetInsertCaret(const Value: TCaretType);

begin
  if PSyntaxEditData(CustomData).FInsertCaret <> Value then
  begin
    PSyntaxEditData(CustomData).FInsertCaret := Value;
    InitializeCaret;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetOverwriteCaret(const Value: TCaretType);

begin
  if PSyntaxEditData(CustomData).FOverwriteCaret <> Value then
  begin
    PSyntaxEditData(CustomData).FOverwriteCaret := Value;
    InitializeCaret;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetCaretXY: TPoint;

begin
  Result := MakePoint(PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetCaretXY(const Value: TPoint);

begin
  // set Y first because ScrollPastEOL can effect the X pos, prevent SetCaretX/Y
  // from sending OnChange events
  Inc(FUpdateCount);
  CaretY := Value.Y;
  CaretX := Value.X;
  Dec(FUpdateCount);
  if FUpdateCount = 0 then
  begin
    UpdateCaret;
    UpdateScrollBars;
    UpdateWindow(Handle);
    DoCaretChange;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.DoCaretChange;

begin
  {// try setting the correct keyboard layout
  if not (csLButtonDown in ControlState) and
     (FCaretY < FLines.Count) and
     (FCaretX > 0) and
     (FCaretX < Length(FLines[FCaretY])) then
    ActivateKeyboard(FLines[FCaretY][FCaretX]);}
  if Assigned(PSyntaxEditData(CustomData).FOnCaretChange) then PSyntaxEditData(CustomData).FOnCaretChange(@Self, PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetMaxRightChar: Integer;

begin
  Result:= PSyntaxEditData(CustomData).FMaxRightPos div PSyntaxEditData(CustomData).FCharWidth;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetMarginColor(const Value: TColor);

begin
  if PSyntaxEditData(CustomData).FMarginColor <> Value then
  begin
    PSyntaxEditData(CustomData).FMarginColor := Value;
    Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetMaxRightChar(const Value: Integer);

var
  I: Integer;

begin
  if PSyntaxEditData(CustomData).FMaxRightPos <> (Value  * PSyntaxEditData(CustomData).FCharWidth) then
  begin
    PSyntaxEditData(CustomData).FMaxRightPos := Value * PSyntaxEditData(CustomData).FCharWidth;
    SetLength(PSyntaxEditData(CustomData).FCharWidthArray, Value);
    for I := 0 to Value - 1 do PSyntaxEditData(CustomData).FCharWidthArray[I] := PSyntaxEditData(CustomData).FCharWidth;
    if HandleAllocated then
    begin
      Invalidate;
      UpdateScrollBars;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetCharWidth(const Value: Integer);

var
  I,
  RightChar: Integer;

begin
  if PSyntaxEditData(CustomData).FCharWidth <> Value then
  begin
    if Value = 0 then Exit;
    RightChar := PSyntaxEditData(CustomData).FMaxRightPos div PSyntaxEditData(CustomData).FCharWidth;
    PSyntaxEditData(CustomData).FCharWidth := Value;
    MaxRightChar := RightChar;
    for I := 0 to (PSyntaxEditData(CustomData).FMaxRightPos div PSyntaxEditData(CustomData).FCharWidth) - 1 do PSyntaxEditData(CustomData).FCharWidthArray[I] := PSyntaxEditData(CustomData).FCharWidth;
    Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.EnsureCursorPosVisible;

begin
  // make sure X is visible
  if PSyntaxEditData(CustomData).FCaretX < (-PSyntaxEditData(CustomData).FOffsetX div PSyntaxEditData(CustomData).FCharWidth) then SetOffsetX(-PSyntaxEditData(CustomData).FCaretX * PSyntaxEditData(CustomData).FCharWidth)
                                          else
    if PSyntaxEditData(CustomData).FCaretX >= (PSyntaxEditData(CustomData).FCharsInWindow - PSyntaxEditData(CustomData).FOffsetX div PSyntaxEditData(CustomData).FCharWidth) then SetOffsetX(-(PSyntaxEditData(CustomData).FCaretX - PSyntaxEditData(CustomData).FCharsInWindow) * PSyntaxEditData(CustomData).FCharWidth);

  // make sure Y is visible
  if PSyntaxEditData(CustomData).FCaretY < (TopLine - 1) then TopLine := PSyntaxEditData(CustomData).FCaretY + 1
                             else
    if PSyntaxEditData(CustomData).FCaretY > (TopLine + (LinesInWindow - 2)) then TopLine := PSyntaxEditData(CustomData).FCaretY - (LinesInWindow - 2);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetKeystrokes(const Value: PKeyStrokes);

begin
  if Value = nil then PSyntaxEditData(CustomData).FKeyStrokes.Clear
                 else PSyntaxEditData(CustomData).FKeyStrokes := Value;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetDefaultKeystrokes;

begin
  PSyntaxEditData(CustomData).FKeyStrokes.ResetDefaults;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.TranslateKeyCode(Code: word; ShiftState: TShiftState; var Data: Pointer): TEditorCommand;

// If the translations requires Data, memory will be allocated for it via a
// GetMem call. The client must call FreeMem on Data if it is not nil.

var
  I: Integer;

begin
  I := Keystrokes.FindKeycode(Code, ShiftState);
  if I >= 0 then Result := Keystrokes.Items[I].Command
            else Result := ecNone;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.CommandProcessor(Command: TEditorCommand; AChar: WideChar; Data: Pointer);

var
  CX: Integer;
  Len: Integer;
  Temp: WideString;
  Helper: WideString;
  OldOptions: TSyntaxEditOptions;
  Action: Boolean;
  WP: TPoint;
  Caret: TPoint;
  I, J: Integer;
  OldChar: WideChar;
  BB, BE: TPoint;
  LastState: TEditState;

  //--------------- local functions -------------------------------------------

  procedure RegisterCursorMoveChange;

  // helper function to ease the repetitive registration of the cursor move undo change

  var
    Caret: TPoint;

  begin
    if not PointsAreEqual(CaretXY, LastState.Caret) then
    begin
      Caret := CaretXY;
      PSyntaxEditData(CustomData).FUndoList.AddChange(ecrCursorMove, '', @LastState.Caret, @LastState.SelStart, @LastState.SelEnd,
                                         '', @Caret, @PSyntaxEditData(CustomData).FBlockBegin, @PSyntaxEditData(CustomData).FBlockEnd);
    end;
  end;

  //---------------------------------------------------------------------------

  procedure RegisterDeleteChange;

  // helper function to ease the repetitive registration of a delete undo change

  begin
    with LastState do
      PSyntaxEditData(CustomData).FUndoList.AddChange(ecrDelete, Text, @Caret, @SelStart, @SelEnd);
  end;

  //---------------------------------------------------------------------------

  procedure RegisterReplaceChange(NewText: WideString; StartBound, EndBound: TPoint);

  // helper function to ease the repetitive registration of a replace undo change
  // StartBound and EndBound are just to ease making undo and do not correspond
  // to a selection

  var
    Caret: TPoint;

  begin
    Caret := CaretXY;
    PSyntaxEditData(CustomData).FUndoList.AddChange(ecrReplace, LastState.Text, @LastState.Caret, @LastState.SelStart, @LastState.SelEnd,
                                    NewText, @Caret, @StartBound, @EndBound);
  end;

  //---------------------------------------------------------------------------

  procedure RegisterInsertChange(NewText: WideString; StartBound, EndBound: TPoint);

  // helper function to ease the repetitive registration of an insert undo change,
  // StartBound and EndBound are just to ease making undo and do not correspond
  // to a selection

  var
    Caret: TPoint;

  begin
    Caret := CaretXY;
    PSyntaxEditData(CustomData).FUndoList.AddChange(ecrInsert, '', @LastState.Caret, @LastState.SelStart, @LastState.SelEnd,
                                   NewText, @Caret, @StartBound, @EndBound);
  end;

  //---------------------------------------------------------------------------

  procedure RegisterOverwriteChange(NewChar: WideChar);

  var
    Caret: TPoint;

  begin
    Caret := CaretXY;
    PSyntaxEditData(CustomData).FUndoList.AddChange(ecrOverwrite, OldChar, @LastState.Caret, nil, nil,
                                      NewChar, @Caret, nil, nil);
  end;

  //--------------- end local functions ---------------------------------------

begin
  ProcessCommand(Command, AChar, Data);
  if (Command = ecNone) or (Command >= ecUserFirst) then Exit;

  case Command of
    ecLeft,
    ecSelLeft:
      begin
        LastState := RecordState(False);
        CX := PreviousCharPos(PSyntaxEditData(CustomData).FCaretX);

        if not (eoScrollPastEOL in PSyntaxEditData(CustomData).FOptions) and (PSyntaxEditData(CustomData).FCaretX = 0) then
        begin
          if PSyntaxEditData(CustomData).FCaretY > 0 then
          begin
            CaretY := PSyntaxEditData(CustomData).FCaretY - 1;
            CaretX := GetLineEnd;
          end;
        end
        else CaretX := CX;

        if Command = ecSelLeft then
        begin
          if not SelAvail then SetBlockBegin(LastState.Caret);
          SetBlockEnd(CaretXY);
        end
        else SetBlockBegin(CaretXY);

        RegisterCursorMoveChange;
      end;

    ecRight,
    ecSelRight:
      begin
        LastState := RecordState(False);
        CX := NextCharPos(PSyntaxEditData(CustomData).FCaretX);

        if not (eoScrollPastEOL in PSyntaxEditData(CustomData).FOptions) and (Cardinal(CX) > GetLineEnd) then
        begin
          if PSyntaxEditData(CustomData).FCaretY < PSyntaxEditData(CustomData).FLines.Count then
          begin
            CaretX := 0;
            CaretY := PSyntaxEditData(CustomData).FCaretY + 1;
          end;
        end
        else CaretX := CX;

        if Command = ecSelRight then
        begin
          if not SelAvail then SetBlockBegin(LastState.Caret);
          SetBlockEnd(CaretXY);
        end
        else SetBlockBegin(CaretXY);

        RegisterCursorMoveChange;
      end;

    ecUp,
    ecSelUp:
      begin
        LastState := RecordState(False);
        CaretY := PSyntaxEditData(CustomData).FCaretY - 1;
        if (Command = ecSelUp) then
        begin
          if not SelAvail then SetBlockBegin(MakePoint(PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY + 1));
          SetBlockEnd(CaretXY);
        end
        else SetBlockBegin(CaretXY);

        RegisterCursorMoveChange;
      end;

    ecDown,
    ecSelDown:
      begin
        LastState := RecordState(False);
        CaretY := PSyntaxEditData(CustomData).FCaretY + 1;
        if Command = ecSelDown then
        begin
          if not SelAvail then SetBlockBegin(MakePoint(PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY - 1));
          SetBlockEnd(CaretXY);
        end
        else SetBlockBegin(CaretXY);

        RegisterCursorMoveChange;
      end;

    ecWordLeft,
    ecSelWordLeft:
      begin
        LastState := RecordState(False);
        if (Command = ecSelWordLeft) and (not SelAvail) then SetBlockBegin(CaretXY);
        CaretXY := LastWordPos;
        if Command = ecSelWordLeft then SetBlockEnd(CaretXY)
                                   else SetBlockBegin(CaretXY);
        RegisterCursorMoveChange;
      end;

    ecWordRight,
    ecSelWordRight:
      begin
        LastState := RecordState(False);
        if (Command = ecSelWordRight) and (not SelAvail) then SetBlockBegin(CaretXY);
        CaretXY := NextWordPos;
        if Command = ecSelWordRight then SetBlockEnd(CaretXY)
                                    else SetBlockBegin(CaretXY);
        RegisterCursorMoveChange;
      end;

    ecLineStart,
    ecSelLineStart:
      begin
        LastState := RecordState(False);
        if (Command = ecSelLineStart) and (not SelAvail) then SetBlockBegin(CaretXY);
        CaretX := 0;
        if Command = ecSelLineStart then SetBlockEnd(CaretXY)
                                    else SetBlockBegin(CaretXY);
        RegisterCursorMoveChange;
      end;

    ecLineEnd,
    ecSelLineEnd:
     begin
        LastState := RecordState(False);
        if (Command = ecSelLineEnd) and (not SelAvail) then SetBlockBegin(CaretXY);
        if eoKeepTrailingBlanks in PSyntaxEditData(CustomData).FOptions then Helper := LineText
                                            else Helper := WideTrimRight(LineText);
        if Helper <> LineText then LineText := Helper;
        CaretX := GetLineEnd(PSyntaxEditData(CustomData).FCaretY);
        if Command = ecSelLineEnd then SetBlockEnd(CaretXY)
                                  else SetBlockBegin(CaretXY);
        RegisterCursorMoveChange;
      end;

    ecPageUp,
    ecSelPageUp:
      begin
        LastState := RecordState(False);
        if (Command = ecSelPageUp) and (not SelAvail) then SetBlockBegin(CaretXY);
        Caret := MakePoint(PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY - PSyntaxEditData(CustomData).FLinesInWindow);
        if Command = ecSelPageUp then SetBlockEnd(Caret)
                                 else SetBlockBegin(Caret);
        TopLine := TopLine - LinesInWindow;
        CaretXY := Caret;
        RegisterCursorMoveChange;
      end;

    ecPageDown,
    ecSelPageDown:
      begin
        LastState := RecordState(False);
        if (Command = ecSelPageDown) and (not SelAvail) then SetBlockBegin(CaretXY);
        Caret := MakePoint(PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY + PSyntaxEditData(CustomData).FLinesInWindow);
        if (Command = ecSelPageDown) then SetBlockEnd(Caret)
                                     else SetBlockBegin(Caret);
        TopLine := TopLine + LinesInWindow;
        CaretXY := Caret;
        RegisterCursorMoveChange;
      end;

    ecPageLeft,
    ecSelPageLeft:
      begin
        LastState := RecordState(False);
        if (Command = ecSelPageLeft) and (not SelAvail) then SetBlockBegin(CaretXY);
        SetOffsetX(PSyntaxEditData(CustomData).FOffsetX + CharsInWindow * PSyntaxEditData(CustomData).FCharWidth);
        CaretX := PSyntaxEditData(CustomData).FCaretX - CharsInWindow;
        if (Command = ecSelPageLeft) then SetBlockEnd(CaretXY)
                                     else SetBlockBegin(CaretXY);
        RegisterCursorMoveChange;
      end;

    ecPageRight,
    ecSelPageRight:
      begin
        LastState := RecordState(False);
        if (Command = ecSelPageRight) and (not SelAvail) then SetBlockBegin(CaretXY);
        SetOffsetX(PSyntaxEditData(CustomData).FOffsetX - CharsInWindow * PSyntaxEditData(CustomData).FCharWidth);
        CaretX := PSyntaxEditData(CustomData).FCaretX + CharsInWindow;
        if (Command = ecSelPageRight) then SetBlockEnd(CaretXY)
                                      else SetBlockBegin(CaretXY);
        RegisterCursorMoveChange;
      end;

    ecPageTop,
    ecSelPageTop:
      begin
        LastState := RecordState(False);
        if (Command = ecSelPageTop) and (not SelAvail) then SetBlockBegin(CaretXY);
        CaretY := TopLine - 1;
        if Command = ecSelPageTop then SetBlockEnd(CaretXY)
                                  else SetBlockBegin(CaretXY);
        RegisterCursorMoveChange;
      end;

    ecPageBottom,
    ecSelPageBottom:
      begin
        LastState := RecordState(False);
        if (Command = ecSelPageBottom) and (not SelAvail) then SetBlockBegin(CaretXY);
        CaretY := TopLine + LinesInWindow - 2;
        if (Command = ecSelPageBottom) then SetBlockEnd(CaretXY)
                                       else SetBlockBegin(CaretXY);
        RegisterCursorMoveChange;
      end;

    ecEditorTop,
    ecSelEditorTop:
      begin
        LastState := RecordState(False);
        if (Command = ecSelEditorTop) and (not SelAvail) then SetBlockBegin(CaretXY);
        CaretX := 0;
        CaretY := 0;
        if Command = ecSelEditorTop then SetBlockEnd(CaretXY)
                                    else SetBlockBegin(CaretXY);
        RegisterCursorMoveChange;
      end;

    ecEditorBottom,
    ecSelEditorBottom:
      begin
        LastState := RecordState(False);
        if (Command = ecSelEditorBottom) and (not SelAvail) then SetBlockBegin(CaretXY);
        CaretY := PSyntaxEditData(CustomData).FLines.Count - 1;
        SetOffsetY(PSyntaxEditData(CustomData).FLinesInWindow - PSyntaxEditData(CustomData).FLines.Count);
        CaretX := Length(PSyntaxEditData(CustomData).FLines.Strings[PSyntaxEditData(CustomData).FLines.Count - 1]);
        SetOffsetX(0);
        if Command = ecSelEditorBottom then SetBlockEnd(CaretXY)
                                       else SetBlockBegin(CaretXY);
        RegisterCursorMoveChange;
      end;

    ecGotoXY,
    ecSelGotoXY:
      if Data <> nil then
      begin
        LastState := RecordState(False);
        if (Command = ecSelGotoXY) and (not SelAvail) then SetBlockBegin(CaretXY);
        CaretXY := PPoint(Data)^;
        if Command = ecSelGotoXY then SetBlockEnd(CaretXY)
                                 else SetBlockBegin(CaretXY);
        RegisterCursorMoveChange;
      end;

    ecSelectAll:
      SelectAll;

    ecDeleteLastChar:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        LastState := RecordState(True);
        if SelAvail then
        begin
          SetSelText('');
          RegisterDeleteChange;
        end
        else
        begin
          Temp := LineText;
          Len := Length(Temp);
          // get char index from column
          CX := ColumnToCharIndex(PSyntaxEditData(CustomData).FCaretX);
          if CX <= Len then
          begin
            if CX > 0 then
            begin
              // current index is somewhere on the line, first check whether we
              // can do auto unindentation
              I := CX - 1;
              while (I > -1) and UnicodeIsWhiteSpace(Word(Temp[I + 1])) do Dec(I);
              if (eoAutoUnindent in PSyntaxEditData(CustomData).FOptions) and (I = -1) then
              begin
                // fine, all conditions met to do auto unindentation
                I := Unindent(PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY);
                J := ColumnToCharIndex(I);
                Helper := Copy(Temp, J + 1, CX - J);
                System.Delete(Temp, J + 1, CX - J);
                LineText := Temp;
                CaretX := I;
                LastState.Text := Helper;
                RegisterDeleteChange;
              end
              else
              begin
                // no unindentation, just delete last character;
                // need to test for non-default width character though
                if CharIndexToColumn(CX) = Cardinal(PSyntaxEditData(CustomData).FCaretX) then
                begin
                  Helper := Temp[CX];
                  System.Delete(Temp, CX, 1);
                  CaretX := PreviousCharPos(PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY);
                end
                else
                begin
                  Helper := Temp[CX + 1];
                  System.Delete(Temp, CX + 1, 1);
                  CaretX := CharIndexToColumn(CX);
                end;
                LineText := Temp;
                LastState.Text := Helper;
                RegisterDeleteChange;
              end;
            end
            else
            begin
              // character index is at line start, but the first char might be a non-default
              // width char and the current column is somewhere inbetween -> check this
              if PSyntaxEditData(CustomData).FCaretX > 0 then
              begin
                // yes, the first char is of non-default width, so delete this char
                // instead of moving the line one step up
                LastState.Text := Copy(Temp, 1, 1);
                System.Delete(Temp, 1, 1);
                LineText := Temp;
                CaretX := 0;
                RegisterDeleteChange;
              end
              else
                // no, first char is just an ordinary one, so move this line one step up
                if PSyntaxEditData(CustomData).FCaretY > 0 then
                begin
                  PSyntaxEditData(CustomData).FLines.Delete(PSyntaxEditData(CustomData).FCaretY);
                  // need to relocate bookmarks
                  for I := 0 to 9 do
                    if PSyntaxEditData(CustomData).FBookmarks[I].Y >= PSyntaxEditData(CustomData).FCaretY then Dec(PSyntaxEditData(CustomData).FBookmarks[I].Y);
                  CaretY := CaretY - 1;
                  CaretX := GetLineEnd(PSyntaxEditData(CustomData).FCaretY);
                  LineText := LineText + Temp;
                  LastState.Text := CRLF;
                  RegisterDeleteChange;
                  InvalidateToBottom(PSyntaxEditData(CustomData).FCaretY);
                end;
            end;
            DoChange;
          end
          else
          begin
            // caret is beyond the end of the current line -> just do a cursor move
            CaretX := CharIndexToColumn(CX - 1);
            RegisterCursorMoveChange;
          end;
        end;
      end;

    ecDeleteChar:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        LastState := RecordState(True);
        if SelAvail then
        begin
          SetSelText('');
          SetBlockBegin(CaretXY);
          RegisterDeleteChange;
        end
        else
        begin
          Temp := LineText;
          Len := Length(Temp);
          CX := ColumnToCharIndex(PSyntaxEditData(CustomData).FCaretX);
          if Len > CX then
          begin
            LastState.Text := Temp[CX + 1];
            System.Delete(Temp, CX + 1, 1);
            LineText := Temp;
            // need a caret change here if it was place on a non-default width char
            CaretX := CharIndexToColumn(CX);
            RegisterDeleteChange;
          end
          else
          begin
            if PSyntaxEditData(CustomData).FCaretY < PSyntaxEditData(CustomData).FLines.Count - 1 then
            begin
              Helper := WideStringOfChar(' ', CX - Len);
              LineText := Temp + Helper + PSyntaxEditData(CustomData).FLines.Strings[PSyntaxEditData(CustomData).FCaretY + 1];
              PSyntaxEditData(CustomData).FLines.Delete(PSyntaxEditData(CustomData).FCaretY + 1);
              // need to relocate bookmarks
              for I := 0 to 9 do
                if PSyntaxEditData(CustomData).FBookmarks[I].Y >= PSyntaxEditData(CustomData).FCaretY then Dec(PSyntaxEditData(CustomData).FBookmarks[I].Y);
              InvalidateToBottom(PSyntaxEditData(CustomData).FCaretY);
              LastState.Text := CRLF;
              RegisterDeleteChange;
            end;
          end;
        end;
        DoChange;
      end;

    ecDeleteWord:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        LastState := RecordState(True);
        WP := NextWordPos;
        if (PSyntaxEditData(CustomData).FCaretX <> WP.X) or (PSyntaxEditData(CustomData).FCaretY <> WP.Y) then
        begin
          SetBlockBegin(CaretXY);
          SetBlockEnd(WP);
          LastState.Text := SelText;
          SetSelText('');
          CaretXY := CaretXY; // fix up cursor position
          RegisterDeleteChange;
          DoChange;
        end;
      end;

    ecDeleteLastWord:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        LastState := RecordState(True);
        WP := LastWordPos;
        if (PSyntaxEditData(CustomData).FCaretX <> WP.X) or (CaretY <> WP.Y) then
        begin
          SetBlockBegin(WP);
          SetBlockEnd(CaretXY);
          LastState.Text := SelText;
          SetSelText('');
          CaretXY := CaretXY; // fix up cursor position
          RegisterDeleteChange;
          DoChange;
        end;
      end;

    ecDeleteBOL:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        LastState := RecordState(True);
        LastState.Text := Copy(LineText, 1, ColumnToCharIndex(PSyntaxEditData(CustomData).FCaretX));
        SetBlockBegin(MakePoint(0, CaretY));
        SetBlockEnd(CaretXY);
        SetSelText('');
        CaretXY := MakePoint(0, CaretY); // fix up cursor position
        RegisterDeleteChange;
        DoChange;
      end;

    ecDeleteEOL:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        LastState := RecordState(True);
        CX := ColumnToCharIndex(PSyntaxEditData(CustomData).FCaretX);
        LastState.Text := Copy(LineText, CX + 1, Length(LineText) - CX);
        SetBlockBegin(CaretXY);
        SetBlockEnd(MakePoint(GetLineEnd, CaretY));
        SetSelText('');
        CaretXY := CaretXY; // fix up cursor position
        RegisterDeleteChange;
        DoChange;
      end;

    ecDeleteLine:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        LastState := RecordState(True);
        CaretX := 0;
        if SelAvail then SetBlockBegin(CaretXY);
        LastState.Text := PWideChar(LineText + CRLF);
        PSyntaxEditData(CustomData).FLines.Delete(PSyntaxEditData(CustomData).FCaretY);
        RegisterDeleteChange;
        DoChange;
      end;

    ecClearAll:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        ClearAll(True, True);
        DoChange;
      end;

    ecInsertLine,
    ecLineBreak:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        LastState := RecordState(True);
        if SelAvail then
        begin
          BB := MinPoint(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
          Caret := BB;
          Temp := '';
          if not (eoKeepTrailingBlanks in PSyntaxEditData(CustomData).FOptions) then
          begin
            // include trailing blanks (which would otherwise appear and automatically
            // deleted after the line break has been inserted) into the text being
            // replaced, to be able to restore them while doing undo
            CX := ColumnToCharIndex(BB);
            // keep char index, we need it later
            I := CX;
            Helper := PSyntaxEditData(CustomData).FLines.Strings[BB.Y];
            // extent the helper WideString to match the caret position
            if CX > Length(Helper) then Helper := Helper + WideStringOfChar(' ', CX - Length(Helper));
            Dec(CX);
            while (CX > -1) and UnicodeIsWhiteSpace(Word(Helper[CX + 1])) do Dec(CX);
            Inc(CX);
            BB.X := CharIndexToColumn(MakePoint(CX, BB.Y));
            // copy white spaces potentially to be restored
            if CX < I then Temp := Copy(Helper, CX + 1, I - CX);
          end;
          SetSelText(CRLF);
          SetBlockBegin(CaretXY);
          // save additional text to be restored
          LastState.Text := Temp + LastState.Text;
          BE := CaretXY;
          // restore caret postion if we deal with a line insertion
          if Command = ecInsertLine then CaretXY := Caret;
          RegisterReplaceChange(CRLF, BB, BE);
        end
        else
        begin
          PSyntaxEditData(CustomData).FLines.OnChange := nil;
          Temp := LineText;
          CX := ColumnToCharIndex(PSyntaxEditData(CustomData).FCaretX);
          LineText := Copy(Temp, 1, CX);
          BB := MakePoint(PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY);
          System.Delete(Temp, 1, CX);
          InvalidateToBottom(PSyntaxEditData(CustomData).FCaretY);
          if eoAutoIndent in PSyntaxEditData(CustomData).FOptions then Caret := MakePoint(NextSmartTab(0, PSyntaxEditData(CustomData).FCaretY + 1, False), PSyntaxEditData(CustomData).FCaretY + 1)
                                      else Caret := MakePoint(0, PSyntaxEditData(CustomData).FCaretY + 1);
          // the just calculated column corresponds directly to the characters we
          // have to insert, hence no conversion to a char index is needed
          Helper := WideStringOfChar(' ', Caret.X);
          System.Insert(Helper, Temp, 1);
          PSyntaxEditData(CustomData).FLines.Insert(Caret.Y, Temp);
          if Command = ecLineBreak then CaretXY := Caret;

          RegisterInsertChange(CRLF + Helper, BB, Caret);
          PSyntaxEditData(CustomData).FLines.OnChange := LinesChanged;

          // need to relocate bookmarks
          for I := 0 to 9 do
            if PSyntaxEditData(CustomData).FBookmarks[I].Y >= PSyntaxEditData(CustomData).FCaretY then Inc(PSyntaxEditData(CustomData).FBookmarks[I].Y);
        end;
        DoChange;
      end;

    ecChar:
      // #127 is Ctrl + Backspace
      if ((AChar = Tabulator) or (AChar >= Space)) and (AChar <> #127) and not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        LastState := RecordState(True);
        if SelAvail then
        begin
          // Special case TAB -> it does not delete the selection, but enhances
          // it to the next smart tab pos and moves following characters accordingly
          // if the editor is using smart tabs currently
          // (that's the way the Delphi IDE does it, so I'll do it too).
          if (AChar = Tabulator) and (eoSmartTabs in PSyntaxEditData(CustomData).FOptions)  then
          begin
            CX := NextSmartTab(PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY, True);
            I := ColumnToCharIndex(MakePoint(PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY));
            Temp := LineText;
            System.Insert(WideStringOfChar(' ', CX - PSyntaxEditData(CustomData).FCaretX), Temp, I + 1);
            LineText := Temp;
            // adjust selection
            BB := MinPoint(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBLockEnd);
            BE := MaxPoint(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBLockEnd);
            if (PSyntaxEditData(CustomData).FCaretY = BB.Y) and (PSyntaxEditData(CustomData).FCaretX <= BB.X) then
            begin
              SetBlockBegin(MakePoint(BB.X + CX - PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY));
              if PSyntaxEditData(CustomData).FCaretY = BE.Y then SetBlockEnd(MakePoint(BE.X + CX - PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY))
                                else SetBlockEnd(BE);
            end
            else
              if (PSyntaxEditData(CustomData).FCaretY = BE.Y) and (PSyntaxEditData(CustomData).FCaretX >= BE.X) then SetBlockEnd(MakePoint(CX, PSyntaxEditData(CustomData).FCaretY));
            CaretX := CX;
            RegisterReplaceChange(SelText, PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
            DoChange;
          end
          else
          begin
            BB := MinPoint(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
            if (AChar = Tabulator) and not (eoUseTabs in PSyntaxEditData(CustomData).FOptions) then Temp := WideStringOfChar(' ', PSyntaxEditData(CustomData).FTabSize)
                                                                 else Temp := AChar;
            SetSelText(Temp);
            CaretX := NextCharPos(BB.X, BB.Y);
            SetBlockBegin(CaretXY);
            RegisterReplaceChange(Temp, BB, CaretXY);
            DoChange;
          end;
        end
        else
        begin
          Temp := LineText;
          Len := Length(Temp);
          CX := ColumnToCharIndex(PSyntaxEditData(CustomData).FCaretX);
          {if CX+1 >= MaxRightChar then
          begin
            MaxRightChar := MaxRightChar + 30;
            Perform(WM_HSCROLL, SB_BOTTOM, 0);
          end;}
          if Len < CX then Temp := Temp + WideStringOfChar(' ', CX - Len);
          OldOptions := PSyntaxEditData(CustomData).FOptions;
          System.Include(PSyntaxEditData(CustomData).FOptions, eoScrollPastEOL);
          try
            if eoInserting in PSyntaxEditData(CustomData).FOptions then
            begin
              if (AChar = Tabulator) and not (eoUseTabs in PSyntaxEditData(CustomData).FOptions) then
              begin
                if eoSmartTabs in PSyntaxEditData(CustomData).FOptions then
                  I := NextSmartTab(PSyntaxEditData(CustomData).FCaretX, PSyntaxEditData(CustomData).FCaretY, True)
                else
                  I := PSyntaxEditData(CustomData).FCaretX + PSyntaxEditData(CustomData).FTabSize;
                // if I is still at FCaretX then do nothing (can happen with smart
                // tabs under certain conditions)
                if I > PSyntaxEditData(CustomData).FCaretX then
                begin
                  // insert as much spaces as the size of the column difference
                  Helper := WideStringOfChar(' ', I - PSyntaxEditData(CustomData).FCaretX);
                  System.Insert(Helper, Temp, CX + 1);
                  Action :=True;
                end
                else Action := False;
              end
              else
              begin
                // insert the new character (plus some spaces if the current column is
                // within a non-default width character and the new character is not a tab)
                if AChar = Tabulator then
                begin
                  Helper := AChar;
                  System.Insert(Helper, Temp, CX + 1);
                  // need to set the line text at this point, although it is redundant (as it will
                  // be set in the action branch below), because the new caret position
                  // needs also to be calculated and this computation is based on the
                  // text
                  LineText := Temp;
                  I := NextCharPos(PSyntaxEditData(CustomData).FCaretX, True);
                end
                else
                begin
                  Helper := WideStringOfChar(' ', PSyntaxEditData(CustomData).FCaretX - CharIndexToColumn(CX)) + AChar;
                  System.Insert(Helper, Temp, CX + 1);
                  I := PSyntaxEditData(CustomData).FCaretX + 1;
                end;
                Action := True;
              end;

              if Action then
              begin
                LineText := Temp;
                CaretX := I;
                RegisterInsertChange(Helper, LastState.Caret, CaretXY);
                if PSyntaxEditData(CustomData).FCaretX >= -PSyntaxEditData(CustomData).FOffsetX * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FCharsInWindow then SetOffsetX((PSyntaxEditData(CustomData).FOffsetX - Min(25, PSyntaxEditData(CustomData).FCharsInWindow - 1)) * PSyntaxEditData(CustomData).FCharWidth);
                DoChange;
              end;
            end
            else
            begin
              // in overwrite mode does a tab char only advance the cursor
              if AChar = Tabulator then
              begin
                CaretX := NextTabPos(PSyntaxEditData(CustomData).FCaretX);
                RegisterCursorMoveChange;
              end
              else
              begin
                if CX < Len then
                begin
                  OldChar := Temp[CX + 1];
                  Temp[CX + 1] := AChar;
                  CaretX := NextCharPos(PSyntaxEditData(CustomData).FCaretX);
                  LineText := Temp;
                  RegisterOverwriteChange(AChar);
                  if CaretX >= -PSyntaxEditData(CustomData).FOffsetX * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FCharsInWindow then SetOffsetX((PSyntaxEditData(CustomData).FOffsetX + Min(25, PSyntaxEditData(CustomData).FCharsInWindow - 1)) * PSyntaxEditData(CustomData).FCharWidth);
                  DoChange;
                end
                else
                begin
                  Helper := WideStringOfChar(' ', PSyntaxEditData(CustomData).FCaretX - CharIndexToColumn(CX)) + AChar;
                  System.Insert(Helper, Temp, CX + 1);
                  I := PSyntaxEditData(CustomData).FCaretX + 1;
                  LineText := Temp;
                  CaretX := I;
                  RegisterInsertChange(Helper, LastState.Caret, CaretXY);
                  if PSyntaxEditData(CustomData).FCaretX >= -PSyntaxEditData(CustomData).FOffsetX * PSyntaxEditData(CustomData).FCharWidth + PSyntaxEditData(CustomData).FCharsInWindow then SetOffsetX((PSyntaxEditData(CustomData).FOffsetX - Min(25, PSyntaxEditData(CustomData).FCharsInWindow - 1)) * PSyntaxEditData(CustomData).FCharWidth);
                  DoChange;
                end;
              end;
            end;
          finally
            PSyntaxEditData(CustomData).FOptions := OldOptions;
          end;
        end;
      end;

    ecUndo:
      Undo;

    ecRedo:
      Redo;

    ecGotoMarker0..ecGotoMarker9:
        if BookMarkOptions.EnableKeys then GotoBookMark(Command - ecGotoMarker0);

    ecToggleMarker0..ecToggleMarker9:
      begin
        if BookMarkOptions.EnableKeys then
        begin
          CX := Command - ecToggleMarker0;
          Action := PSyntaxEditData(CustomData).FBookMarks[CX].Y <> CaretY;
          ClearBookMark(CX);
          if Action then SetBookMark(CX, PSyntaxEditData(CustomData).FCaretX, CaretY);
        end;
      end;

    ecCut:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) and SelAvail then
      begin
        CutToClipboard;
        DoChange;
      end;

    ecCopy:
      CopyToClipboard;

    ecPaste:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        PasteFromClipboard;
        DoChange;
      end;

    ecScrollUp:
      begin
        TopLine := TopLine - 1;
        if CaretY > TopLine + PSyntaxEditData(CustomData).FLinesInWindow - 2 then CaretY := TopLine + LinesInWindow - 2;
        RegisterCursorMoveChange;
      end;

    ecScrollDown:
      begin
        TopLine := TopLine + 1;
        if CaretY < TopLine - 1 then CaretY := TopLine - 1;
        RegisterCursorMoveChange;
      end;

    ecScrollLeft:
      begin
        Dec(PSyntaxEditData(CustomData).FOffsetX, PSyntaxEditData(CustomData).FCharWidth);
        if PSyntaxEditData(CustomData).FCaretX > -PSyntaxEditData(CustomData).FOffsetX * PSyntaxEditData(CustomData).FCharWidth + CharsInWindow then CaretX := -PSyntaxEditData(CustomData).FOffsetX * PSyntaxEditData(CustomData).FCharWidth + CharsInWindow;
        RegisterCursorMoveChange;
      end;

    ecScrollRight:
      begin
        Inc(PSyntaxEditData(CustomData).FOffsetX, PSyntaxEditData(CustomData).FCharWidth);
        if PSyntaxEditData(CustomData).FCaretX < -PSyntaxEditData(CustomData).FOffsetX * PSyntaxEditData(CustomData).FCharWidth then CaretX := -PSyntaxEditData(CustomData).FOffsetX * PSyntaxEditData(CustomData).FCharWidth;
        RegisterCursorMoveChange;
      end;

    ecInsertMode:
      begin
        Include(PSyntaxEditData(CustomData).FOptions, eoInserting);
        InitializeCaret;
        DoSettingChanged;
      end;

    ecOverwriteMode:
      begin
        Exclude(PSyntaxEditData(CustomData).FOptions, eoInserting);
        InitializeCaret;
        DoSettingChanged;
      end;

    ecToggleMode:
      begin
        if eoInserting in PSyntaxEditData(CustomData).FOptions then Exclude(PSyntaxEditData(CustomData).FOptions, eoInserting)
                                   else Include(PSyntaxEditData(CustomData).FOptions, eoInserting);
        InitializeCaret;
        DoSettingChanged;
      end;

    ecBlockIndent:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        BlockIndent;
        DoChange;
      end;

    ecBlockUnindent:
      if not (eoReadOnly in PSyntaxEditData(CustomData).FOptions) then
      begin
        BlockUnindent;
        DoChange;
      end;
  end;

  // Add macro recorder stuff here?
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.DoSettingChanged;

begin
  if Assigned(PSyntaxEditData(CustomData).FOnSettingChange) then PSyntaxEditData(CustomData).FOnSettingChange(@Self);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ProcessCommand(var Command: TEditorCommand; var AChar: WideChar; Data: Pointer);

begin
  if Command < ecUserFirst then
  begin
    if assigned(PSyntaxEditData(CustomData).FOnProcessCommand) then PSyntaxEditData(CustomData).FOnProcessCommand(Command, AChar, Data);
  end
  else
  begin
    if assigned(PSyntaxEditData(CustomData).FOnProcessUserCommand) then PSyntaxEditData(CustomData).FOnProcessUserCommand(Command, AChar, Data);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ClearAll(RegisterUndo, KeepUndoList: Boolean);

// Deletes the entire text and (in case KeepUndoList is not True) clears also the
// undo list. If KeepUndoList is True then RegisterUndo has no effect otherwise
// a new undo record is added to make the clear operation reversable.

var
  State: TEditState;

begin
  if PSyntaxEditData(CustomData).FLines.Count > 0 then
  begin
    BeginUpdate;
    RegisterUndo := RegisterUndo and KeepUndoList;
    try
      if RegisterUndo then
      begin
        SelectAll;
        State := RecordState(True);
      end;
      PSyntaxEditData(CustomData).FLines.Clear;
      PSyntaxEditData(CustomData).FBlockBegin := MakePoint(0, 0);
      PSyntaxEditData(CustomData).FBlockEnd := MakePoint(0, 0);
      CaretXY := MakePoint(0, 0);
      if RegisterUndo then
        with State do
          PSyntaxEditData(CustomData).FUndoList.AddChange(ecrDelete, Text, @Caret, @SelStart, @SelEnd);
    finally
      EndUpdate;
    end;
  end;
  if not KeepUndoList then PSyntaxEditData(CustomData).FUndoList.ClearList;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.LineFromPos(Pos: TPoint): Integer;

// returns the index of the line at position Pos (which must be given in client coordinates)

begin
  Result:= -PSyntaxEditData(CustomData).FOffsetY + (Pos.Y div PSyntaxEditData(CustomData).FTextHeight) + 1;
  if Result < 0 then Result := 0;
  if Result > PSyntaxEditData(CustomData).FLines.Count - 1 then Result := PSyntaxEditData(CustomData).FLines.Count -1;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.NextWordPos: TPoint;

// Calculates the caret position of the next word start or the line end if there's
// no further word on the current line and the caret is not already on the line's end.

var
  CX, CY: Integer;
  X: Integer;
  FoundWhiteSpace: Boolean;
  Len: Integer;
  Temp: WideString;
  IdChars: TSynIdentChars;

begin
  Result := CaretXY;
  // ensure at least an empty line is there
  Temp := LineText;
  CX := ColumnToCharIndex(PSyntaxEditData(CustomData).FCaretX) + 1;
  if CX < Length(PSyntaxEditData(CustomData).FLines.Strings[PSyntaxEditData(CustomData).FCaretY]) then CY := PSyntaxEditData(CustomData).FCaretY
                                  else
  begin
    CY := PSyntaxEditData(CustomData).FCaretY + 1;
    if CY > PSyntaxEditData(CustomData).FLines.Count - 1 then Exit;
    if WideTrim(PSyntaxEditData(CustomData).FLines.Strings[CY]) = '' then
    begin
      Result := MakePoint(0, CY);
      Exit;
    end;
    CX := 1;
  end;

  if PSyntaxEditData(CustomData).FHighLighter <> nil then IdChars := PSyntaxEditData(CustomData).FHighLighter.IdentChars
                         else IDchars := [#33..#255];

  Temp := PSyntaxEditData(CustomData).FLines.Strings[CY];
  Len := Length(Temp);
  FoundWhiteSpace := (not IsIdentChar(Temp[CX], IdChars)) or (CY <> PSyntaxEditData(CustomData).FCaretY);
  if not FoundWhiteSpace then
    for X := CX to Len do
      if not IsIdentChar(Temp[X], IdChars) then
      begin
        CX := X;
        FoundWhiteSpace := True;
        Break;
      end;

  if FoundWhiteSpace then
  begin
    FoundWhiteSpace := False;
    for X := CX to Len do
      if IsIdentChar(Temp[X], IdChars) then
      begin
        Result := MakePoint(X - 1, CY);
        FoundWhiteSpace := True;
        Break;
      end;
  end;

  if not FoundWhiteSpace then Result := MakePoint(Len, CY);
  Result.X := CharIndexToColumn(Result);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.LastWordPos: TPoint;

var
  CX, CY: Integer;
  X: Integer;
  FoundNonWhiteSpace: Boolean;
  Len: Integer;
  Temp: WideString;
  IdChars: TSynIdentChars;

begin
  Result := CaretXY;
  Len := Length(LineText);
  CX := ColumnToCharIndex(PSyntaxEditData(CustomData).FCaretX);
  if CX > Len then CX := Len;
  if CX > 0 then CY := PSyntaxEditData(CustomData).FCaretY
            else
  begin
    if PSyntaxEditData(CustomData).FCaretY < 1 then
    begin
      Result := MakePoint(0, 0);
      Exit;
    end
    else
    begin
      Result := MakePoint(GetLineEnd(PSyntaxEditData(CustomData).FCaretY - 1), PSyntaxEditData(CustomData).FCaretY - 1);
      Exit;
    end;
  end;

  if PSyntaxEditData(CustomData).FHighLighter <> nil then IdChars := PSyntaxEditData(CustomData).FHighLighter.IdentChars
                         else IDchars := [#33..#255];

  Temp := PSyntaxEditData(CustomData).FLines.Strings[CY];
  FoundNonWhiteSpace := IsIdentChar(Temp[CX], IdChars);
  if not FoundNonWhiteSpace then
    for X := CX downto 2 do
      if IsIdentChar(Temp[X - 1], IdChars) then
      begin
        CX := X - 1;
        FoundNonWhiteSpace := True;
        Break;
      end;

  if FoundNonWhiteSpace then
  begin
    FoundNonWhiteSpace := False;
    for X := CX downto 2 do
      if not IsIdentChar(Temp[X - 1], IdChars) then
      begin
        Result := MakePoint(X - 1, CY);
        FoundNonWhiteSpace := True;
        Break;
      end;

    if not FoundNonWhiteSpace then Result := MakePoint(0, CY);
  end
  else
  begin
    Dec(CY);
    if CY = -1 then Result := MakePoint(0, 0)
               else Result := MakePoint(length(PSyntaxEditData(CustomData).FLines.Strings[CY]), CY);
  end;
  Result.X := CharIndexToColumn(Result);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetUpdateState(Updating: Boolean);

begin
  SendMessage(Handle, WM_SETREDRAW, Ord(not Updating), 0);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.BeginUpdate;

begin
  if FUpdateCount = 0 then SetUpdateState(True);
  Inc(FUpdateCount);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.EndUpdate;

begin
  if FUpdateCount > 0 then Dec(FUpdateCount);
  if FUpdateCount = 0 then
  begin
    SetUpdateState(False);
    UpdateScrollBars;
    UpdateCaret;
    DoCaretChange;
    Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.InvalidateLine(Index: Integer);

var
  R : TRect;

begin
  R := MakeRect(0, (Index + PSyntaxEditData(CustomData).FOffsetY) * PSyntaxEditData(CustomData).FTextHeight, ClientWidth, (Index + PSyntaxEditData(CustomData).FOffsetY + 1) * PSyntaxEditData(CustomData).FTextHeight);
  InvalidateRect(Handle, @R, False);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.InvalidateLines(Start, Stop: Integer);

var
  R : TRect;

begin
  if Start <= Stop then
  begin
    Start := Start + PSyntaxEditData(CustomData).FOffsetY;
    if Start < 0 then Start := 0;
    Stop := Stop + PSyntaxEditData(CustomData).FOffsetY + 1;
    if Stop > PSyntaxEditData(CustomData).FLinesInWindow then Stop := PSyntaxEditData(CustomData).FLinesInWindow;
    // consider partially visible line
    if (ClientHeight mod PSyntaxEditData(CustomData).FLinesInWindow) <> 0 then Inc(Stop);
    R := MakeRect(0, Start * PSyntaxEditData(CustomData).FTextHeight, ClientWidth, Stop * PSyntaxEditData(CustomData).FTextHeight);
  end
  else
  begin
    Stop := Stop + PSyntaxEditData(CustomData).FOffsetY;
    if Stop < 0 then Stop := 0;
    Start := Start + PSyntaxEditData(CustomData).FOffsetY + 1;
    if Start > PSyntaxEditData(CustomData).FLinesInWindow then Start := PSyntaxEditData(CustomData).FLinesInWindow;
    // consider partially visible line
    if (ClientHeight mod PSyntaxEditData(CustomData).FLinesInWindow) <> 0 then Inc(Start);
    R := MakeRect(0, Stop* PSyntaxEditData(CustomData).FTextHeight, ClientWidth, Start * PSyntaxEditData(CustomData).FTextHeight);
  end;
  InvalidateRect(Handle, @R, False);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.InvalidateToBottom(Index: Integer);

var
  R : TRect;

begin
  R := MakeRect(0, (Index + PSyntaxEditData(CustomData).FOffsetY) * PSyntaxEditData(CustomData).FTextHeight, ClientWidth, ClientHeight);
  InvalidateRect(Handle, @R, False);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.MarkListChange(Sender: PObj);

begin
  Invalidate;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetSelStart: Integer;

var
  Loop: Integer;
  X, Y: Integer;

begin
  X := PSyntaxEditData(CustomData).FCaretx;
  Y := PSyntaxEditData(CustomData).FCaretY;

  Result:=0;
  Loop:=0;
  while Loop < (Y-1) do
  begin
    Result:=Result+Length(PSyntaxEditData(CustomData).FLines.Strings[Loop])+2;
    Inc(Loop);
  end;

  Result:=Result+Min(X, Length(PSyntaxEditData(CustomData).FLines.Strings[Loop])+2);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetSelStart(const Value: Integer);

var
  Loop: Integer;
  Cnt: Integer;

begin
  Loop:=0;
  Cnt:=0;
  while (Cnt+Length(PSyntaxEditData(CustomData).FLines.Strings[Loop])+2) < Value do
  begin
    Cnt:=Cnt+Length(PSyntaxEditData(CustomData).FLines.Strings[Loop])+2;
    Inc(loop);
  end;
  CaretX:=Value - Cnt;
  CaretY:=Loop + 1;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetSelEnd: Integer;

var
  Loop: Integer;
  X, Y: Integer;

begin
  X:=BlockEnd.X;
  Y:=BlockEnd.Y;

  Result:=0;
  Loop:=0;
  while Loop < (Y-1) do
  begin
    Result:=Result+Length(PSyntaxEditData(CustomData).FLines.Strings[Loop])+2;
    Inc(Loop);
  end;
  Result:=Result+X;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetSelEnd(const Value: Integer);

var
  P: TPoint;
  Loop: Integer;
  Cnt: Integer;

begin
  Loop:=0;
  Cnt:=0;
  while (Cnt+Length(PSyntaxEditData(CustomData).FLines.Strings[Loop])+2) < value do
  begin
    Cnt:=Cnt+Length(PSyntaxEditData(CustomData).FLines.Strings[Loop])+2;
    Inc(loop);
  end;
  P.X:=Value-Cnt;
  P.Y:=Loop+1;
  Blockend:=P;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetExtraLineSpacing(const Value: Integer);

begin
  PSyntaxEditData(CustomData).FExtraLineSpacing := Value;
  FontChanged(@Self);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.RowColumnToCharPosition(P: TPoint): Cardinal;

// Calculates the total position of the column/row reference point as would all lines be
// one continous WideString.

var
  I: Integer;
  
begin
  Result := 0;
  P.X := ColumnToCharIndex(P);
  for I := 0 to Min(P.Y, PSyntaxEditData(CustomData).FLines.Count) - 1 do Inc(Result, Length(PSyntaxEditData(CustomData).FLines.Strings[I]) + 2); // add 2 for CRLF
  if P.Y < PSyntaxEditData(CustomData).FLines.Count then Inc(Result, P.X);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.CharPositionToRowColumn(Pos: Cardinal): TPoint;

// Calculates the total position of the column/row reference point as would all lines be
// one continous WideString.

var
  I: Integer;
  Len: Cardinal;

begin
  Result.Y := 0;
  for I := 0 to PSyntaxEditData(CustomData).FLines.Count - 1 do
  begin
    Len := Length(PSyntaxEditData(CustomData).FLines.Strings[I]) + 2; // sub 2 for CRLF
    if Pos < Len then Break;
    Inc(Result.Y);
    Dec(Pos, Len);
  end;
  Result.X := Pos;
  Result.X := ColumnToCharIndex(Result);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.SearchReplace(const SearchText, ReplaceText: WideString; Opts: TSearchOptions): Integer;

var
  StartPoint,
  EndPoint: TPoint; // search range
  Current: TPoint;  // current search position
  DoBackward,
  DoFromCursor: Boolean;
  DoPrompt: Boolean;
  DoReplace,
  DoReplaceAll,
  Changed: Boolean;
  Action: TReplaceAction;

  //--------------- local functions -------------------------------------------

  function InValidSearchRange(First, Last: Integer): Boolean;

  begin
    Result := not (((Current.Y = StartPoint.Y) and (First < StartPoint.X)) or
                  ((Current.Y = EndPoint.Y) and (Last > EndPoint.X)));
  end;

  //---------------------------------------------------------------------------

  procedure DoPlainSearchReplace;

  var
    SearchLen,
    ReplaceLen,
    N: Integer;
    Start,
    Stop,
    ColStart,
    ColStop: Integer;
    Found,
    DoStop: Boolean;
    Searcher: PUTBMSearch;
    SearchOptions: TSearchFlags;
    Offset: Integer;

  begin
    Searcher := NewUTBMSearch(PSyntaxEditData(CustomData).FLines);
    try
      // initialize the search engine
      SearchOptions := [];
      if soMatchCase in Opts then Include(SearchOptions, sfCaseSensitive);
      if soIgnoreNonSpacing in Opts then Include(SearchOptions, sfIgnoreNonSpacing);
      if soSpaceCompress in Opts then Include(SearchOptions, sfSpaceCompress);
      if soWholeWord in Opts then Include(SearchOptions, sfWholeWordOnly);
      //soWholeWord in Options;
      Searcher.FindPrepare(SearchText, SearchOptions);
      // search while the current search position is inside of the search range
      SearchLen := Length(SearchText);
      ReplaceLen := Length(ReplaceText);
      DoStop := False;

      while not DoStop and (Current.Y >= StartPoint.Y) and (Current.Y <= EndPoint.Y) do
      begin
        // need a running offset because further search results are determined with regard
        // to the unchanged string but when replacing the string changes all the time
        Offset := 0;
        Found := Searcher.FindAll(PSyntaxEditData(CustomData).FLines.Strings[Current.Y]);
        if DoBackward then N := Pred(Searcher.Count)
                      else N := 0;
        // Operate on all results in this line.
        while not DoStop and Found do
        begin
          if (N < 0) or (N = Searcher.Count) then Break;
          Searcher.GetResult(N, Start, Stop);
          Inc(Start, Offset);
          Inc(Stop, Offset);
          // convert character positions to column values,
          // need to invalidate the char width array in every run because there might be non-single characters
          // like tabulators in text or replace string
          PSyntaxEditData(CustomData).FLastCalcIndex := -1;
          ColStart := CharIndexToColumn(MakePoint(Start, Current.Y));
          ColStop := CharIndexToColumn(MakePoint(Stop, Current.Y));
          if DoBackward then Dec(N)
                        else Inc(N);
          // Is the search result entirely in the search range?
          if not InValidSearchRange(Start, Stop) then Continue;
          Inc(Result);
          // Select the text, so the user can see it in the OnReplaceText event
          // handler or as the search result.
          Current.X := ColStart;
          BlockBegin := Current;
          if DoBackward then CaretXY := Current;
          Current.X := ColStop;
          BlockEnd := Current;
          if not DoBackward then CaretXY := Current;
          // if it's a search only we can leave the procedure now
          if not (DoReplace or DoReplaceAll) then Abort;

          // Prompt and replace or replace all.  If user chooses to replace
          // all after prompting, turn off prompting.
          if DoPrompt then
          begin
            Action := raCancel;
            Applet.ProcessMessagesEx;
            PSyntaxEditData(CustomData).FOnReplaceText(@Self, SearchText, ReplaceText, Current.Y, ColStart, ColStop, Action);
            if Action = raCancel then
            begin
              DoStop := True;
              Break;
            end;
          end
          else Action := raReplace;
          if Action <> raSkip then
          begin
            // user has been prompted and has requested to silently replace all
            // so turn off prompting
            if Action = raReplaceAll then
            begin
              if not DoReplaceAll then
              begin
                DoReplaceAll := True;
                BeginUpdate;
              end;
              DoPrompt := False;
            end;
            SetSelTextExternal(ReplaceText);
            Changed := True;
          end;
          // calculate position offset (this offset is character index not column based)
          if not DoBackward then Inc(Offset, ReplaceLen - SearchLen);
          if not DoReplaceAll then DoStop := True;
        end;
        // search next / previous line
        if DoBackward then Dec(Current.Y)
                      else Inc(Current.Y);
      end;
    finally
      Searcher.Free;
    end;
  end;

  //---------------------------------------------------------------------------

  procedure DoRESearchReplace;

  var
    SearchLen,
    ReplaceLen,
    N: Integer;
    Start,
    Stop,
    ColStart,
    ColStop: Integer;
    Found,
    DoStop: Boolean;
    Searcher: PURESearch;
    SearchOptions: TSearchFlags;
    Offset: Integer;

  begin
    Searcher := NewURESearch(PSyntaxEditData(CustomData).FLines);
    try
      // initialize the search engine
      SearchOptions := [];
      if soMatchCase in Opts then Include(SearchOptions, sfCaseSensitive);
      if soIgnoreNonSpacing in Opts then Include(SearchOptions, sfIgnoreNonSpacing);
      if soSpaceCompress in Opts then Include(SearchOptions, sfSpaceCompress);
      if soWholeWord in Opts then Include(SearchOptions, sfWholeWordOnly);
      //soWholeWord in Options;
      Searcher.FindPrepare(SearchText, SearchOptions);
      // search while the current search position is inside of the search range
      SearchLen := Length(SearchText);
      ReplaceLen := Length(ReplaceText);
      DoStop := False;

      while not DoStop and (Current.Y >= StartPoint.Y) and (Current.Y <= EndPoint.Y) do
      begin
        // need a running offset because further search results are determined with regard
        // to the unchanged string but when replacing the string changes all the time
        Offset := 0;
        Found := Searcher.FindAll(PSyntaxEditData(CustomData).FLines.Strings[Current.Y]);
        if DoBackward then N := Pred(Searcher.Count)
                      else N := 0;
        // Operate on all results in this line.
        while not DoStop and Found do
        begin
          if (N < 0) or (N = Searcher.Count) then Break;
          Searcher.GetResult(N, Start, Stop);
          Inc(Start, Offset);
          Inc(Stop, Offset);
          // convert character positions to column values,
          // need to invalidate the char width array in every run because there might be non-single characters
          // like tabulators in text or replace string
          PSyntaxEditData(CustomData).FLastCalcIndex := -1;
          ColStart := CharIndexToColumn(MakePoint(Start, Current.Y));
          ColStop := CharIndexToColumn(MakePoint(Stop, Current.Y));
          if DoBackward then Dec(N)
                        else Inc(N);
          // Is the search result entirely in the search range?
          if not InValidSearchRange(Start, Stop) then Continue;
          Inc(Result);
          // Select the text, so the user can see it in the OnReplaceText event
          // handler or as the search result.
          Current.X := ColStart;
          BlockBegin := Current;
          if DoBackward then CaretXY := Current;
          Current.X := ColStop;
          BlockEnd := Current;
          if not DoBackward then CaretXY := Current;
          // if it's a search only we can leave the procedure now
          if not (DoReplace or DoReplaceAll) then Abort;

          // Prompt and replace or replace all.  If user chooses to replace
          // all after prompting, turn off prompting.
          if DoPrompt then
          begin
            Action := raCancel;
            Applet.ProcessMessagesEx;
            PSyntaxEditData(CustomData).FOnReplaceText(@Self, SearchText, ReplaceText, Current.Y, ColStart, ColStop, Action);
            if Action = raCancel then
            begin
              DoStop := True;
              Break;
            end;
          end
          else Action := raReplace;
          if Action <> raSkip then
          begin
            // user has been prompted and has requested to silently replace all
            // so turn off prompting
            if Action = raReplaceAll then
            begin
              if not DoReplaceAll then
              begin
                DoReplaceAll := True;
                BeginUpdate;
              end;
              DoPrompt := False;
            end;
            SetSelTextExternal(ReplaceText);
            Changed := True;
          end;
          // calculate position offset (this offset is character index not column based)
          if not DoBackward then Inc(Offset, ReplaceLen - SearchLen);
          if not DoReplaceAll then DoStop := True;
        end;
        // search next / previous line
        if DoBackward then Dec(Current.Y)
                      else Inc(Current.Y);
      end;
    finally
      Searcher.Free;
    end;
  end;

  //--------------- end local functions ---------------------------------------

begin
  Result := 0;
  // can't search for or replace an empty WideString
  if (Length(SearchText) > 0) and (PSyntaxEditData(CustomData).FLines.Count > 0) then
  begin
    Changed := False;
    // get the text range to search in, ignore search in selection if nothing is selected
    DoBackward := soBackwards in Opts;
    DoPrompt := (soPrompt in Opts) and Assigned(PSyntaxEditData(CustomData).FOnReplaceText);
    DoReplace := soReplace in Opts;
    DoReplaceAll := soReplaceAll in Opts;
    DoFromCursor := not (soEntireScope in Opts);
    if SelAvail and (soSelectedOnly in Opts) then
    begin
      StartPoint := BlockBegin;
      EndPoint := BlockEnd;
      // ignore the cursor position when searching in the selection
      if DoBackward and not (soRegularExpression in Opts) then Current := EndPoint
                                                             else Current := StartPoint;
    end
    else
    begin
      StartPoint := MakePoint(0, 0);
      EndPoint.Y := PSyntaxEditData(CustomData).FLines.Count - 1;
      EndPoint.X := Length(PSyntaxEditData(CustomData).FLines.Strings[EndPoint.Y]) + 1;
      if DoFromCursor then
        if DoBackward then EndPoint := CaretXY
                      else StartPoint := CaretXY;
      if DoBackward then Current := EndPoint
                    else Current := StartPoint;
    end;
    if DoReplaceAll and not DoPrompt then BeginUpdate;

    try
      if soRegularExpression in Opts then DoRESearchReplace
                                        else DoPlainSearchReplace;
      if Changed then DoChange;
    finally
      if DoReplaceAll and not DoPrompt then EndUpdate;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetBookMark(BookMark: Integer; var X, Y: Integer): Boolean;

begin
  Result := False;
  if Bookmark in [0..9] then
  begin
    X := PSyntaxEditData(CustomData).FBookmarks[Bookmark].X;
    Y := PSyntaxEditData(CustomData).FBookmarks[Bookmark].Y;
    Result := True;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.IsBookmark(BookMark: Integer): Boolean;

var
  X, Y: Integer;

begin
  Result := GetBookMark(BookMark, X, Y);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ClearUndo;

begin
  PSyntaxEditData(CustomData).FUndoList.ClearList;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetSelTextExternal(const Value: WideString);

var
  State: TEditState;
  BB, BE: TPoint;

begin
  State := RecordState(True);
  // keep the position at which the new text will be inserted
  BB := MinPoint(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBlockEnd);
  SetSelText(Value);
  SetBlockBegin(CaretXY);
  // keep end of text block just inserted
  BE := CaretXY;
  with State do
    PSyntaxEditData(CustomData).FUndoList.AddChange(ecrReplace, Text, @Caret, @SelStart, @SelEnd, Value, @BE, @BB, @BE);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetOptions(const Value: TSyntaxEditOptions);

var
  ToBeSet,
  ToBeCleared,
  ToChange: TSyntaxEditOptions;

begin
  if PSyntaxEditData(CustomData).FOptions <> Value then
  begin
    ToBeSet := Value - PSyntaxEditData(CustomData).FOptions;
    ToBeCleared := PSyntaxEditData(CustomData).FOptions - Value;
    PSyntaxEditData(CustomData).FOptions := Value;
    ToChange := ToBeSet + ToBeCleared;

    if eoReadOnly in PSyntaxEditData(CustomData).FOptions then
      if eoShowCursorWhileReadOnly in ToBeSet then InitializeCaret
                                              else
      begin
        HideCaret;
        DestroyCaret;
      end;
    if (eoHideSelection in ToChange) or
       (eoShowControlChars in ToChange) or
       (eoUseSyntaxHighlighting in ToChange) then Invalidate;

    if eoLineNumbers in ToChange then
    begin
      PSyntaxEditData(CustomData).FGutterRect.Right := PSyntaxEditData(CustomData).FGutterWidth - 1;
      PSyntaxEditData(CustomData).FCharsInWindow := (ClientWidth - PSyntaxEditData(CustomData).FGutterRect.Right + 1) div PSyntaxEditData(CustomData).FCharWidth;
      Invalidate;
    end;

    // reset pos in case it's past EOL currently
    if (eoScrollPastEOL in ToBeCleared) and (PSyntaxEditData(CustomData).FCaretX > MaxRightChar) then CaretX := MaxRightChar;
    if (eoLineNumbers in ToChange) and Focused then UpdateCaret;
    DoSettingChanged;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetTabSize(Value: Integer);

begin
  if Value < 1 then Value := 1;
  if PSyntaxEditData(CustomData).FTabSize <> Value then
  begin
    PSyntaxEditData(CustomData).FTabSize := Value;
    Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.NextSmartTab(X, Y: Integer; SkipNonWhite: Boolean): Integer;

// Calculates the indent position starting with X and depending on the first
// line above Y which contains a white space char before X.
// X and Result are column values!

var
  I : Integer;
  Len : Integer;
  Line: WideString;

begin
  // cursor at line 0?
  if Y = 0 then Result := X // no next tab position available
           else
  begin
    // find a line above the current line which size is greater than X
    repeat
      Dec(Y);
      I := GetLineEnd(Y);
      if I > X then Break;
    until Y = 0;

    // found a line?
    if I > X then
    begin
      Line := PSyntaxEditData(CustomData).FLines.Strings[Y];
      Len := Length(Line);
      I := ColumnToCharIndex(MakePoint(X, Y));
      // skip non-white spaces if required
      {if SkipNonWhite then
        while (I < Len) and not UnicodeIsWhiteSpace(Word(Line[I + 1])) do Inc(I);
      }
      // now skip any white space character
      while (I < Len) and UnicodeIsWhiteSpace(Word(Line[I + 1])) do Inc(I);
      Result := CharIndexToColumn(MakePoint(I, Y));
    end
    else Result := X;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.Unindent(X, Y: Cardinal): Cardinal;

// Calculates the next unindent position starting with X and depending on the
// first line above Y which contains a white space char before X.
// X must be a column value!

  //--------------- local functions -------------------------------------------

  function FindNonWhiteSpaceColumn(X, Y: Cardinal; var NewX: Cardinal): Boolean;

  var
    Index: Integer;
    Line: WideString;

  begin
    NewX := X;
    Result := False;
    Line := PSyntaxEditData(CustomData).FLines.Strings[Y];
    while NewX > 0 do
    begin
      Dec(NewX);
      // turn column into its corresponding character index...
      Index := ColumnToCharIndex(MakePoint(NewX, Y));
      // ... and turn it back into the start column of this char
      NewX := CharIndexToColumn(MakePoint(Index, Y));
      // fork out if we found a non-white space char
      if (Index < Length(Line)) and not UnicodeIsWhiteSpace(Word(Line[Index + 1])) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;

  //---------------------------------------------------------------------------

  function FindWhiteSpaceColumn(X, Y: Cardinal; var NewX: Cardinal): Boolean;

  var
    Index: Integer;
    Line: WideString;

  begin
    NewX := X;
    Result := False;
    Line := PSyntaxEditData(CustomData).FLines.Strings[Y];
    while NewX > 0 do
    begin
      Dec(NewX);
      // turn column into its corresponding character index...
      Index := ColumnToCharIndex(MakePoint(NewX, Y));
      // ... and turn it back into the start column of this char
      NewX := CharIndexToColumn(MakePoint(Index, Y));
      // fork out if we found a white space
      if (Index < Length(Line)) and UnicodeIsWhiteSpace(Word(Line[Index + 1])) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;

  //--------------- end local functions ---------------------------------------

begin
  // cursor at line 0?
  if (X = 0) or (Y = 0) then Result := 0 // no previous tab position available
                        else
  begin
    // find a line above the current line, which is not empty and whose first
    // non-white character is before X
    repeat
      // go one line up (picturally speaking, actually we use the previous line)
      Dec(Y);
      // find last non-white space before current column
      if FindNonWhiteSpaceColumn(X, Y, Result) then
      begin
        // we found a non-white space, now search the first white
        // space column before this column
        if FindWhiteSpaceColumn(Result, Y, Result) then
        begin
          // if there's such a column then advance to next column (which is then
          // a non-white space column)
          Result := NextCharPos(Result, Y);
        end;
        // leave loop, since we either found what we were looking for or
        // the line in question has no white chars at the beginning (which means
        // unindentation target column is 0)
        Break;
      end;
      // turn around if there was no unindent column by going up one line
    until Y = 0;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.NextTabPos(Index: Integer): Integer;

// calculates next tab stop position

begin
  Result := (Index div PSyntaxEditData(CustomData).FTabSize + 1) * PSyntaxEditData(CustomData).FTabSize;
end;

//----------------------------------------------------------------------------------------------------------------------

{procedure TVMHSyntaxEdit.CMSysColorChange(var Message: TMessage);

begin
  inherited;
  ConvertAndAddImages(FInternalBMList);
end; }

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.DoChange;

begin
  PSyntaxEditData(CustomData).FModified := True;
  if Assigned(FOnChange) then FOnChange(@Self);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetScrollBarMode(const Value: TScrollBarMode);

begin
  if PSyntaxEditData(CustomData).FScrollBarMode <> Value then
  begin
    PSyntaxEditData(CustomData).FScrollBarMode := Value;
    FlatSB_SetScrollProp(Handle, WSB_PROP_HSTYLE, ScrollBarProp[PSyntaxEditData(CustomData).FScrollBarMode], True);
    FlatSB_SetScrollProp(Handle, WSB_PROP_VSTYLE, ScrollBarProp[PSyntaxEditData(CustomData).FScrollBarMode], True);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.CalcCharWidths(Index: Integer);

// Creates an array of integer values describing the width of each character
// of a given line in pixels.

var
  I, Run,
  NewPos: Integer;
  P: PWideChar;
  Multiplyer: Integer;

begin
  if Index > PSyntaxEditData(CustomData).FLines.Count - 1 then Index := PSyntaxEditData(CustomData).FLines.Count - 1;
  if PSyntaxEditData(CustomData).FLastCalcIndex <> Index then
  begin
    PSyntaxEditData(CustomData).FLastCalcIndex := Index;
    if Index = -1 then PSyntaxEditData(CustomData).FCharWidthArray := nil
                  else
    begin
      P := PWideChar(PSyntaxEditData(CustomData).FLines.Strings[Index]);
      SetLength(PSyntaxEditData(CustomData).FCharWidthArray, Length(PSyntaxEditData(CustomData).FLines.Strings[Index]));
      Multiplyer := PSyntaxEditData(CustomData).FTabSize * PSyntaxEditData(CustomData).FCharWidth;
      // running term for tabulator calculation
      Run := 0;
      I := 0;
      while P^ <> WideNull do
      begin
        if P^ = Tabulator then
        begin
          // calculate new absolute position
          NewPos := (Run div Multiplyer + 1) * Multiplyer;
          // make this a relative distance
          PSyntaxEditData(CustomData).FCharWidthArray[I] := NewPos - Run;
        end
        else
        begin
          PSyntaxEditData(CustomData).FCharWidthArray[I] := PSyntaxEditData(CustomData).FCharWidth;
        end;

        Inc(Run, PSyntaxEditData(CustomData).FCharWidthArray[I]);
        Inc(I);
        Inc(P);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.CalcCharWidths(const S: WideString; TabSz, CharWth: Cardinal);

// Creates an array of integer values describing the width of each character
// of the given WideString in pixels.

var
  I: Integer;
  Run,
  NewPos: Cardinal;

begin
  // always mark last calculated line as invalid as the given line might be from
  // somewhere else but not FLines
  PSyntaxEditData(CustomData).FLastCalcIndex := -1;

  SetLength(PSyntaxEditData(CustomData).FCharWidthArray, Length(S));
  // running term for tabulator calculation
  Run := 0;
  for I := 0 to Length(S) - 1 do
  begin
    if S[I + 1] = Tabulator then
    begin
      // calculate new absolute position
      NewPos := (Run div (TabSz * CharWth) + 1) * TabSz * CharWth;
      // make this a relative distance
      PSyntaxEditData(CustomData).FCharWidthArray[I] := NewPos - Run;
    end
    else PSyntaxEditData(CustomData).FCharWidthArray[I] := PSyntaxEditData(CustomData).FCharWidth;
    Inc(Run, PSyntaxEditData(CustomData).FCharWidthArray[I]);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetModified: Boolean;

begin
  Result := PSyntaxEditData(CustomData).FModified or PSyntaxEditData(CustomData).FLines.Modified;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetModified(const Value: Boolean);

begin
  PSyntaxEditData(CustomData).FModified := Value;
  PSyntaxEditData(CustomData).FLines.Modified := Value;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetMarkLine(Value: Integer);

begin
  if Value < -1 then Value := -1;
  if PSyntaxEditData(CustomData).FMarkLine <> Value then
  begin
    if PSyntaxEditData(CustomData).FMarkLine > -1 then InvalidateLine(PSyntaxEditData(CustomData).FMarkLine);
    PSyntaxEditData(CustomData).FMarkLine := Value;
    if PSyntaxEditData(CustomData).FMarkLine > -1 then InvalidateLine(PSyntaxEditData(CustomData).FMarkLine);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetMarkColor(const Value: PColors);

begin
  PSyntaxEditData(CustomData).FMarkColor.FBackground := Value.FBackground;
  PSyntaxEditData(CustomData).FMarkColor.FForeground := Value.FForeground;
  if PSyntaxEditData(CustomData).FMarkLine > -1 then InvalidateLine(PSyntaxEditData(CustomData).FMarkLine);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.NextCharPos(ThisPosition: Cardinal; ForceNonDefault: Boolean): Cardinal;

begin
  Result := NextCharPos(ThisPosition, PSyntaxEditData(CustomData).FCaretY, ForceNonDefault);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.NextCharPos(ThisPosition, Line: Cardinal; ForceNonDefault: Boolean): Cardinal;

// Determines the next character position for the given line depending on the
// column given by ThisPosition. The returned index can directly be used to set the caret.

var
  PixelPos, Run: Cardinal;
  I: Cardinal;

begin
  CalcCharWidths(Line);
  // turn column into pixel position
  PixelPos := ThisPosition * Cardinal(PSyntaxEditData(CustomData).FCharWidth);
  if ((eoCursorThroughTabs in PSyntaxEditData(CustomData).FOptions) and not ForceNonDefault) or
     (ThisPosition >= GetLineEnd(Line)) then Result := ThisPosition + 1
                                        else
  begin
    // The task is to find the first column which corresponds directly to a
    // character (which is not always the case, eg. tabs) and is larger than
    // the given position.
    Run := 0;
    // sum up character widths until we find a pixel position larger than the
    // given one
    for I := 0 to High(PSyntaxEditData(CustomData).FCharWidthArray) do
    begin
      // values in the char width array always correspond to an actual character index
      if PixelPos < Run then Break
                        else Inc(Run, PSyntaxEditData(CustomData).FCharWidthArray[I]);
    end;
    Result := Run div Cardinal(PSyntaxEditData(CustomData).FCharWidth);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.PreviousCharPos(ThisPosition: Cardinal): Cardinal;

begin
  Result := PreviousCharPos(ThisPosition, PSyntaxEditData(CustomData).FCaretY);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.PreviousCharPos(ThisPosition, Line: Cardinal): Cardinal;

// Determines the previous character position for the given line depending on the
// column given by ThisPosition. The returned index can directly be used to set the caret.

var
  PixelPos, Run: Cardinal;
  I: Cardinal;

begin
  if ThisPosition = 0 then Result := 0
                      else
  begin
    CalcCharWidths(Line);
    // turn column into pixel position
    PixelPos := ThisPosition * Cardinal(PSyntaxEditData(CustomData).FCharWidth);
    if (eoCursorThroughTabs in PSyntaxEditData(CustomData).FOptions) or
       (ThisPosition > GetLineEnd(Line)) then Result := ThisPosition - 1
                                         else
    begin
      // The task is to find the last column which corresponds directly to a
      // character (which is not always the case, eg. tabs) and is smaller than
      // the given position.
      Run := 0;
      // sum up character widths until we find the largest pixel position smaller
      // than the given one
      for I := 0 to High(PSyntaxEditData(CustomData).FCharWidthArray) do
      begin
        // values in the char width array always correspond to an actual character index
        if PixelPos <= (Run + PSyntaxEditData(CustomData).FCharWidthArray[I]) then Break
                                                  else Inc(Run, PSyntaxEditData(CustomData).FCharWidthArray[I]);
      end;
      Result := Run div Cardinal(PSyntaxEditData(CustomData).FCharWidth);
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetLineEnd: Cardinal;

begin
  Result := GetLineEnd(PSyntaxEditData(CustomData).FCaretY);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetLineEnd(Index: Cardinal): Cardinal;

// calculates the first unused column of the line given by Index

var
  I: Integer;

begin
  CalcCharWidths(Index);
  Result := 0;
  for I := 0 to High(PSyntaxEditData(CustomData).FCharWidthArray) do Inc(Result, PSyntaxEditData(CustomData).FCharWidthArray[I]);
  Result := Result div Cardinal(PSyntaxEditData(CustomData).FCharWidth);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.ColumnToCharIndex(X: Cardinal): Cardinal;

begin
  Result := ColumnToCharIndex(MakePoint(X, PSyntaxEditData(CustomData).FCaretY));
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.ColumnToCharIndex(Pos: TPoint): Cardinal;

// Calculates the character index into the line given by Y. X and Y are usually a
// caret position. Because of non-default width characters (like tabulators) the
// CaretX position is merely a column value and does not directly correspond to a
// particular character. The result can be used to address a character in the line
// given by Y or is a generic char index if X is beyond any char in Y.

var
  Run: Integer;

begin
  CalcCharWidths(Pos.Y);
  Run := 0;
  Pos.X := Pos.X * PSyntaxEditData(CustomData).FCharWidth;
  Result := 0;
  while Result < Cardinal(Length(PSyntaxEditData(CustomData).FCharWidthArray)) do
  begin
    Inc(Run, PSyntaxEditData(CustomData).FCharWidthArray[Result]);
    if Run > Pos.X then Break;
    Inc(Result);
  end;
  // If the run is still smaller than the given column then add "virtual" chars
  // to be able to add a character (far) beyond the current end of the line.
  if Run < Pos.X then Inc(Result, (Pos.X - Run) div PSyntaxEditData(CustomData).FCharWidth);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.CharIndexToColumn(X: Cardinal): Cardinal;

begin
  Result := CharIndexToColumn(MakePoint(X, PSyntaxEditData(CustomData).FCaretY));
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.CharIndexToColumn(X: Cardinal; const S: WideString; TabSz, CharWth: Cardinal): Cardinal;

// calculates the corresponding column from the given character position using the
// text stored in S

var
  I: Cardinal;

begin
  CalcCharWidths(S, TabSz, CharWth);
  I := 0;
  Result := 0;
  while I < X do
  begin
    if I < Cardinal(Length(PSyntaxEditData(CustomData).FCharWidthArray)) then Inc(Result, PSyntaxEditData(CustomData).FCharWidthArray[I])
                                             else Inc(Result, CharWth);
    Inc(I);
  end;
  Result := Result div Cardinal(CharWth);
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.CharIndexToColumn(Pos: TPoint): Cardinal;

// calculates the corresponding column from the given character position using the
// text stored in FLines at position Pos.Y

var
  I: Integer;

begin
  CalcCharWidths(Pos.Y);
  I := 0;
  Result := 0;
  while I < Pos.X do
  begin
    if I < Length(PSyntaxEditData(CustomData).FCharWidthArray) then Inc(Result, PSyntaxEditData(CustomData).FCharWidthArray[I])
                                   else Inc(Result, PSyntaxEditData(CustomData).FCharWidth);
    Inc(I);
  end;
  Result := Result div Cardinal(PSyntaxEditData(CustomData).FCharWidth);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.ReplaceLeftTabs(var S: WideString);

// replaces all leading tab characters in the given WideString by a number of spaces given
// by the current tab size

var
  Cnt: Integer;

begin
  Cnt := LeftSpaces(S);
  while Cnt > 0 do
  begin
    if S[Cnt] = Tabulator then
    begin
      System.Delete(S, Cnt, 1);
      System.Insert(WideStringOfChar(' ', PSyntaxEditData(CustomData).FTabSize), S, Cnt);
    end;
    Dec(Cnt);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.LeftSpaces(const S: WideString): Cardinal;

// counts the number of white spaces at the beginning of the WideString;
// a tab is considered as one space here

var
  Run: PWideChar;

begin
  Run := PWideChar(S);
  while UnicodeIsWhiteSpace(Word(Run^)) do Inc(Run);
  Result := Run - PWideChar(S);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.BlockIndent;

// Inserts FIndentSize space characters before every line in the current selection.
// Note: A designed side effect is that all leading tab characters in the concerned
//       lines will be replaced by the proper number of spaces!

var
  I, J,
  Last: Integer;
  Line: WideString;
  BB, BE: PPoint;

  SelStrt,
  SelEnd,
  OldCaret,
  NewCaret: TPoint;
  T1, T2: PWideStringList;

begin
  if SelAvail then
  begin
    BeginUpdate;
    // By using references instead of a copy we can directly work on the selection
    // variables and have not to worry about whether the block begin is really
    // before the block end.
    BB := MinPointAsReference(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBLockEnd);
    BE := MaxPointAsReference(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBLockEnd);

    // exclude last selection line if it does not contain any selected chars
    if BE.X > 0 then Last := BE.Y
                else Last := BE.Y - 1;

    // save state for undo, this needs special care as we are going to replace
    // characters not in the current selection
    OldCaret := CaretXY;
    SelStrt := BB^;
    SelEnd := BE^;

    T1 := NewWideStringList;
    T1.Capacity := Last - BB.Y + 1;
    T2 := NewWideStringList;
    T2.Capacity := Last - BB.Y + 1;

    for I := BB.Y to Last do
    begin
      Line := PSyntaxEditData(CustomData).FLines.Strings[I];
      // copy all lines (entirely) which are somehow touched by the current selection
      T1.Add(Line);
      ReplaceLeftTabs(Line);
      System.Insert(WideStringOfChar(' ', PSyntaxEditData(CustomData).FIndentSize), Line, 1);
      PSyntaxEditData(CustomData).FLines.Strings[I] := Line;
      // copy also all lines after they have been changed
      T2.Add(Line);

      // adjust cursor if it is at this particular line, this needs to be done only
      // once, hence I put it herein
      if PSyntaxEditData(CustomData).FCaretY = I then
      begin
        J := GetLineEnd(I);
        // cursor beyond end of line?
        if PSyntaxEditData(CustomData).FCaretX >= J then CaretX := J
                        else
        begin
          // cursor in leading white space area?
          J := LeftSpaces(Line); // don't need TrimRightW here, as it has already been
                                 // verified that the cursor is before a non-white space char
          if PSyntaxEditData(CustomData).FCaretX < J then CaretX := J
                         else CaretX := Cardinal(PSyntaxEditData(CustomData).FCaretX) + PSyntaxEditData(CustomData).FIndentSize;
        end;
      end
    end;

    // adjust selection appropriately (the Delphi IDE moves the selection start and
    // end to the first non-whitespace if there's no non-whitespace before the
    // particular X position, hence I'll do it too)
    Inc(BB.X, PSyntaxEditData(CustomData).FIndentSize);
    Line := PSyntaxEditData(CustomData).FLines.Strings[BB.Y];
    I := LeftSpaces(Line);
    if I >= BB.X then BB.X := I;
    I := GetLineEnd(BB.Y);
    if I < BB.X then BB.X := I;

    if BE.X > 0 then
    begin
      Inc(BE.X, PSyntaxEditData(CustomData).FIndentSize);
      Line := PSyntaxEditData(CustomData).FLines.Strings[BE.Y];
      I := LeftSpaces(Line);
      if I >= BE.X then BE.X := I;
      I := GetLineEnd(BE.Y);
      if I < BE.X then BE.X := I;
    end;

    // no further cursor adjustion, if the cusror is, by any means, not on any of
    // the lines in the current selection then it won't be updated at all
    NewCaret := CaretXY;
    PSyntaxEditData(CustomData).FUndoList.AddChange(ecrIndentation, T1.Text, @OldCaret, @SelStrt, @SelEnd,
                                        T2.Text, @NewCaret, @PSyntaxEditData(CustomData).FBlockBegin, @PSyntaxEditData(CustomData).FBlockEnd);

    T1.Free;
    T2.Free;
    EndUpdate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.BlockUnindent;

// Removes first FIndentSize space characters of every line in the current selection
// or all leading white spaces if their count is less than FIndentSize.
// Note: A designed side effect is that all leading tab characters in the concerned
//       lines will be replaced by the proper number of spaces!

var
  I, J,
  Last: Integer;
  Line: WideString;
  BB, BE: PPoint;

  SelStrt,
  SelEnd,
  OldCaret,
  NewCaret: TPoint;
  OldText,
  NewText: WideString;

begin
  if SelAvail then
  begin
    BeginUpdate;
                               
    // By using references instead of a copy we can directly work on the selection
    // variables and have not to worry about whether the block begin is really
    // before the block end.
    BB := MinPointAsReference(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBLockEnd);
    BE := MaxPointAsReference(PSyntaxEditData(CustomData).FBlockBegin, PSyntaxEditData(CustomData).FBLockEnd);

    // exclude last selection line if it does not contain any selected chars
    if BE.X > 0 then Last := BE.Y
                else Last := BE.Y - 1;

    // save state for undo, this needs special care as we are going to replace
    // characters not in the current selection
    OldText := '';
    NewText := '';
    OldCaret := CaretXY;
    SelStrt := BB^;
    SelEnd := BE^;

    for I := BB.Y to Last do
    begin
      Line := PSyntaxEditData(CustomData).FLines.Strings[I];
      // copy all lines (entirely) which are somehow touched by the current selection
      OldText := OldText + Line + CRLF;
      ReplaceLeftTabs(Line);
      J := LeftSpaces(Line);
      if Cardinal(J) >= PSyntaxEditData(CustomData).FIndentSize then System.Delete(Line, 1, PSyntaxEditData(CustomData).FIndentSize)
                                    else System.Delete(Line, 1, J);
      PSyntaxEditData(CustomData).FLines.Strings[I] := Line;
      // copy also all lines after they have been changed
      NewText := NewText + Line + CRLF;

      // adjust cursor if it is at this particular line, this needs to be done only
      // once, hence I put it herein
      if PSyntaxEditData(CustomData).FCaretY = I then
      begin
        J := GetLineEnd(I);
        // cursor beyond end of line?
        if PSyntaxEditData(CustomData).FCaretX >= J then CaretX := J
                        else
        begin
          // cursor in leading white space area?
          J := LeftSpaces(Line); // don't need TrimRightW here, as it has already been
                                 // verified that the cursor is before a non-white space char
          if PSyntaxEditData(CustomData).FCaretX < J then CaretX := J
                         else CaretX := PSyntaxEditData(CustomData).FCaretX - Integer(PSyntaxEditData(CustomData).FIndentSize);
        end;
      end
    end;
    
    // adjust selection appropriately (the Delphi IDE moves the selection start and
    // end to the first non-whitespace if there's no non-whitespace before the
    // particular X position, hence I'll do it too)
    Dec(BB.X, PSyntaxEditData(CustomData).FIndentSize);
    Line := PSyntaxEditData(CustomData).FLines.Strings[BB.Y];
    I := LeftSpaces(Line);
    if I >= BB.X then BB.X := I;
    I := GetLineEnd(BB.Y);
    if I < BB.X then BB.X := I;

    if BE.X > 0 then
    begin
      Dec(BE.X, PSyntaxEditData(CustomData).FIndentSize);
      Line := PSyntaxEditData(CustomData).FLines.Strings[BE.Y];
      I := LeftSpaces(Line);
      if I >= BE.X then BE.X := I;
      I := GetLineEnd(BE.Y);
      if I < BE.X then BE.X := I;
    end;
    
    // no further cursor adjustion, if the cursor is, by any mean, not on any of
    // the lines in the current selection then it won't be updated at all
    NewCaret := CaretXY;
    PSyntaxEditData(CustomData).FUndoList.AddChange(ecrIndentation, OldText, @OldCaret, @SelStrt, @SelEnd,
                                        NewText, @NewCaret, @PSyntaxEditData(CustomData).FBlockBegin, @PSyntaxEditData(CustomData).FBlockEnd);

    EndUpdate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetIndentSize(Value: Cardinal);

begin
  if Value < 1 then Value := 1;
  if PSyntaxEditData(CustomData).FIndentSize <> Value then
  begin
    PSyntaxEditData(CustomData).FIndentSize := Value;
    Invalidate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

{procedure TVMHSyntaxEdit.CMMouseWheel(var Message: TCMMouseWheel);

var
  ScrollCount: Integer;

begin
  inherited;
  if Message.Result = 0 then
    with Message do
    begin
      Result := 1;
      if ssCtrl in ShiftState then ScrollCount := FLinesInWindow * (WheelDelta div WHEEL_DELTA)
                              else ScrollCount := Mouse.WheelScrollLines * (WheelDelta div WHEEL_DELTA);
      TopLine := TopLine - ScrollCount;
      Update;
    end;
end;   }

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetLineNumberFont(const Value: PGraphicTool);

begin
  PSyntaxEditData(CustomData).FLineNumberFont.Assign(Value);
  LineNumberFontChanged(nil);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.LineNumberFontChanged(Sender: PGraphicTool);

begin
  if HandleAllocated then
  begin
    InvalidateRect(Handle, @PSyntaxEditData(CustomData).FGutterRect, False);
    UpdateWindow(Handle);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetScrollHintColor(const Value: PColors);

begin
  PSyntaxEditData(CustomData).FScrollHintColor.FBackground := Value.FBackground;
  PSyntaxEditData(CustomData).FScrollHintColor.FForeground := Value.FForeground;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVMHSyntaxEdit.SetSelectedColor(const Value: PColors);

begin
  PSyntaxEditData(CustomData).FSelectedColor.FBackground := Value.FBackground;
  PSyntaxEditData(CustomData).FSelectedColor.FForeground := Value.FForeground;
  Invalidate;
end;

//----------------------------------------------------------------------------------------------------------------------

const
  // associated languages to particular Unicode code block,
  CodeBlockToLanguage: array[0..67] of LCID =
    (
    LANG_NEUTRAL, // Basic Latin
    LANG_NEUTRAL, // Latin-1 Supplement
    LANG_NEUTRAL, // Latin Extended-A
    LANG_NEUTRAL, // Latin Extended-B
    LANG_NEUTRAL, // IPA Extensions
    LANG_NEUTRAL, // Spacing Modifier Letters
    LANG_NEUTRAL, // Combining Diacritical Marks
    LANG_GREEK,   // Greek
    LANG_RUSSIAN, // Cyrillic
    LANG_NEUTRAL, // Armenian
    LANG_HEBREW,  // Hebrew
    LANG_ARABIC,  // Arabic
    LANG_NEUTRAL, // Devanagari
    LANG_NEUTRAL, // Bengali
    LANG_NEUTRAL, // Gurmukhi
    LANG_NEUTRAL, // Gujarati
    LANG_NEUTRAL, // Oriya
    LANG_NEUTRAL, // Tamil
    LANG_NEUTRAL, // Telugu
    LANG_NEUTRAL, // Kannada
    LANG_NEUTRAL, // Malayalam
    LANG_THAI,    // Thai
    LANG_NEUTRAL, // Lao
    LANG_NEUTRAL, // Tibetan
    LANG_NEUTRAL, // Georgian
    LANG_NEUTRAL, // Hangul Jamo
    LANG_NEUTRAL, // Latin Extended Additional
    LANG_GREEK,   // Greek Extended
    LANG_NEUTRAL, // General Punctuation
    LANG_NEUTRAL, // Superscripts and Subscripts
    LANG_NEUTRAL, // Currency Symbols
    LANG_NEUTRAL, // Combining Marks for Symbols
    LANG_NEUTRAL, // Letterlike Symbols
    LANG_NEUTRAL, // Number Forms
    LANG_NEUTRAL, // Arrows
    LANG_NEUTRAL, // Mathematical Operators
    LANG_NEUTRAL, // Miscellaneous Technical
    LANG_NEUTRAL, // Control Pictures
    LANG_NEUTRAL, // Optical Character Recognition
    LANG_NEUTRAL, // Enclosed Alphanumerics
    LANG_NEUTRAL, // Box Drawing
    LANG_NEUTRAL, // Block Elements
    LANG_NEUTRAL, // Geometric Shapes
    LANG_NEUTRAL, // Miscellaneous Symbols
    LANG_NEUTRAL, // Dingbats
    LANG_NEUTRAL, // CJK Symbols and Punctuation
    LANG_JAPANESE, // Hiragana
    LANG_JAPANESE, // Katakana
    LANG_NEUTRAL, // Bopomofo
    LANG_NEUTRAL, // Hangul Compatibility Jamo
    LANG_NEUTRAL, // Kanbun
    LANG_CHINESE, // Enclosed CJK Letters and Months
    LANG_CHINESE, // CJK Compatibility
    LANG_CHINESE, // CJK Unified Ideographs
    LANG_NEUTRAL, // Hangul Syllables
    LANG_NEUTRAL, // High Surrogates
    LANG_NEUTRAL, // High Private Use Surrogates
    LANG_NEUTRAL, // Low Surrogates
    LANG_NEUTRAL, // Private Use
    LANG_ARABIC,  // CJK Compatibility Ideographs
    LANG_NEUTRAL, // Alphabetic Presentation Forms
    LANG_ARABIC,  // Arabic Presentation Forms-A
    LANG_NEUTRAL, // Combining Half Marks
    LANG_CHINESE, // CJK Compatibility Forms
    LANG_NEUTRAL, // Small Form Variants
    LANG_ARABIC,  // Arabic Presentation Forms-B
    LANG_NEUTRAL, // Halfwidth and Fullwidth Forms
    LANG_NEUTRAL  // Specials
    );

function TVMHSyntaxEdit.ActivateKeyboard(const C: WideChar): Boolean;

// Tries to activate a keyboard layout based on the code block which contains C.
// If the layout can be activated (if needed then it is loaded) then Result is True
// otherwise False.
// Consider this function as being experimental as the character to language conversion
// does not work very well. Need to investigate this further...

var
  CodeBlock: Cardinal;
  KBID: String;

begin
  CodeBlock := CodeBlockFromChar(C);
  Result := ActivateKeyboardLayout(CodeBlockToLanguage[CodeBlock], 0) <> 0;
  if not Result then
  begin
    KBID := Format('%x', [CodeBlockToLanguage[CodeBlock]]);
    Result := LoadKeyboardLayout(PChar(KBID), KLF_SUBSTITUTE_OK) <> 0;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVMHSyntaxEdit.GetBookmarkOptions: PBookmarkOptions;
begin
  Result := PSyntaxEditData(CustomData)^.FBookmarkOptions;
end;

function TVMHSyntaxEdit.GetCharWidth: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FCharWidth;
end;

function TVMHSyntaxEdit.GetExtraLineSpacing: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FExtraLineSpacing;
end;

function TVMHSyntaxEdit.GetGutterColor: TColor;
begin
  Result := PSyntaxEditData(CustomData)^.FGutterColor;
end;

function TVMHSyntaxEdit.GetGutterWidth: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FGutterColor;
end;

function TVMHSyntaxEdit.GetHighLighter: PVMHCustomHighlighter;
begin
  Result := PSyntaxEditData(CustomData)^.FHighLighter;
end;

function TVMHSyntaxEdit.GetIndentSize: Cardinal;
begin
  Result := PSyntaxEditData(CustomData)^.FIndentSize;
end;

function TVMHSyntaxEdit.GetInsertCaret: TCaretType;
begin
  Result := PSyntaxEditData(CustomData)^.FInsertCaret;
end;

function TVMHSyntaxEdit.GetKeyStrokes: PKeyStrokes;
begin
  Result := PSyntaxEditData(CustomData)^.FKeyStrokes;
end;

function TVMHSyntaxEdit.GetLineNumberFont: PGraphicTool;
begin
  Result := PSyntaxEditData(CustomData)^.FLineNumberFont;
end;

function TVMHSyntaxEdit.GetLines: PSyntaxEditorStrings;
begin
  Result := PSyntaxEditData(CustomData)^.FLines;
end;

function TVMHSyntaxEdit.GetMarginColor: TColor;
begin
  Result := PSyntaxEditData(CustomData)^.FMarginColor;
end;

function TVMHSyntaxEdit.GetMarkColor: PColors;
begin
  Result := PSyntaxEditData(CustomData)^.FMarkColor;
end;

function TVMHSyntaxEdit.GetMarkLine: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FMarkLine;
end;

function TVMHSyntaxEdit.GetOnBookmark: TBookmarkEvent;
begin
  Result := PSyntaxEditData(CustomData)^.FOnBookmark;
end;

function TVMHSyntaxEdit.GetOnCaretChange: TCaretEvent;
begin
  Result := PSyntaxEditData(CustomData)^.FOnCaretChange;
end;

function TVMHSyntaxEdit.GetOnProcessCommand: TProcessCommandEvent;
begin
  Result := PSyntaxEditData(CustomData)^.FOnProcessCommand;
end;

function TVMHSyntaxEdit.GetOnProcessUserCommand: TProcessCommandEvent;
begin
  Result := PSyntaxEditData(CustomData)^.FOnProcessUserCommand;
end;

function TVMHSyntaxEdit.GetOnReplaceText: TReplaceTextEvent;
begin
  Result := PSyntaxEditData(CustomData)^.FOnReplaceText;
end;

function TVMHSyntaxEdit.GetOnSettingChange: TOnEvent;
begin
  Result := PSyntaxEditData(CustomData)^.FOnSettingChange;
end;

function TVMHSyntaxEdit.GetOptions: TSyntaxEditOptions;
begin
  Result := PSyntaxEditData(CustomData)^.FOptions;
end;

function TVMHSyntaxEdit.GetOverwriteCaret: TCaretType;
begin
  Result := PSyntaxEditData(CustomData)^.FOverwriteCaret;
end;

function TVMHSyntaxEdit.GetRightMargin: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FRightMargin;
end;

function TVMHSyntaxEdit.GetScrollBarMode: TScrollBarMode;
begin
  Result := PSyntaxEditData(CustomData)^.FScrollBarMode;
end;

function TVMHSyntaxEdit.GetScrollBars: TScrollStyle;
begin
  Result := PSyntaxEditData(CustomData)^.FScrollBars;
end;

function TVMHSyntaxEdit.GetScrollHintColor: PColors;
begin
  Result := PSyntaxEditData(CustomData)^.FScrollHintColor;
end;

function TVMHSyntaxEdit.GetSelectedColor: PColors;
begin
  Result := PSyntaxEditData(CustomData)^.FSelectedColor;
end;

function TVMHSyntaxEdit.GetUndoList: PUndoList;
begin
  Result := PSyntaxEditData(CustomData)^.FUndoList;
end;

{function TVMHSyntaxEdit.GetUpdateCount: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FUpdateCount;
end;}

procedure TVMHSyntaxEdit.SetBookmarkOptions(const Value: PBookmarkOptions);
begin
  PSyntaxEditData(CustomData)^.FBookmarkOptions := Value;
end;

procedure TVMHSyntaxEdit.SetOnBookmark(const Value: TBookmarkEvent);
begin
  PSyntaxEditData(CustomData)^.FOnBookmark := Value;
end;

procedure TVMHSyntaxEdit.SetOnCaretChange(const Value: TCaretEvent);
begin
  PSyntaxEditData(CustomData)^.FOnCaretChange := Value;
end;

procedure TVMHSyntaxEdit.SetOnProcessCommand(
  const Value: TProcessCommandEvent);
begin
  PSyntaxEditData(CustomData)^.FOnProcessCommand := Value;
end;

procedure TVMHSyntaxEdit.SetOnProcessUserCommand(
  const Value: TProcessCommandEvent);
begin
  PSyntaxEditData(CustomData)^.FOnProcessUserCommand := Value;
end;

procedure TVMHSyntaxEdit.SetOnReplaceText(const Value: TReplaceTextEvent);
begin
  PSyntaxEditData(CustomData)^.FOnReplaceText := Value;
end;

procedure TVMHSyntaxEdit.SetOnSettingChange(const Value: TOnEvent);
begin
  PSyntaxEditData(CustomData)^.FOnSettingChange := Value;
end;

function TVMHSyntaxEdit.GetTabSize: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FTabSize;
end;

function TVMHSyntaxEdit.GetCaretX: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FCaretX;
end;

function TVMHSyntaxEdit.GetCaretY: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FCaretY;
end;

function TVMHSyntaxEdit.GetCharsInWindow: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FCharsInWindow;
end;

function TVMHSyntaxEdit.GetInfo: WideString;
begin
  Result := PSyntaxEditData(CustomData)^.FInfo;
end;

function TVMHSyntaxEdit.GetLinesInWindow: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FLinesInWindow;
end;

procedure TVMHSyntaxEdit.SetInfo(const Value: WideString);
begin
  PSyntaxEditData(CustomData)^.FInfo := Value;
end;

procedure TVMHSyntaxEdit.Recreate;
begin
{}
end;

function FlatSB_SetScrollInfo;          external cctrl name 'FlatSB_SetScrollInfo';
function InitializeFlatSB;              external cctrl name 'InitializeFlatSB';
function FlatSB_SetScrollProp;          external cctrl name 'FlatSB_SetScrollProp';
function FlatSB_EnableScrollBar;        external cctrl name 'FlatSB_EnableScrollBar';

function TVMHSyntaxEdit.DragCallback(Sender: PControl; ScrX, ScrY: Integer;
  var CursorShape: Integer; var Stop: Boolean): Boolean;
var P : PChar;
    Accept : Boolean;
    H : HWND;
    Pt : TPoint;
begin
  if Stop then
  begin
    PSyntaxEditData(CustomData).FScrollTimer.Enabled := False;
    CaretXY := PSyntaxEditData(CustomData).FLastCaret; // restore previous caret position
    if not PSyntaxEditData(CustomData).FDragWasStarted then SetBlockBegin(PSyntaxEditData(CustomData).FLastCaret);
  end
  else
  begin
    GetMem(P, 17); 
    H := WindowFromPoint(MakePoint(ScrX, ScrY));
    GetClassName(H, P, 17);

    if P = 'obj_SyntaxEditor' then
    begin
      PSyntaxEditData(CustomData).FDragWasStarted := True;
      PSyntaxEditData(CustomData).FDropTarget := True;
      //Result := True;
{      case State of
      dsDragLeave:
        begin
          FDropTarget := False;
          FScrollTimer.Enabled := False;
          // give the timer time to process its pending message
          Application.ProcessMessages;
        end;
      dsDragEnter:
        begin
          // remember that we are drag target currently as the originator of the
          // drag operation might be another syntax edit instance
          FDropTarget := True;
          SetFocus;
          FScrollTimer.Enabled := True;
        end;}
    // If source and target are identical then we cannot drop on selected text.
    // If this edit is not the source then we accept the operation and will
    // replace the selected text by the incoming one.
      Pt := Sender.Screen2Client(MakePoint(ScrX, ScrY));
      if H = Sender.GetWindowHandle then Accept := not PosInSelection(PositionFromPoint(Pt.X, Pt.Y))
                                    else Accept := True;

      if Accept then
      begin
        // if Ctrl is pressed or Source is not this control then change
        // cursor to indicate copy instead of move
        if CopyOnDrop(@Self) then CursorShape := LoadCursor(0, IDC_UPARROW)
                             else CursorShape := LoadCursor(0, IDC_ARROW);
      end else CursorShape := LoadCursor(0, IDC_NO);
    end else
    begin
      CursorShape := LoadCursor(0, IDC_NO);
      PSyntaxEditData(CustomData).FDropTarget := False;
      PSyntaxEditData(CustomData).FScrollTimer.Enabled := False;

    end;
    FreeMem(P);
  end;
end;

function TVMHSyntaxEdit.GetCharAddon: Integer;
begin
  Result := PSyntaxEditData(CustomData)^.FCharAddon;
end;

procedure TVMHSyntaxEdit.SetCharAddon(const Value: Integer);
begin
  PSyntaxEditData(CustomData)^.FCharAddon := Value;
end;

function TVMHSyntaxEdit.GetBookmarksIL:PImageList;
begin
  Result := PSyntaxEditData(CustomData)^.FBookmarksIL;
end;

procedure TVMHSyntaxEdit.SetBookmarksIL(const Value:PImageList);
begin
  PSyntaxEditData(CustomData)^.FBookmarksIL := Value;
end;

procedure TVMHSyntaxEdit.ShowHint(Pos : Word);
var
  LineString: WideString;
  HintRect: TRect;
  P: TPoint;
  ButtonH: Integer;
  TI : TToolInfo;
  D : PSyntaxEditData;
begin
  D := CustomData;
  LineString := Int2Str(-D.FOffsetY + 1);
  // calculate optimal size for scroll hint window
  //HintRect := D.FScrollHint.CalcHintRect(2000, LineString, nil);
  HintRect := Self.ClientRect;
  // place it parallel to the thumb
  P := Client2Screen(MakePoint(0, 0));
  ButtonH := GetSystemMetrics(SM_CYVSCROLL)+ 8;
  OffsetRect(HintRect,
             P.X + ClientWidth - HintRect.Right - 2,
             ButtonH div 2 + P.Y + Round((ClientHeight - HintRect.Bottom - ButtonH) *
             Pos * D.FScrollFactor / D.FLines.Count));

  with TI do
  begin
    cbSize:=SizeOf(TI);
    uFlags:=TTF_SUBCLASS;
    hWnd:=Self.GetWindowHandle;
    uId:=0;
    rect.Left:= HintRect.Left;
    rect.Top:= HintRect.Top;
    rect.Right:= HintRect.Right;
    rect.Bottom:= HintRect.Bottom;
    hInst:=0;
    lpszText:=PChar(LineString);
  end;
  //SendMessage(D.FScrollHint, TTM_SETDELAYTIME, 3, 1);
  SendMessage(D.FScrollHint,TTM_ADDTOOL,0,Integer(@TI));
  //Font.Color := FScrollHintColor.FForeground;
  //Color := FScrollHintColor.FBackground;

  //UpdateWindow(D.FScrollHint);
end;

initialization
//  Screen.Cursors[crDragMove] := LoadCursor(HInstance, 'DRAGMOVE');
//  Screen.Cursors[crDragCopy] := LoadCursor(HInstance, 'DRAGCOPY');
finalization
end.
