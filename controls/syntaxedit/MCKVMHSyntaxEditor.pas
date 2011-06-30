unit MCKVMHSyntaxEditor;
//  VMHSyntaxEdit Компонент (VMHSyntaxEdit Component)
//  Автор (Author):
//    Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//    Вокс (Vox)
//  Дата создания (Create date): 9-окт(oct)-2002
//  Дата коррекции (Last correction Date): 21-ноя(nov)-2002
//  Версия (Version): 1.1
//  EMail:
//    Gandalf@kol.mastak.ru
//    vox@smtp.ru
//  WWW:
//    http://kol.mastak.ru
//  Благодарности (Thanks):
//    Mike Lischke
//
//  Новое в (New in):
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
  Windows, Controls, Classes, SysUtils, mirror, KOL, Graphics, MCKCtrls, KOLVMHSyntaxEditor, MCKVMHSyntaxEditHighlighter, mckObjs;

type
  TKOLVMHSyntaxEdit=class;

  TBookmarkOptions = class(TPersistent)
  private
    FEnableKeys: Boolean;
    FGlyphsVisible: Boolean;
    FLeftMargin: Integer;
    FOwner: TKOLVMHSyntaxEdit;
    procedure Change;
    procedure SetEnableKeys(Value: Boolean);
    procedure SetGlyphsVisible(Value: Boolean);
    procedure SetLeftMargin(Value: Integer);
  protected
    procedure GenerateCode( SL: TStrings; const AName, BookmarkOptionsPName: String);
  published
    property EnableKeys: Boolean read FEnableKeys write SetEnableKeys;
    property GlyphsVisible: Boolean read FGlyphsVisible write SetGlyphsVisible;
    property LeftMargin: Integer read FLeftMargin write SetLeftMargin;
  end;

  TColors = class(TPersistent)
  private
    FBackground: TColor;
    FForeground: TColor;
    FOwner: TKOLVMHSyntaxEdit;
    procedure Change;
    procedure SetBackground(Value: TColor);
    procedure SetForeground(Value: TColor);
  protected
    procedure GenerateCode( SL: TStrings; const AName, ColorsPName: String);
  published
    property Background: TColor read FBackground write SetBackground;
    property Foreground: TColor read FForeground write SetForeground;
  end;

  TKOLFontEx=class(TKOLFont)
  public
    procedure GenerateCode( SL: TStrings; const AName,FontPName: String; AFont: TKOLFont );
  end;

  TKOLVMHSyntaxEdit=class(TKOLControl)
  private
    FBookMarkOptions: TBookmarkOptions;

    FCharWidth: Integer;
    FExtraLineSpacing: Integer;
 {   property Font: PGraphicTool read GetFont write SetFont;}
    FGutterColor:TColor;
    FGutterWidth:Integer;
    FHighLighter: TKOLVMHCustomHighlighter;

    FIndentSize: Cardinal;
    FInsertCaret: TCaretType;
   { property Keystrokes: PKeyStrokes read GetKeyStrokes write SetKeystrokes;
}
    FLineNumberFont: TKOLFontEx;
{    property Lines: PSyntaxEditorStrings read GetLines write SetLines;
    property LineCount: Integer read GetLineCount;
    }
    FMarginColor: TColor;
    FMarkColor: TColors;

    FMarkLine: Integer;
    FMaxRightChar: Integer;

    FMaxUndo:Integer;
    FOptions:TSyntaxEditOptions;
    FOverwriteCaret:TCaretType;
{    //property UpdateLock: Integer read GetUpdateCount;
    }
    FRightMargin: Integer;
    FScrollBarMode: TScrollBarMode;
    FScrollBars: TScrollStyle;
    FScrollHintColor: TColors;
    FSelectedColor: TColors;
    FTabSize: Integer;
 {   property Tabstop: Boolean read fTabstop write fTabstop default True;
  }
    FOnCaretChange: TCaretEvent;
    FOnChange: TOnEvent;
//    property OnPaint: TPaintEvent read GetOnPaint write SetOnPaint;
    FOnBookmark: TBookmarkEvent;
    FOnProcessCommand: TProcessCommandEvent;
    FOnProcessUserCommand: TProcessCommandEvent;
    FOnReplaceText: TReplaceTextEvent;
    FOnSettingChange: TOnEvent;
    FCharAddon: Integer;
    FBookmarksIL: TKOLImageList;
{    }
    // Фиктивное свойство
    FNotAvailable:Boolean;
    procedure SetGutterColor(const Value:TColor);
    procedure SetGutterWidth(const Value:Integer);
    procedure SetMarginColor(const Value:TColor);
    procedure SetMarkLine(const Value:Integer);
    procedure SetMaxRightChar(const Value:Integer);
    procedure SetRightMargin(const Value:Integer);
    procedure SetMaxUndo(const Value:Integer);
    procedure SetOverwriteCaret(const Value:TCaretType);
    procedure SetOptions(const Value:TSyntaxEditOptions);
    procedure SetInsertCaret(const Value:TCaretType);
    procedure SetScrollBarMode(const Value:TScrollBarMode);
    procedure SetScrollBars(const Value:TScrollStyle);
    procedure SetCharWidth(const Value:Integer);
    procedure SetIndentSize(const Value:Cardinal);
    procedure SetExtraLineSpacing(const Value:Integer);
    procedure SetMarkColor(const Value:TColors);
    procedure SetScrollHintColor(const Value:TColors);
    procedure SetSelectedColor(const Value:TColors);
    procedure SetLineNumberFont(const Value:TKOLFontEx);
    procedure SetOnCaretChange(const Value:TCaretEvent);
    procedure SetOnBookmark(const Value:TBookmarkEvent);
    procedure SetOnProcessCommand(const Value:TProcessCommandEvent);
    procedure SetOnProcessUserCommand(const Value:TProcessCommandEvent);
    procedure SetOnReplaceText(const Value:TReplaceTextEvent);
    procedure SetOnSettingChange(const Value:TOnEvent);
    procedure SetOnChange(const Value:TOnEvent);
    procedure SetTabSize(const Value:Integer);
    procedure SetBookmarkOptions(const Value:TBookmarkOptions);
    procedure SetHighLighter(const Value:TKOLVMHCustomHighlighter);
    procedure SetCharAddon(const Value:Integer);
    procedure SetBookmarksIL(const Value:TKOLImageList);
  protected
    procedure AssignEvents(SL: TStringList; const AName: String);override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );override;
    function SetupParams(const AName,AParent : String) : String;override;
    procedure SetupLast(SL: TStringList; const AName, AParent, Prefix: String); override;
    function  AdditionalUnits: string; override;
    procedure SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property BookMarkOptions: TBookmarkOptions read FBookmarkOptions write SetBookmarkOptions;

    property CharWidth: Integer read FCharWidth write SetCharWidth;
    property ExtraLineSpacing: Integer read FExtraLineSpacing write SetExtraLineSpacing;
 {   property Font: PGraphicTool read GetFont write SetFont;
}
    property GutterColor: TColor read FGutterColor write SetGutterColor;
    property GutterWidth: Integer read FGutterWidth write SetGutterWidth;
    property HighLighter: TKOLVMHCustomHighlighter read FHighLighter write SetHighlighter;

    property IndentSize: Cardinal read FIndentSize write SetIndentSize;
    property InsertCaret: TCaretType read FInsertCaret write SetInsertCaret;
  {  property Keystrokes: PKeyStrokes read GetKeyStrokes write SetKeystrokes;
}
    property LineNumberFont: TKOLFontEx read FLineNumberFont write SetLineNumberFont;
{    property Lines: PSyntaxEditorStrings read GetLines write SetLines;
    property LineCount: Integer read GetLineCount;   }
    property MarginColor: TColor read FMarginColor write SetMarginColor;
    property MarkColor: TColors read FMarkColor write SetMarkColor;

    property MarkLine: Integer read FMarkLine write SetMarkLine;
    property MaxRightChar: Integer read FMaxRightChar write SetMaxRightChar;

    property MaxUndo: Integer read FMaxUndo write SetMaxUndo;

    property Options: TSyntaxEditOptions read FOptions write SetOptions;
    property OverwriteCaret: TCaretType read FOverwriteCaret write SetOverwriteCaret;
    //property UpdateLock: Integer read GetUpdateCount;

    property RightMargin: Integer read FRightMargin write SetRightMargin;
    property ScrollBarMode: TScrollBarMode read FScrollBarMode write SetScrollBarMode;
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssBoth;
    property ScrollHintColor: TColors read FScrollHintColor write SetScrollHintColor;
    property SelectedColor: TColors read FSelectedColor write SetSelectedColor;
    property TabSize: Integer read FTabSize write SetTabSize;
{    property Tabstop: Boolean read fTabstop write fTabstop default True;

  }
    property OnCaretChange: TCaretEvent read FOnCaretChange write SetOnCaretChange;
    property OnChange: TOnEvent read FOnChange write SetOnChange;
//    property OnPaint: TPaintEvent read GetOnPaint write SetOnPaint;
    property OnBookmark: TBookmarkEvent read FOnBookmark write SetOnBookmark;
    property OnProcessCommand: TProcessCommandEvent read FOnProcessCommand write SetOnProcessCommand;
    property OnProcessUserCommand: TProcessCommandEvent read FOnProcessUserCommand write SetOnProcessUserCommand;
    property OnReplaceText: TReplaceTextEvent read FOnReplaceText write SetOnReplaceText;
    property OnSettingChange: TOnEvent read FOnSettingChange write SetOnSettingChange;
    property CharAddon: Integer read FCharAddon write SetCharAddon;
    property TabStop;
    property BookmarksIL: TKOLImageList read FBookmarksIL write SetBookmarksIL;
//    property TabOrder;
    {}
    // Hide свойства
    // Т.е. они есть у TKOLControl, а у потомка не должны быть.
    // поэтому делаем их read-only и Object Inspector их не покажет
//    property Caption:Boolean read FNotAvailable;
//    property OnClick : Boolean read FNotAvailable;
//    property OnMouseDblClick: Boolean read FNotAvailable;

  end;

  procedure Register;

implementation

function Flags2Str( FlgSet: PDWORD; FlgArray: array of String): String;
var I : Integer;
    Mask : DWORD;
begin
  Result := '';
  Mask := FlgSet^;
  for I := 0 to High( FlgArray ) do
  begin
    if (FlgArray[ I ] <> '') and LongBool( Mask and 1 ) then
       Result := Result +', '+FlgArray[ I ];
    Mask := Mask shr 1;
  end;
  if Result <> '' then
    if Result[ 1 ] = ',' then
      Result := Copy( Result, 3, MaxInt );
  Result:='[ '+Result+' ]';    
end;

procedure TBookmarkOptions.Change;
begin
  FOwner.Change;
end;

procedure TBookmarkOptions.GenerateCode( SL: TStrings; const AName, BookmarkOptionsPName: String);
const
  BooleanToStr:array [Boolean] of String=('False','True');

  procedure AddLine( const S: String );
  begin
    SL.Add( '  ' + AName + '.' + BookmarkOptionsPName + '.' + S + ';' );
  end;

begin
  AddLine('EnableKeys:='+BooleanToStr[EnableKeys]);
  AddLine('GlyphsVisible:='+BooleanToStr[GlyphsVisible]);
  AddLine('LeftMargin:='+IntToStr(LeftMargin));
end;

procedure TBookmarkOptions.SetEnableKeys(Value: Boolean);
begin
  FEnableKeys:=Value;
  Change;
end;

procedure TBookmarkOptions.SetGlyphsVisible(Value: Boolean);
begin
  FGlyphsVisible:=Value;
  Change;
end;

procedure TBookmarkOptions.SetLeftMargin(Value: Integer);
begin
  FLeftMargin:=Value;
  Change;
end;

procedure TColors.Change;
begin
  FOwner.Change;
end;

procedure TColors.GenerateCode( SL: TStrings; const AName, ColorsPName: String);

  procedure AddLine( const S: String );
  begin
    SL.Add( '  ' + AName + '.' + ColorsPName + '.' + S + ';' );
  end;

begin
  AddLine('Background:='+ColorToString(Background));
  AddLine('Foreground:='+ColorToString(Foreground));
end;

procedure TColors.SetBackground(Value: TColor);
begin
  FBackground:=Value;
  Change;
end;

procedure TColors.SetForeground(Value: TColor);
begin
  FForeground:=Value;
  Change;
end;

procedure TKOLFontEx.GenerateCode( SL: TStrings; const AName,FontPName: String; AFont: TKOLFont );
const
  FontPitches: array [ TFontPitch ] of String = ( 'fpDefault', 'fpVariable', 'fpFixed' );
  FontStyleFlags: array [TFontStyle] of String = ('fsBold', 'fsItalic', 'fsUnderline', 'fsStrikeOut');
var BFont: TKOLFont;
    S: String;
    Lines: Integer;

    procedure AddLine( const S: String );
    begin
//      if Lines = 0 then
//        if (fOwner <> nil) and (fOwner is TKOLCustomControl) then
//          (fOwner as TKOLCustomControl).BeforeFontChange( SL, AName, '    ' );
      Inc( Lines );
      SL.Add( '    ' + AName + '.' + FontPName + '.' + S + ';' );
    end;

begin
  BFont := AFont;
  if AFont = nil then
    BFont := TKOLFont.Create( nil );

  Lines := 0;

  if Color <> BFont.Color then
    AddLine( 'Color := ' + Color2Str( Color ) );
  if FontStyle <> BFont.FontStyle then
    AddLine( 'FontStyle := '+Flags2Str(@FontStyle,FontStyleFlags) );
  if FontHeight <> BFont.FontHeight then
    AddLine( 'FontHeight := ' + IntToStr( FontHeight ) );
  if FontWidth <> BFont.FontWidth then
    AddLine( 'FontWidth := ' + IntToStr( FontWidth ) );
  if FontName <> BFont.FontName then
    AddLine( 'FontName := ''' + FontName + '''' );
  if FontOrientation <> BFont.FontOrientation then
    AddLine( 'FontOrientation := ' + IntToStr( FontOrientation ) );
  if FontCharset <> BFont.FontCharset then
    AddLine( 'FontCharset := ' + IntToStr( FontCharset ) );
  if FontPitch <> BFont.FontPitch then
    AddLine( 'FontPitch := ' + FontPitches[ FontPitch ] );

  if AFont = nil then
    BFont.Free;

//  if Lines > 0 then
//    if (fOwner <> nil) and (fOwner is TKOLCustomControl) then
//      (fOwner as TKOLCustomControl).AfterFontChange( SL, AName, '    ' );
end;

constructor TKOLVMHSyntaxEdit.Create( AOwner: TComponent );
begin
  inherited;
  FMarkColor:=TColors.Create;
  FMarkColor.FOwner:=Self;
  FScrollHintColor:=TColors.Create;
  FScrollHintColor.FOwner:=Self;
  FSelectedColor:=TColors.Create;
  FSelectedColor.FOwner:=Self;
  FLineNumberFont:=TKOLFontEx.Create(Self);
  FBookMarkOptions:=TBookMarkOptions.Create;
  FBookMarkOptions.FOwner:=Self;

  // Set Default Values
  FExtraLineSpacing:=0;
  FIndentSize:=2;
  FInsertCaret:=ctVerticalLine;
  FMarginColor:=clSilver;
  FMarkLine:=-1;
  FOptions:=DefaultOptions;
  FOverwriteCaret:=ctBlock;
  FRightMargin:=80;
  FScrollBars:=ssBoth;
  FTabSize:=8;
  FTabstop:=True;
end;

destructor TKOLVMHSyntaxEdit.Destroy;
begin
  FMarkColor.Free;
  FScrollHintColor.Free;
  FSelectedColor.Free;
  FLineNumberFont.Free;
  FBookMarkOptions.Free;
  inherited;
end;

function TKOLVMHSyntaxEdit.AdditionalUnits;
begin
  Result := ', KOLVMHSyntaxEditor';
end;

procedure TKOLVMHSyntaxEdit.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: String);
var S: String;
begin
  S := GenerateTransparentInits;
  SL.Add( Prefix + AName + ' := PVMHSyntaxEdit( New' + TypeName + '( '
          + SetupParams( AName, AParent ) + ' )' + S + ');' );
end;

procedure TKOLVMHSyntaxEdit.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
const
  OverwriteCaretToStr:array [TCaretType] of String=('ctVerticalLine', 'ctHorizontalLine', 'ctHalfBlock', 'ctBlock');
  ScrollBarModeToStr:array [TScrollBarMode] of String=('sbmRegular', 'sbmFlat', 'sbm3D');
  ScrollBarsToStr:array [TScrollStyle] of String=('ssNone', 'ssHorizontal', 'ssVertical', 'ssBoth');
var
  TMPStr:String;
  BFont: TKOLFont;
begin
  SL.Add('');
  inherited;
  SL.Add( Prefix + AName + '.GutterWidth:='+IntToStr(GutterWidth)+';');
  SL.Add( Prefix + AName + '.GutterColor:='+ColorToString(GutterColor)+';');
  SL.Add( Prefix + AName + '.MarginColor:='+ColorToString(MarginColor)+';');
  SL.Add( Prefix + AName + '.MarkLine:='+IntToStr(MarkLine)+';');
  SL.Add( Prefix + AName + '.MaxRightChar:='+IntToStr(MaxRightChar)+';');
  SL.Add( Prefix + AName + '.MaxUndo:='+IntToStr(MaxUndo)+';');

  TMPStr:='';
  if eoAutoIndent in Options then
    TMPStr := TMPStr + 'eoAutoIndent';
  if eoAutoUnindent in Options then
    TMPStr := TMPStr + ', eoAutoUnindent';
  if eoCursorThroughTabs in Options then
    TMPStr := TMPStr + ', eoCursorThroughTabs';
  if eoGroupUndo in Options then
    TMPStr := TMPStr + ', eoGroupUndo';
  if eoHideSelection in Options then
    TMPStr := TMPStr + ', eoHideSelection';
  if eoInserting in Options then
    TMPStr := TMPStr + ', eoInserting';
  if eoKeepTrailingBlanks in Options then
    TMPStr := TMPStr + ', eoKeepTrailingBlanks';
  if eoLineNumbers in Options then
    TMPStr := TMPStr + ', eoLineNumbers';
  if eoOptimalFill in Options then
    TMPStr := TMPStr + ', eoOptimalFill';
  if eoReadOnly in Options then
    TMPStr := TMPStr + ', eoReadOnly';
  if eoReadOnlySelection in Options then
    TMPStr := TMPStr + ', eoReadOnlySelection';
  if eoScrollPastEOL in Options then
    TMPStr := TMPStr + ', eoScrollPastEOL';
  if eoShowControlChars in Options then
    TMPStr := TMPStr + ', eoShowControlChars';
  if eoShowCursorWhileReadOnly in Options then
    TMPStr := TMPStr + ', eoShowCursorWhileReadOnly';
  if eoShowScrollHint in Options then
    TMPStr := TMPStr + ', eoShowScrollHint';
  if eoSmartTabs in Options then
    TMPStr := TMPStr + ', eoSmartTabs';
  if eoTripleClicks in Options then
    TMPStr := TMPStr + ', eoTripleClicks';
  if eoUndoAfterSave in Options then
    TMPStr := TMPStr + ', eoUndoAfterSave';
  if eoUseTabs in Options then
    TMPStr := TMPStr + ', eoUseTabs';
  if eoUseSyntaxHighlighting in Options then
    TMPStr := TMPStr + ', eoUseSyntaxHighlighting';
  if eoWantTabs in Options then
    TMPStr := TMPStr + ', eoWantTabs';
  if TMPStr <> '' then
    if TMPStr[ 1 ] = ',' then
      TMPStr := Copy( TMPStr, 3, MaxInt );
  SL.Add( Prefix + AName + '.Options:=['+TMPStr+'];');
  SL.Add( Prefix + AName + '.OverwriteCaret:='+OverwriteCaretToStr[OverwriteCaret]+';');
  SL.Add( Prefix + AName + '.RightMargin:='+IntToStr(RightMargin)+';');
  SL.Add( Prefix + AName + '.InsertCaret:='+OverwriteCaretToStr[InsertCaret]+';');
  SL.Add( Prefix + AName + '.ScrollBarMode:='+ScrollBarModeToStr[ScrollBarMode]+';');
  SL.Add( Prefix + AName + '.ScrollBars:='+ScrollBarsToStr[ScrollBars]+';');
  SL.Add( Prefix + AName + '.CharWidth:='+IntToStr(CharWidth)+';');
  SL.Add( Prefix + AName + '.IndentSize:='+IntToStr(IndentSize)+';');
  SL.Add( Prefix + AName + '.ExtraLineSpacing:='+IntToStr(ExtraLineSpacing)+';');
  MarkColor.GenerateCode(SL, Prefix + AName, 'MarkColor');
  ScrollHintColor.GenerateCode(SL, Prefix + AName, 'ScrollHintColor');
  SelectedColor.GenerateCode(SL, Prefix + AName, 'SelectedColor');
  { TODO -oGandalf -cCompatible : RunTimeFont }
//  BFont := RunTimeFont;
  if not Font.Equal2( BFont ) then
    LineNumberFont.GenerateCode(SL, Prefix + AName,'LineNumberFont', BFont);
  SL.Add( Prefix + AName + '.TabSize:='+IntToStr(TabSize)+';');
  BookMarkOptions.GenerateCode(SL, Prefix + AName, 'BookMarkOptions');
end;

function TKOLVMHSyntaxEdit.SetupParams(const AName,AParent : String) : String;
begin
  Result := AParent;
end;

procedure TKOLVMHSyntaxEdit.SetupLast(SL: TStringList; const AName, AParent, Prefix: String);
begin
  if HighLighter<>nil then
    SL.Add( Prefix + AName + '.HighLighter:=Result.'+HighLighter.Name+';');
  if BookmarksIL<>nil then
    SL.Add( Prefix + AName + '.BookmarksIL:=Result.'+BookmarksIL.Name+';');
end;

procedure TKOLVMHSyntaxEdit.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName,['OnCaretChange','OnBookmark','OnProcessCommand',
  'OnProcessUserCommand','OnReplaceText','OnSettingChange','OnChange'],[@OnCaretChange,
  @OnBookmark,@OnProcessCommand,@OnProcessUserCommand,@OnReplaceText,
  @OnSettingChange,@OnChange]);

end;

procedure TKOLVMHSyntaxEdit.SetGutterColor(const Value:TColor);
begin
  FGutterColor:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetGutterWidth(const Value:Integer);
begin
  FGutterWidth:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetMarginColor(const Value:TColor);
begin
  FMarginColor:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetMarkLine(const Value:Integer);
begin
  FMarkLine:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetMaxRightChar(const Value:Integer);
begin
  FMaxRightChar:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetMaxUndo(const Value:Integer);
begin
  FMaxUndo:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetOptions(const Value:TSyntaxEditOptions);
begin
  FOptions:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetOverwriteCaret(const Value:TCaretType);
begin
  FOverwriteCaret:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetRightMargin(const Value:Integer);
begin
  FRightMargin:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetInsertCaret(const Value:TCaretType);
begin
  FInsertCaret:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetScrollBarMode(const Value:TScrollBarMode);
begin
  FScrollBarMode:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetScrollBars(const Value:TScrollStyle);
begin
  FScrollBars:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetCharWidth(const Value:Integer);
begin
  FCharWidth:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetIndentSize(const Value:Cardinal);
begin
  FIndentSize:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetExtraLineSpacing(const Value:Integer);
begin
  FExtraLineSpacing:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetMarkColor(const Value:TColors);
begin
  FMarkColor:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetScrollHintColor(const Value:TColors);
begin
  FScrollHintColor:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetSelectedColor(const Value:TColors);
begin
  FSelectedColor:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetLineNumberFont(const Value:TKOLFontEx);
begin
  FLineNumberFont:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetOnCaretChange(const Value:TCaretEvent);
begin
  FOnCaretChange:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetOnBookmark(const Value:TBookmarkEvent);
begin
  FOnBookmark:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetOnProcessCommand(const Value:TProcessCommandEvent);
begin
  FOnProcessCommand:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetOnProcessUserCommand(const Value:TProcessCommandEvent);
begin
  FOnProcessUserCommand:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetOnReplaceText(const Value:TReplaceTextEvent);
begin
  FOnReplaceText:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetOnSettingChange(const Value:TOnEvent);
begin
  FOnSettingChange:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetOnChange(const Value:TOnEvent);
begin
  FOnChange:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetTabSize(const Value:Integer);
begin
  FTabSize:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetBookmarkOptions(const Value:TBookmarkOptions);
begin
  FBookmarkOptions:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetHighLighter(const Value:TKOLVMHCustomHighlighter);
begin
//  if FHighLighter<>nil then
//    FHighLighter.Owner:=nil;
//  if FHighLighter<>nil then
    FHighLighter:=Value;
//  FHighLighter.Owner:=Self;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetCharAddon(const Value:Integer);
begin
  FCharAddon:=Value;
  Change;
end;

procedure TKOLVMHSyntaxEdit.SetBookmarksIL(const Value:TKOLImageList);
begin
  FBookmarksIL:=Value;
  Change;
end;

procedure Register;
begin
  RegisterComponents('KOL SyntaxEditor', [TKOLVMHSyntaxEdit]);
end;

end.

