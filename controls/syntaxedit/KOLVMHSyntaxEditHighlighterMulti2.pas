{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: SynHighlighterMulti.pas, released 2000-06-23.
The Original Code is based on mwMultiSyn.pas by Willo van der Merwe, part of the
mwEdit component suite.

Contributors to the SynEdit and mwEdit projects are listed in the
Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

$Id: SynHighlighterMulti.pas,v 1.17 2002/03/18 07:52:18 plpolak Exp $

You may retrieve the latest version of this file at the SynEdit home page,
located at http://SynEdit.SourceForge.net

Known Issues:
-------------------------------------------------------------------------------}
{
@abstract(Provides a Multiple-highlighter syntax highlighter for SynEdit)
@author(Willo van der Merwe <willo@wack.co.za>, converted to SynEdit by David Muir <dhm@dmsoftware.co.uk>)
@created(1999, converted to SynEdit 2000-06-23)
@lastmod(2000-06-23)
The SynHighlighterMulti unit provides SynEdit with a multiple-highlighter syntax highlighter.
This highlighter can be used to highlight text in which several languages are present, such as HTML.
For example, in HTML as well as HTML tags there can also be JavaScript and/or VBScript present.
}
unit KOLVMHSyntaxEditHighlighterMulti2;

interface

uses
  KOLVMHSyntaxEditTypes,
  KOLVMHSyntaxEditHighlighter,
  KOLVMHSyntaxRegExpr, kol, err;

type
  TOnCheckMarker=procedure(Sender: TObject; var StartPos, MarkerLen: Integer; var MarkerText: String) of object;

  PgmSchemes = ^TgmSchemes;

  PgmScheme = ^TgmScheme;
  TgmScheme = object(TObj)
  private
    fCollection: PgmSchemes;
    fEndExpr: string;
    fStartExpr: string;
    fHighlighter: PVMHCustomHighLighter;
    fMarkerAttri: PHighlighterAttributes;
    fSchemeName: string;
    fCaseSensitive: Boolean;
    fOnCheckStartMarker: TOnCheckMarker;
    fOnCheckEndMarker: TOnCheckMarker;
    function ConvertExpression(const Value: string): string;
    procedure MarkerAttriChanged(Sender: PObj);
    procedure SetMarkerAttri(const Value: PHighlighterAttributes);
    procedure SetHighlighter(const Value: PVMHCustomHighlighter);
    procedure SetEndExpr(const Value: string);
    procedure SetStartExpr(const Value: string);
    procedure SetCaseSensitive(const Value: Boolean);
    function GetIndex: Integer;
  protected
    procedure Changed(AllItems: Boolean);
    function GetDisplayName: String; virtual;
    procedure SetDisplayName(const Value: String); virtual;
  public
    destructor Destroy; virtual;
  //published
    property Index: Integer read GetIndex;
    property CaseSensitive: Boolean read fCaseSensitive write SetCaseSensitive default True;
    property StartExpr: string read fStartExpr write SetStartExpr;
    property EndExpr: string read fEndExpr write SetEndExpr;
    property Highlighter: PVMHCustomHighlighter read fHighlighter write SetHighlighter;
    property MarkerAttri: PHighlighterAttributes read fMarkerAttri write SetMarkerAttri;
    property SchemeName: String read fSchemeName write fSchemeName;
    property OnCheckStartMarker: TOnCheckMarker read fOnCheckStartMarker write fOnCheckStartMarker;
    property OnCheckEndMarker: TOnCheckMarker read fOnCheckEndMarker write fOnCheckEndMarker;
  end;

  PVMHMultiHighlighter = ^TVMHMultiHighlighter;

  TgmSchemes = object(TObj)
  private
    fList: PList;
    fOwner: PVMHMultiHighlighter;
    function GetItems(Index: integer): PgmScheme;
    procedure SetItems(Index: integer; const Value: PgmScheme);
    function GetCount: Integer;
  protected
    function GetOwner: PVMHMultiHighlighter; virtual;
    procedure Update(Item: PgmScheme); virtual;
    destructor Destroy; virtual;
  public
    //procedure AddItem(Item: PgmScheme);
    property Count: Integer read GetCount;
    property Items[aIndex: integer]: PgmScheme read GetItems write SetItems; default;
  end;

  PgmMarker = ^TgmMarker;
  TgmMarker = record
    fScheme: integer;
    fStartPos: integer;
    fMarkerLen: integer;
    fMarkerText: string;
    fIsOpenMarker: boolean;
  end;

  TVMHMultiHighlighter = object(TVMHCustomHighLighter)
  private
    fDefaultLanguageName: String;
    fMarkers: PList;
    fMarker: PgmMarker;
    fNextMarker: integer;
    fCurrScheme: integer;
    fTmpLine: String; {there're lots of highlighters not doing reference count...}
    fTmpRange: pointer; {only works inside a single line for now}
    procedure SetDefaultHighlighter(const Value: PVMHCustomHighLighter);
    function GetMarkers(aIndex: integer): PgmMarker;
    property Markers[aIndex: integer]: PgmMarker read GetMarkers;
    procedure DoCheckMarker(Scheme:PgmScheme; StartPos, MarkerLen: Integer;
			const MarkerText: String; Start: Boolean);
  protected
    fSchemes: PgmSchemes;
    fDefaultHighlighter: PVMHCustomHighLighter;
    fLine: string;
    fLineNumber: Integer;
    fTokenPos: integer;
    fRun: Integer;
    fSampleSource: string;
    procedure SetSchemes(const Value: PgmSchemes);
    procedure ClearMarkers;
    function GetIdentChars: TSynIdentChars; virtual;
    function GetDefaultAttribute(Index: integer): PHighlighterAttributes; virtual;
    function GetAttribCount: integer; virtual;
    function GetAttribute(idx: integer): PHighlighterAttributes; virtual;
    procedure HookHighlighter(aHL: PVMHCustomHighlighter);
    procedure UnhookHighlighter(aHL: PVMHCustomHighlighter);
    //procedure Notification(aComp: TComponent; aOp: TOperation); virtual;
    function GetSampleSource: string; virtual;
    procedure SetSampleSource(Value: string); virtual;
  public
    function GetLanguageName: string; virtual;
  public
    destructor Destroy; virtual;
    function GetEol: Boolean; virtual;
    function GetRange: Pointer; virtual;
    function GetToken: string; virtual;
    function GetTokenAttribute: PHighlighterAttributes; virtual;
    function GetTokenKind: integer; virtual;
    function GetTokenPos: Integer; virtual;
    procedure Next; virtual;
    procedure SetLine(NewValue: string; LineNumber: Integer); virtual;
    procedure SetRange(Value: Pointer); virtual;
    procedure ResetRange; virtual;
    property CurrScheme: integer read fCurrScheme write fCurrScheme;
  //published
    property Schemes: PgmSchemes read fSchemes write SetSchemes;
    property DefaultHighlighter: PVMHCustomHighLighter read fDefaultHighlighter
      write SetDefaultHighlighter;
    property DefaultLanguageName: String read fDefaultLanguageName
      write fDefaultLanguageName;
  end;

// Constructors
  function NewgmMarker(aScheme, aStartPos,
    aMarkerLen: integer; aIsOpenMarker: boolean; const aMarkerText: string): PgmMarker;
  function NewgmSchemes(aOwner: PVMHMultiHighlighter): PgmSchemes;
  function NewgmScheme(Collection: PgmSchemes): PgmScheme;
  function NewVMHMultiHighlighter: PVMHMultiHighlighter;
const
  MaxNestedMultiSyn = 4;

implementation

uses
  KOLVMHSyntaxEditMiscProcs,
  KOLVMHSyntaxEditStrConst;

const
  { number of bits of the Range that will be used to store the SchemeIndex }
  SchemeIndexSize = 5;
  MaxSchemeCount = (1 shl SchemeIndexSize) -1;
  { number of bits of the Range that will be used to store the SchemeRange }
  SchemeRangeSize = 12;
  MaxSchemeRange = (1 shl SchemeRangeSize) -1;

{ TgmMarker }

function NewgmMarker(aScheme, aStartPos,
  aMarkerLen: integer; aIsOpenMarker: boolean; const aMarkerText: string): PgmMarker;
begin
  New(Result);
  Result.fScheme := aScheme;
  Result.fStartPos := aStartPos;
  Result.fMarkerLen := aMarkerLen;
  Result.fIsOpenMarker := aIsOpenMarker;
  Result.fMarkerText := aMarkerText;
end;

{ TVMHMultiHighlighter }

procedure TVMHMultiHighlighter.ClearMarkers;
const
  { if the compiler stops here, something is wrong with the constants above }
  { there is no special reason for this to be here. the constant must be
  declared locally to avoid a compiler hint - or else Delphi shows a hint -, and
  so this function was randomly chosen }
  RangeInfoSize: byte = ( SizeOf(pointer) * 8 ) -
    ( (MaxNestedMultiSyn * SchemeIndexSize) + SchemeRangeSize );
var
  i: integer;
begin
  for i := 0 to fMarkers.Count - 1 do
    PObj(fMarkers.Items[i]).Free;
  fMarkers.Clear;
end;

function NewVMHMultiHighlighter: PVMHMultiHighlighter;
begin
  New(Result, Create);
  Result.fWordBreakChars := TSynWordBreakChars;
  Result.fAttributes := NewStrListEx;
  Result.fDefaultFilter := '';
  Result.fEnabled := True;
  Result.fSchemes := NewgmSchemes(Result);
  Result.fCurrScheme := -1;
  Result.fMarkers := NewList;
end;

destructor TVMHMultiHighlighter.Destroy;
begin
  fSchemes.Free;
  ClearMarkers;
  fMarkers.Free;
  { unhook notification handlers }
  DefaultHighlighter := nil;
  inherited Destroy;
end;

function TVMHMultiHighlighter.GetAttribCount: integer;
begin
  Result := inherited GetAttribCount + Schemes.Count;
end;

function TVMHMultiHighlighter.GetAttribute(
  idx: integer): PHighlighterAttributes;
begin
  if idx < Schemes.Count then
    Result := Schemes.Items[idx].MarkerAttri
  else
    Result := inherited GetAttribute( idx + Schemes.Count );
end;

function TVMHMultiHighlighter.GetDefaultAttribute(Index: integer): PHighlighterAttributes;
var
  iHL: PVMHCustomHighlighter;
begin
  if (CurrScheme >= 0) and (Schemes.Items[CurrScheme].Highlighter <> nil) then
    iHL := Schemes.Items[CurrScheme].Highlighter
  else
    iHL := DefaultHighlighter;
  { the typecast to TVMHMultiHighlighter is only necessary because the
  GetDefaultAttribute method is protected.
  And don't worry: this really works }
  if iHL <> nil then begin
    Result := PVMHMultiHighlighter(iHL).GetDefaultAttribute(Index)
  end else
    Result := nil;
end;

function TVMHMultiHighlighter.GetEol: Boolean;
begin
  if fMarker <> nil then
    Result := False
  else if fCurrScheme >= 0 then
    Result := Schemes.Items[CurrScheme].Highlighter.GetEol
  else if DefaultHighlighter <> nil then
    Result := DefaultHighlighter.GetEol
  else
    Result := fRun > Length(fLine) + 2;
end;

function TVMHMultiHighlighter.GetIdentChars: TSynIdentChars;
begin
  if CurrScheme >= 0 then
    Result := Schemes.Items[CurrScheme].Highlighter.IdentChars
  else if DefaultHighlighter <> nil then
    Result := DefaultHighlighter.IdentChars
  else
    Result := inherited GetIdentChars;
end;

function TVMHMultiHighlighter.GetLanguageName: string;
begin
  Result := SYNS_LangGeneralMulti;
end;

function TVMHMultiHighlighter.GetMarkers(aIndex: integer): PgmMarker;
begin
  Result := fMarkers.Items[aIndex];
end;

function TVMHMultiHighlighter.GetRange: Pointer;
var
  iHL: PVMHCustomHighlighter;
  iSchemeIndex: cardinal;
  iSchemeRange: cardinal;
begin
  if (fCurrScheme < 0) then
    iHL := DefaultHighlighter
  else
    iHL := Schemes.Items[fCurrScheme].Highlighter;
  iSchemeIndex := fCurrScheme +2;
  Assert( iSchemeIndex <= MaxSchemeCount );
  if iHL <> nil then begin
    iSchemeRange := cardinal( iHL.GetRange );
    Assert( (iSchemeRange <= MaxSchemeRange) or (iHL.GetLanguageName = SYNS_LangGeneralMulti) );
  end else
    iSchemeRange := 0;
  { checks the limit of nested MultiSyns }
  Assert( iSchemeRange shr ((MaxNestedMultiSyn -1)*SchemeIndexSize + SchemeRangeSize) = 0 );
  iSchemeRange := (iSchemeRange shl SchemeIndexSize) or iSchemeIndex;
  Result := pointer(iSchemeRange);
end;

function TVMHMultiHighlighter.GetToken: string;
begin
  if DefaultHighlighter = nil then
    Result := fLine
  else
    Result := Copy( fLine, fTokenPos +1, fRun - fTokenPos -1)
end;

function TVMHMultiHighlighter.GetTokenAttribute: PHighlighterAttributes;
begin
  if fMarker <> nil then
    Result := Schemes.Items[fMarker.fScheme].MarkerAttri
  else if CurrScheme >= 0 then
    Result := Schemes.Items[CurrScheme].Highlighter.GetTokenAttribute
  else if DefaultHighlighter <> nil then
    Result := DefaultHighlighter.GetTokenAttribute
  else
    Result := nil;
end;

function TVMHMultiHighlighter.GetTokenKind: integer;
begin
  if fMarker <> nil then
    Result := 0
  else if fCurrScheme >= 0 then
    Result := Schemes.Items[fCurrScheme].Highlighter.GetTokenKind
  else if DefaultHighlighter <> nil then
    Result := DefaultHighlighter.GetTokenKind
  else
    Result := 0;
end;

function TVMHMultiHighlighter.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

procedure TVMHMultiHighlighter.HookHighlighter(aHL: PVMHCustomHighlighter);
begin
  //aHL.FreeNotification( Self );
  aHL.HookAttrChangeEvent( DefHighlightChange );
end;

procedure TVMHMultiHighlighter.Next;

  function FindMarker: PgmMarker;
  var
    c: integer;
  begin
    for c := 0 to fMarkers.Count -1 do
      if Markers[c].fStartPos >= fRun then
      begin
        Result := Markers[c];
        Exit;
      end;
    Result := nil;
  end;

var
  iToken: String;
  iHL: PVMHCustomHighlighter;
begin
  if DefaultHighlighter = nil then begin
    if fRun > 1 then
      Inc( fRun )
    else
      fRun := Length(fLine) + 2;
    Exit;
  end;

  if (fNextMarker < fMarkers.Count) and (fRun >= Markers[fNextMarker].fStartPos) then begin
    fMarker := Markers[ fNextMarker ];
    Inc( fNextMarker );
    fTokenPos := fRun -1;
    Inc( fRun, fMarker.fMarkerLen );
    Exit;
  end;
  if (fRun = 1) then begin
    if fMarkers.Count = 0 then
      fTmpLine := fLine
    else
      fTmpLine := Copy( fLine, 1, Markers[fNextMarker].fStartPos -1 );
    if CurrScheme >= 0 then
      iHL := Schemes.Items[CurrScheme].Highlighter
    else
      iHL := DefaultHighlighter;
    iHL.SetLine( fTmpLine, fLineNumber );
  end else if fMarker <> nil then begin
    if fMarker.fIsOpenMarker then begin
      fTmpRange := DefaultHighlighter.GetRange;
      fCurrScheme := fMarker.fScheme;
      Schemes.Items[CurrScheme].Highlighter.ResetRange;  //GBN 31/01/2002 - >From Flavio
    end else begin
      fCurrScheme := -1;
      DefaultHighlighter.SetRange( fTmpRange );
    end;
    fMarker := nil;
    {}
    if fNextMarker < fMarkers.Count then
      fTmpLine := Copy( fLine, fRun, Markers[fNextMarker].fStartPos - fRun  )
    else
      fTmpLine := Copy( fLine, fRun, MaxInt );
    if CurrScheme >= 0 then
      iHL := Schemes.Items[CurrScheme].Highlighter
    else
      iHL := DefaultHighlighter;
    iHL.SetLine( fTmpLine, fLineNumber );
  end else begin
    if CurrScheme >= 0 then
      iHL := Schemes.Items[CurrScheme].Highlighter
    else
      iHL := DefaultHighlighter;
    iHL.Next;
  end;

  fTokenPos := iHL.GetTokenPos;
  iToken := iHL.GetToken;
  if fNextMarker > 0 then begin
    with Markers[ fNextMarker -1 ]^ do
      Inc( fTokenPos, fStartPos + fMarkerLen -1 );
  end;
  Inc( fRun, (fTokenPos - fRun +1) + Length(iToken) );
end;

{procedure TVMHMultiHighlighter.Notification(aComp: TComponent; aOp: TOperation);
var
  cScheme: integer;
begin
  inherited;
  if (aOp = opRemove) and (csDestroying in aComp.ComponentState) and
    (aComp is TSynCustomHighlighter)
  then begin
    if DefaultHighlighter = aComp then
      DefaultHighlighter := nil;
    for cScheme := 0 to Schemes.Count -1 do
      if Schemes[ cScheme ].Highlighter = aComp then
        Schemes[ cScheme ].Highlighter := nil;
  end;
end;}

procedure TVMHMultiHighlighter.ResetRange;
begin
  fCurrScheme := -1;
  fTmpRange := nil;
  //GBN 31/02/2002 - From Flavio
  DefaultHighlighter.ResetRange;
end;

procedure TVMHMultiHighlighter.SetDefaultHighlighter(
  const Value: PVMHCustomHighLighter);
const
  sDefaultHlSetToSelf = 'It is not good to set the DefaultHighlighter '+
    'of a SynMultiSyn to the SynMultiSyn itself. Please do not try this again';
begin
  if DefaultHighlighter <> Value then begin
    if Value = @Self then
      Exception.Create(e_Custom, sDefaultHlSetToSelf);
    if DefaultHighlighter <> nil then
      UnhookHighlighter( DefaultHighlighter );
    fDefaultHighlighter := Value;
    {if DefaultHighlighter <> nil then
      HookHighlighter( DefaultHighlighter );}
    { yes, it's necessary }
    DefHighlightChange( @Self );
  end;
end;

//GBN 31/01/2002 - Start
procedure TVMHMultiHighlighter.DoCheckMarker(Scheme:PgmScheme; StartPos, MarkerLen: Integer; const MarkerText: String; Start: Boolean);
var
  aStartPos: Integer;
  aMarkerLen: Integer;
  aMarkerText: String;
begin
  aStartPos:=StartPos;
  aMarkerLen:=MarkerLen;
  aMarkerText:=MarkerText;
  if (Start) and Assigned(Scheme.OnCheckStartMarker) then
    Scheme.OnCheckStartMarker(@Self,aStartPos,aMarkerLen,aMarkerText)
  else if (not Start) and Assigned(Scheme.OnCheckEndMarker) then
    Scheme.OnCheckEndMarker(@Self,aStartPos,aMarkerLen,aMarkerText);
  if (aMarkerText<>'') and (aMarkerLen>0) then
    begin
    fMarkers.Add(NewgmMarker(Scheme.Index, aStartPos, aMarkerLen,Start,aMarkerText));
    end;
end;
//GBN 31/01/2002 - End

procedure TVMHMultiHighlighter.SetLine(NewValue: string; LineNumber: Integer);
var
  iParser: PRegExpr;
  iScheme: PgmScheme;
  iExpr: String;
  iLine: String;
  iEaten: integer;
  cScheme: integer;
begin
  ClearMarkers;

  iParser := NewRegExpr;
  try
    iEaten := 0;
    iLine := NewValue;
    if CurrScheme >= 0
    then
      iScheme := fSchemes.Items [ CurrScheme ]
    else
      iScheme := nil;
    while iLine <> '' do
      if iScheme <> nil then begin
        iParser.Expression := iScheme.ConvertExpression( iScheme.EndExpr );
        if iParser.Exec( iScheme.ConvertExpression( iLine ) ) then begin
          iExpr := Copy( NewValue, iParser.MatchPos[0] + iEaten, iParser.MatchLen[0] );
          //GBN 31/01/2002 - Start
          DoCheckMarker(iScheme, iParser.MatchPos[0] + iEaten, iParser.MatchLen[0],iExpr,False);
          //fMarkers.Add( TgmMarker.Create( iScheme.Index, iParser.MatchPos[0] + iEaten,
          //  iParser.MatchLen[0], False, iExpr ) );
          //GBN 31/01/2002 - End
          Delete( iLine, 1, iParser.MatchPos[0] -1 + iParser.MatchLen[0] );
          Inc( iEaten, iParser.MatchPos[0] -1 + iParser.MatchLen[0] );
          iScheme := nil;
        end else
          break;
      end else begin
        for cScheme := 0 to Schemes.Count -1 do begin
          iScheme := Schemes.Items [ cScheme ];
          if (iScheme.StartExpr = '') or (iScheme.EndExpr = '') or
            (iScheme.Highlighter = nil) or (not iScheme.Highlighter.Enabled) then
          begin
            continue;
          end;
          iParser.Expression := iScheme.ConvertExpression( iScheme.StartExpr );
          if iParser.Exec( iScheme.ConvertExpression( iLine ) ) then begin
            iExpr := Copy( NewValue, iParser.MatchPos[0] + iEaten, iParser.MatchLen[0] );
            //GBN 31/01/2002 - Start
            DoCheckMarker(iScheme, iParser.MatchPos[0] + iEaten, iParser.MatchLen[0],iExpr,True);
            //fMarkers.Add( TgmMarker.Create( cScheme, iParser.MatchPos[0] + iEaten,
            //  iParser.MatchLen[0], True, iExpr ) );
            //GBN 31/01/2002 - End
            Delete( iLine, 1, iParser.MatchPos[0] -1 + iParser.MatchLen[0] );
            Inc( iEaten, iParser.MatchPos[0] -1 + iParser.MatchLen[0] );
            break;
          end;
        end; {for}
        if cScheme >= Schemes.Count then
          break;
      end; {else}

  finally
    iParser.Free;
  end;

  if LineNumber <> fLineNumber +1 then
    fTmpRange := nil;
  fLineNumber := LineNumber;
  fLine := NewValue;
  fMarker := nil;
  fRun := 1;
  fTokenPos := 0;
  fNextMarker := 0;
  Next;
end;

procedure TVMHMultiHighlighter.SetRange(Value: Pointer);
var
	iSchemeRange: integer;
begin
	if Value = nil then
		Exit;
	iSchemeRange := integer(Value);
	fCurrScheme := (iSchemeRange and MaxSchemeCount) -2;
	iSchemeRange := iSchemeRange shr SchemeIndexSize;
	if (CurrScheme < 0) then begin
		if DefaultHighlighter <> nil then
			DefaultHighlighter.SetRange( pointer(iSchemeRange) );
	end else begin
		Schemes.Items [CurrScheme].Highlighter.SetRange( pointer(iSchemeRange) );
	end;
end;

procedure TVMHMultiHighlighter.SetSchemes(const Value: PgmSchemes);
begin
	//fSchemes.Assign(Value);
        fSchemes := Value;
end;

procedure TVMHMultiHighlighter.UnhookHighlighter(aHL: PVMHCustomHighlighter);
begin
	aHL.UnhookAttrChangeEvent( DefHighlightChange );
	//aHL.RemoveFreeNotification( Self );
end;

function TVMHMultiHighlighter.GetSampleSource: string;
begin
	Result := fSampleSource;
end;

procedure TVMHMultiHighlighter.SetSampleSource(Value: string);
begin
	fSampleSource := Value;
end;

{ TgmSchemes }

function NewgmSchemes(aOwner: PVMHMultiHighlighter): PgmSchemes;
begin
  New(Result, Create);
  Result.fList := NewList;
  Result.fOwner := aOwner;
end;

destructor TgmSchemes.Destroy;
begin
  fList.Free;
  inherited;
end;

function TgmSchemes.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TgmSchemes.GetItems(Index: integer): PgmScheme;
begin
  Result := fList.Items[Index];
end;

function TgmSchemes.GetOwner: PVMHMultiHighlighter;
begin
  Result := fOwner;
end;

procedure TgmSchemes.SetItems(Index: integer; const Value: PgmScheme);
begin
  fList.Items[Index] := Value;
end;

procedure TgmSchemes.Update(Item: PgmScheme);
begin
  fOwner.DefHighlightChange( Item );
end;

{ TgmScheme }

procedure TgmScheme.Changed(AllItems: Boolean);
var
  Item: PgmScheme;
begin
  if (fCollection <> nil) then
  begin
    if AllItems then Item := nil else Item := @Self;
    FCollection.Update(Item);
  end;
end;

function TgmScheme.ConvertExpression(const Value: String): String;
begin
  if not CaseSensitive then
    Result := AnsiUpperCase(Value)
  else
    Result := Value;
end;

function NewgmScheme(Collection: PgmSchemes): PgmScheme;
begin
  New(Result, Create);
  Collection.fList.Add(Result);
  Result.fCollection := Collection;
  Result.fCaseSensitive := True;
  Result.fMarkerAttri := NewHighlighterAttributes(SYNS_AttrMarker);
  Result.fMarkerAttri.OnChange := Result.MarkerAttriChanged;
  Result.MarkerAttri.Background := clYellow;
  Result.MarkerAttri.Style := [fsBold];
  Result.MarkerAttri.InternalSaveDefaultValues;
end;

destructor TgmScheme.Destroy;
begin
  fMarkerAttri.Free;
  { unhook notification handlers }
  Highlighter := nil;
  inherited Destroy;
end;

function TgmScheme.GetDisplayName: String;
begin
  Result := SchemeName
end;

function TgmScheme.GetIndex: Integer;
begin
  Result := fCollection.fList.IndexOf(@Self);
end;

procedure TgmScheme.MarkerAttriChanged(Sender: PObj);
begin
  Changed( False );
end;

procedure TgmScheme.SetCaseSensitive(const Value: Boolean);
begin
  if fCaseSensitive <> Value then
  begin
    fCaseSensitive := Value;
    Changed( False );
  end;
end;

procedure TgmScheme.SetDisplayName(const Value: String);
begin
  SchemeName := Value;
end;

procedure TgmScheme.SetEndExpr(const Value: string);
var OldValue: String; //GBN 31/01/2002 - From Flavio
begin
  if fEndExpr <> Value then
	begin
    OldValue := fEndExpr; //GBN 31/01/2002 - From Flavio
    fEndExpr := Value;
    //GBN 31/01/2002 - From Flavio
    if ConvertExpression( OldValue ) <> ConvertExpression( Value ) then
      Changed( False );
  end;
end;

procedure TgmScheme.SetHighlighter(const Value: PVMHCustomHighLighter);
var
  iOwner: PVMHMultiHighlighter;
begin
  if Highlighter <> Value then
  begin
    iOwner := fCollection.fOwner;
    if Highlighter <> nil then
      iOwner.UnhookHighlighter( Highlighter );
    fHighlighter := Value;
    {if (Highlighter <> nil) and (Highlighter <> fCollection.fOwner) then
      iOwner.HookHighlighter( Highlighter );}
    Changed(False);
  end;
end;

procedure TgmScheme.SetMarkerAttri(const Value: PHighlighterAttributes);
begin
  fMarkerAttri.Assign(Value);
end;

procedure TgmScheme.SetStartExpr(const Value: string);
var OldValue: String; //GBN 31/01/2002 - From Flavio
begin
  if fStartExpr <> Value then
  begin
    OldValue   := fStartExpr; //GBN 31/01/2002 - From Flavio
    fStartExpr := Value;
    //GBN 31/01/2002 - From Flavio
    if ConvertExpression( Value ) <> ConvertExpression( OldValue ) then
      Changed( False );
  end;
end;

end.

