unit MCKVMHSyntaxEditHighlighter;
//  Дата создания (Create date): 13-сен(aug)-2002
//  Дата коррекции (Last correction Date): 13-сен(sep)-2002
//  Версия (Version): 0.0


interface

{$I KOLDEF.INC}

uses

  Windows, Controls, Classes, SysUtils, mirror, MCKCtrls, Graphics, KOL,
  {$IFDEF _D6orHigher}
    // Delphi 6 Support
    DesignIntf, DesignEditors, DesignConst, Variants
  {$ELSE}
    DsgnIntf
  {$ENDIF};

type
  TKOLVMHCustomHighlighter=class;
  
  THighlighterAttributes = class(TPersistent)
  private
    FBackground: TColor;
    FForeground: TColor;
    FStyle: TFontStyle;
    FOwner: TKOLVMHCustomHighlighter;
    procedure Change;
    procedure SetBackground(Value: TColor);
    procedure SetForeground(Value: TColor);
    procedure SetStyle(Value: TFontStyle);
//  protected
  public
    constructor Create( AOwner: TKOLVMHCustomHighlighter );
    procedure GenerateCode( SL: TStrings; const AName, HighlighterAttributesPName: String);
  published
    property Background: TColor read FBackground write SetBackground;
    property Foreground: TColor read FForeground write SetForeground;
    property Style: TFontStyle read FStyle write SetStyle;
  end;                     

  TKOLVMHCustomHighlighter=class(TKOLObj)
  private
    FDefaultFilter:String;
    FEnabled:Boolean;
    procedure SetDefaultFilter(const Value:String);
    procedure SetEnabled(const Value:Boolean);
  protected
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property DefaultFilter: String read FDefaultFilter write SetDefaultFilter;
    property Enabled:Boolean read FEnabled write SetEnabled;
  end;

procedure Register;

implementation

constructor THighlighterAttributes.Create( AOwner: TKOLVMHCustomHighlighter );
begin
  inherited Create;
  FOwner:=AOwner;
end;

procedure THighlighterAttributes.Change;
begin
  FOwner.Change;
end;

procedure THighlighterAttributes.SetBackground(Value: TColor);
begin
  FBackground:=Value;
  Change;
end;

procedure THighlighterAttributes.SetForeground(Value: TColor);
begin
  FForeground:=Value;
  Change;
end;

procedure THighlighterAttributes.SetStyle(Value: TFontStyle);
begin
  FStyle:=Value;
  Change;
end;

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

procedure THighlighterAttributes.GenerateCode( SL: TStrings; const AName, HighlighterAttributesPName: String);
const
  Boolean2Str:array [Boolean] of String=('False','True');
  FontStyleFlags: array [TFontStyles] of String=('fsBold', 'fsItalic', 'fsUnderline', 'fsStrikeOut');

  procedure AddLine( const S: String );
  begin
    SL.Add( '  ' + AName + '.' + HighlighterAttributesPName + '.' + S + ';' );
  end;

begin
  AddLine('Background:='+ColorToString(Background));
  AddLine('Foreground:='+ColorToString(Foreground));
  AddLine('Style:='+Flags2Str(@Style,FontStyleFlags));

  {TMPStr:='';
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
      TMPStr := Copy( TMPStr, 3, MaxInt );}

//    property Style: TFontStyle read FStyle write SetStyle;
end;

constructor TKOLVMHCustomHighlighter.Create(AOwner: TComponent);
begin
  inherited;
  // Set Default Values
  FEnabled:=True;
end;

procedure TKOLVMHCustomHighlighter.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
const
  Boolean2Str:array [Boolean] of String=('False','True');
begin
  // Use it only in OOP for Parent none itself!
  // None New* Because!
  SL.Add( Prefix + AName + '.DefaultFilter:='+String2PascalStrExpr(FDefaultFilter)+';');
  SL.Add( Prefix + AName + '.Enabled:='+Boolean2Str[FEnabled]+';');
end;

procedure TKOLVMHCustomHighlighter.SetDefaultFilter(const Value:String);
begin
  FDefaultFilter:=Value;
  Change;
end;

procedure TKOLVMHCustomHighlighter.SetEnabled(const Value:Boolean);
begin
  FEnabled:=Value;
  Change;
end;

procedure Register;
begin
{ TODO -oGandalf -cCompatible D7 : Property Bug }
//  RegisterPropertyEditor(TypeInfo(TColor),THighlighterAttributes,'Background',TColorProperty);
//  RegisterPropertyEditor(TypeInfo(TColor),THighlighterAttributes,'Foreground',TColorProperty);
end;


end.

