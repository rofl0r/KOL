unit KOLVMHEditorKeyCommands;

// (c) 1999, 2000 by Dipl. Ing. Mike Lischke (public@lischke-online.de)
//
//----------------------------------------------------------------------------------------------------------------------
// Support functions and declarations for TSyntaxEdit.
// This unit is a slightly changed version of the same named unit in mwEdit

interface

uses
  Windows, kol, err, Consts;

const
  //--------------------------------------------------------------------------------
  // NOTE:  If you add an editor command, you must also update the
  //        EditorCommandStrs constant array in implementation section below, or the
  //        command will not show up in the IDE.
  //--------------------------------------------------------------------------------

  // "Editor Commands".  Key strokes are translated from a table into these.
  // I used constants instead of a set so that additional commands could be
  // added in descendants (you can't extend a set)
  ecNone            = 0;    // Nothing.  Useful for user event to handle command

  ecLeft            = 1;    // Move cursor left one char
  ecRight           = 2;    // Move cursor right one char
  ecUp              = 3;    // Move cursor up one line
  ecDown            = 4;    // Move cursor down one line
  ecWordLeft        = 5;    // Move cursor left one Word
  ecWordRight       = 6;    // Move cursor right one Word
  ecLineStart       = 7;    // Move cursor to beginning of line
  ecLineEnd         = 8;    // Move cursor to end of line
  ecPageUp          = 9;    // Move cursor up one page
  ecPageDown        = 10;   // Move cursor down one page
  ecPageLeft        = 11;   // Move cursor right one page
  ecPageRight       = 12;   // Move cursor left one page
  ecPageTop         = 13;   // Move cursor to top of page
  ecPageBottom      = 14;   // Move cursor to bottom of page
  ecEditorTop       = 15;   // Move cursor to absolute beginning
  ecEditorBottom    = 16;   // Move cursor to absolute end
  ecGotoXY          = 17;   // Move cursor to specific coordinates, Data = PPoint

  ecSelection       = 100;  // Add this to ecXXX command to get equivalent
                            // command, but with selection enabled. This is not
                            // a command itself.
  // Same as commands above, except they affect selection, too
  ecSelLeft         = ecLeft + ecSelection;
  ecSelRight        = ecRight + ecSelection;
  ecSelUp           = ecUp + ecSelection;
  ecSelDown         = ecDown + ecSelection;
  ecSelWordLeft     = ecWordLeft + ecSelection;
  ecSelWordRight    = ecWordRight + ecSelection;
  ecSelLineStart    = ecLineStart + ecSelection;
  ecSelLineEnd      = ecLineEnd + ecSelection;
  ecSelPageUp       = ecPageUp + ecSelection;
  ecSelPageDown     = ecPageDown + ecSelection;
  ecSelPageLeft     = ecPageLeft + ecSelection;
  ecSelPageRight    = ecPageRight + ecSelection;
  ecSelPageTop      = ecPageTop + ecSelection;
  ecSelPageBottom   = ecPageBottom + ecSelection;
  ecSelEditorTop    = ecEditorTop + ecSelection;
  ecSelEditorBottom = ecEditorBottom + ecSelection;
  ecSelGotoXY       = ecGotoXY + ecSelection;  // Data = PPoint

  ecSelectAll       = 199;  // Select entire contents of editor, cursor to end

  ecDeleteLastChar  = 401;  // Delete last char (i.e. backspace key)
  ecDeleteChar      = 402;  // Delete char at cursor (i.e. delete key)
  ecDeleteWord      = 403;  // Delete from cursor to end of Word
  ecDeleteLastWord  = 404;  // Delete from cursor to start of Word
  ecDeleteBOL       = 405;  // Delete from cursor to beginning of line
  ecDeleteEOL       = 406;  // Delete from cursor to end of line
  ecDeleteLine      = 407;  // Delete current line
  ecClearAll        = 408;  // Delete everything
  ecLineBreak       = 409;  // Break line at current position, move caret to new line
  ecInsertLine      = 410;  // Break line at current position, leave caret
  ecChar            = 411;  // Insert a character at current position

  ecUndo            = 601;  // Perform undo if available
  ecRedo            = 602;  // Perform redo if available
  ecCut             = 603;  // Cut selection to clipboard
  ecCopy            = 604;  // Copy selection to clipboard
  ecPaste           = 605;  // Paste clipboard to current position
  ecScrollUp        = 606;  // Scroll up one line leaving cursor position unchanged.
  ecScrollDown      = 607;  // Scroll down one line leaving cursor position unchanged.
  ecScrollLeft      = 608;  // Scroll left one char leaving cursor position unchanged.
  ecScrollRight     = 609;  // Scroll right one char leaving cursor position unchanged.
  ecInsertMode      = 610;  // Set insert mode
  ecOverwriteMode   = 611;  // Set overwrite mode
  ecToggleMode      = 612;  // Toggle ins/ovr mode
  ecBlockIndent     = 613;  // Indent selection
  ecBlockUnindent   = 614;  // Unindent selection
  ecDelete          = 615;  // like ecCut but without replacing contents of clipboard

  ecGotoMarker0     = 701;  // Goto marker
  ecGotoMarker1     = 702;  // Goto marker
  ecGotoMarker2     = 703;  // Goto marker
  ecGotoMarker3     = 704;  // Goto marker
  ecGotoMarker4     = 705;  // Goto marker
  ecGotoMarker5     = 706;  // Goto marker
  ecGotoMarker6     = 707;  // Goto marker
  ecGotoMarker7     = 708;  // Goto marker
  ecGotoMarker8     = 709;  // Goto marker
  ecGotoMarker9     = 710;  // Goto marker
  ecToggleMarker0   = 751;  // Set marker, Data = PPoint - X, Y Pos
  ecToggleMarker1   = 752;  // Set marker, Data = PPoint - X, Y Pos
  ecToggleMarker2   = 753;  // Set marker, Data = PPoint - X, Y Pos
  ecToggleMarker3   = 754;  // Set marker, Data = PPoint - X, Y Pos
  ecToggleMarker4   = 755;  // Set marker, Data = PPoint - X, Y Pos
  ecToggleMarker5   = 756;  // Set marker, Data = PPoint - X, Y Pos
  ecToggleMarker6   = 757;  // Set marker, Data = PPoint - X, Y Pos
  ecToggleMarker7   = 758;  // Set marker, Data = PPoint - X, Y Pos
  ecToggleMarker8   = 759;  // Set marker, Data = PPoint - X, Y Pos
  ecToggleMarker9   = 760;  // Set marker, Data = PPoint - X, Y Pos

  ecUserFirst       = 1001; // Start of user-defined commands

type
  TMenuKeyCap = (mkcBkSp, mkcTab, mkcEsc, mkcEnter, mkcSpace, mkcPgUp,
    mkcPgDn, mkcEnd, mkcHome, mkcLeft, mkcUp, mkcRight, mkcDown, mkcIns,
    mkcDel, mkcShift, mkcCtrl, mkcAlt);
  WordRec = packed record
  case Integer of
      0: (Lo, Hi: Byte);
      1: (Bytes: array [0..1] of Byte);
  end;
  TGetStrProc = procedure(const S: string) of object;
  TIdentMapEntry = record
    Value: Integer;
    Name: String;
  end;
  TShiftState = set of (ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble);
  TShortCut = Low(Word) .. High(Word);
  TEditorCommand = type Word;

  PKeyStrokes = ^TKeyStrokes;

  PKeyStroke = ^TKeyStroke;
  TKeyStroke = object(TObj)
  private
    FKey: Word;          // virtual keycode
    FShift: TShiftState;
    FCommand: TEditorCommand;
    FKeyStrokes: PKeyStrokes;
    FDisplayName : string;
    procedure SetKey(const Value: Word);
    procedure SetShift(const Value: TShiftState);
    function GetShortCut: TShortCut;
    procedure SetShortCut(const Value: TShortCut);
    procedure SetCommand(const Value: TEditorCommand);
  protected
    function GetDisplayName: String;
  public
    //procedure Assign(Source: TPersistent); override;

    // No duplicate checking is done if assignment made via these properties!
    property Key: Word read FKey write SetKey;
    property Shift: TShiftState read FShift write SetShift;
    property ShortCut: TShortCut read GetShortCut write SetShortCut;
    property Command: TEditorCommand read FCommand write SetCommand;
  end;

  TKeyStrokes = object(TObj)
  private
    FList: PList;
    function GetItem(Index: Integer): PKeyStroke;
    procedure SetItem(Index: Integer; Value: PKeyStroke);
  public
    destructor Destroy; virtual;
    function Add: PKeyStroke;
    //procedure Assign(Source: TPersistent); override;
    function FindCommand(Cmd: TEditorCommand): Integer;
    function FindShortcut(SC: TShortcut): Integer;
    function FindKeycode(Code: Word; SS: TShiftState): Integer;
    procedure ResetDefaults;                                                   
    procedure Clear;
    property Items[Index: Integer]: PKeyStroke read GetItem write SetItem; default;
  end;

  function NewKeyStrokes : PKeyStrokes;
  function NewKeyStroke(AOwner : PKeyStrokes) : PKeyStroke;

// These are mainly for the TEditorCommand property editor, but could be useful elsewhere.
function EditorCommandToDescrString(Cmd: TEditorCommand): String;
function EditorCommandToCodeString(Cmd: TEditorCommand): String;
procedure GetEditorCommandValues(Proc: TGetStrProc);
function IdentToEditorCommand(const Ident: String; var Cmd: Longint): Boolean;
function EditorCommandToIdent(Cmd: Longint; var Ident: String): Boolean;

//----------------------------------------------------------------------------------------------------------------------

implementation

const
  EditorCommandStrs: array[0..82] of TIdentMapEntry = (
    (Value: ecNone; Name: 'ecNone'),
    (Value: ecLeft; Name: 'ecLeft'),
    (Value: ecRight; Name: 'ecRight'),
    (Value: ecUp; Name: 'ecUp'),
    (Value: ecDown; Name: 'ecDown'),
    (Value: ecWordLeft; Name: 'ecWordLeft'),
    (Value: ecWordRight; Name: 'ecWordRight'),
    (Value: ecLineStart; Name: 'ecLineStart'),
    (Value: ecLineEnd; Name: 'ecLineEnd'),
    (Value: ecPageUp; Name: 'ecPageUp'),
    (Value: ecPageDown; Name: 'ecPageDown'),
    (Value: ecPageLeft; Name: 'ecPageLeft'),
    (Value: ecPageRight; Name: 'ecPageRight'),
    (Value: ecPageTop; Name: 'ecPageTop'),
    (Value: ecPageBottom; Name: 'ecPageBottom'),
    (Value: ecEditorTop; Name: 'ecEditorTop'),
    (Value: ecEditorBottom; Name: 'ecEditorBottom'),
    (Value: ecGotoXY; Name: 'ecGoto'),
    (Value: ecSelLeft; Name: 'ecSelectLeft'),
    (Value: ecSelRight; Name: 'ecSelectRight'),
    (Value: ecSelUp; Name: 'ecSelectUp'),
    (Value: ecSelDown; Name: 'ecSelectDown'),
    (Value: ecSelWordLeft; Name: 'ecSelectWordLeft'),
    (Value: ecSelWordRight; Name: 'ecSelectWordRight'),
    (Value: ecSelLineStart; Name: 'ecSelectLineStart'),
    (Value: ecSelLineEnd; Name: 'ecSelectLineEnd'),
    (Value: ecSelPageUp; Name: 'ecSelectPageUp'),
    (Value: ecSelPageDown; Name: 'ecSelectPageDown'),
    (Value: ecSelPageLeft; Name: 'ecSelectPageLeft'),
    (Value: ecSelPageRight; Name: 'ecSelectPageRight'),
    (Value: ecSelPageTop; Name: 'ecSelectPageTop'),
    (Value: ecSelPageBottom; Name: 'ecSelectPageBottom'),
    (Value: ecSelEditorTop; Name: 'ecSelectEditorTop'),
    (Value: ecSelEditorBottom; Name: 'ecSelectEditorBottom'),
    (Value: ecSelGotoXY; Name: 'ecSelectGoto'),
    (Value: ecSelectAll; Name: 'ecSelectAll'),
    (Value: ecDeleteLastChar; Name: 'ecDeleteLastChar'),
    (Value: ecDeleteChar; Name: 'ecDeleteChar'),
    (Value: ecDeleteWord; Name: 'ecDeleteWord'),
    (Value: ecDeleteLastWord; Name: 'ecDeleteLastWord'),
    (Value: ecDeleteBOL; Name: 'ecDeleteBOL'),
    (Value: ecDeleteEOL; Name: 'ecDeleteEOL'),
    (Value: ecDeleteLine; Name: 'ecDeleteLine'),
    (Value: ecClearAll; Name: 'ecClearAll'),
    (Value: ecLineBreak; Name: 'ecLineBreak'),
    (Value: ecInsertLine; Name: 'ecInsertLine'),
    (Value: ecChar; Name: 'ecChar'),
    (Value: ecUndo; Name: 'ecUndo'),
    (Value: ecRedo; Name: 'ecRedo'),
    (Value: ecCut; Name: 'ecCut'),
    (Value: ecCopy; Name: 'ecCopy'),
    (Value: ecPaste; Name: 'ecPaste'),
    (Value: ecScrollUp; Name: 'ecScrollUp'),
    (Value: ecScrollDown; Name: 'ecScrollDown'),
    (Value: ecScrollLeft; Name: 'ecScrollLeft'),
    (Value: ecScrollRight; Name: 'ecScrollRight'),
    (Value: ecInsertMode; Name: 'ecInsertMode'),
    (Value: ecOverwriteMode; Name: 'ecOverwriteMode'),
    (Value: ecToggleMode; Name: 'ecToggleMode'),
    (Value: ecBlockIndent; Name: 'ecBlockIndent'),
    (Value: ecBlockUnindent; Name: 'ecBlockUnindent'),
    (Value: ecDelete; Name: 'ecDelete'),
    (Value: ecUserFirst; Name: 'ecUserFirst'),
    (Value: ecGotoMarker0; Name: 'ecGotoMarker0'),
    (Value: ecGotoMarker1; Name: 'ecGotoMarker1'),
    (Value: ecGotoMarker2; Name: 'ecGotoMarker2'),
    (Value: ecGotoMarker3; Name: 'ecGotoMarker3'),
    (Value: ecGotoMarker4; Name: 'ecGotoMarker4'),
    (Value: ecGotoMarker5; Name: 'ecGotoMarker5'),
    (Value: ecGotoMarker6; Name: 'ecGotoMarker6'),
    (Value: ecGotoMarker7; Name: 'ecGotoMarker7'),
    (Value: ecGotoMarker8; Name: 'ecGotoMarker8'),
    (Value: ecGotoMarker9; Name: 'ecGotoMarker9'),
    (Value: ecToggleMarker0; Name: 'ecToggleMarker0'),
    (Value: ecToggleMarker1; Name: 'ecToggleMarker1'),
    (Value: ecToggleMarker2; Name: 'ecToggleMarker2'),
    (Value: ecToggleMarker3; Name: 'ecToggleMarker3'),
    (Value: ecToggleMarker4; Name: 'ecToggleMarker4'),
    (Value: ecToggleMarker5; Name: 'ecToggleMarker5'),
    (Value: ecToggleMarker6; Name: 'ecToggleMarker6'),
    (Value: ecToggleMarker7; Name: 'ecToggleMarker7'),
    (Value: ecToggleMarker8; Name: 'ecToggleMarker8'),
    (Value: ecToggleMarker9; Name: 'ecToggleMarker9'));
const
  scShift = $2000;
  scCtrl = $4000;
  scAlt = $8000;
var
  MenuKeyCaps: array[TMenuKeyCap] of string = (
    SmkcBkSp, SmkcTab, SmkcEsc, SmkcEnter, SmkcSpace, SmkcPgUp,
    SmkcPgDn, SmkcEnd, SmkcHome, SmkcLeft, SmkcUp, SmkcRight,
    SmkcDown, SmkcIns, SmkcDel, SmkcShift, SmkcCtrl, SmkcAlt);

function ShortCut_Get(Key: Word; Shift: TShiftState): TShortCut;
begin
  Result := 0;
  if WordRec(Key).Hi <> 0 then Exit;
  Result := Key;
  if ssShift in Shift then Inc(Result, scShift);
  if ssCtrl in Shift then Inc(Result, scCtrl);
  if ssAlt in Shift then Inc(Result, scAlt);
end;

procedure ShortCutToKey(ShortCut: TShortCut; var Key: Word; var Shift: TShiftState);
begin
  Key := ShortCut and not (scShift + scCtrl + scAlt);
  Shift := [];
  if ShortCut and scShift <> 0 then Include(Shift, ssShift);
  if ShortCut and scCtrl <> 0 then Include(Shift, ssCtrl);
  if ShortCut and scAlt <> 0 then Include(Shift, ssAlt);
end;

function GetSpecialName(ShortCut: TShortCut): string;
var
  ScanCode: Integer;
  KeyName: array[0..255] of Char;
begin
  Result := '';
  ScanCode := MapVirtualKey(WordRec(ShortCut).Lo, 0) shl 16;
  if ScanCode <> 0 then
  begin
    GetKeyNameText(ScanCode, KeyName, SizeOf(KeyName));
    GetSpecialName := KeyName;
  end;
end;

function ShortCutToText(ShortCut: TShortCut): string;
var
  Name: string;
begin
  case WordRec(ShortCut).Lo of
    $08, $09:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcBkSp) + WordRec(ShortCut).Lo - $08)];
    $0D: Name := MenuKeyCaps[mkcEnter];
    $1B: Name := MenuKeyCaps[mkcEsc];
    $20..$28:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcSpace) + WordRec(ShortCut).Lo - $20)];
    $2D..$2E:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcIns) + WordRec(ShortCut).Lo - $2D)];
    $30..$39: Name := Chr(WordRec(ShortCut).Lo - $30 + Ord('0'));
    $41..$5A: Name := Chr(WordRec(ShortCut).Lo - $41 + Ord('A'));
    $60..$69: Name := Chr(WordRec(ShortCut).Lo - $60 + Ord('0'));
    $70..$87: Name := 'F' + Int2Str(WordRec(ShortCut).Lo - $6F);
  else
    Name := GetSpecialName(ShortCut);
  end;
  if Name <> '' then
  begin
    Result := '';
    if ShortCut and scShift <> 0 then Result := Result + MenuKeyCaps[mkcShift];
    if ShortCut and scCtrl <> 0 then Result := Result + MenuKeyCaps[mkcCtrl];
    if ShortCut and scAlt <> 0 then Result := Result + MenuKeyCaps[mkcAlt];
    Result := Result + Name;
  end
  else Result := '';
end;

function IdentToInt(const Ident: string; var Int: Longint; const Map: array of TIdentMapEntry): Boolean;
var
  I: Integer;
begin
  for I := Low(Map) to High(Map) do
    if StrEq(Map[I].Name, Ident) then
    begin
      Result := True;
      Int := Map[I].Value;
      Exit;
    end;
  Result := False;
end;

function IntToIdent(Int: Longint; var Ident: string; const Map: array of TIdentMapEntry): Boolean;
var
  I: Integer;
begin
  for I := Low(Map) to High(Map) do
    if Map[I].Value = Int then
    begin
      Result := True;
      Ident := Map[I].Name;
      Exit;
    end;
  Result := False;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure GetEditorCommandValues(Proc: TGetStrProc);

var I: Integer;

begin
  for I := Low(EditorCommandStrs) to High(EditorCommandStrs) do Proc(EditorCommandStrs[I].Name);
end;

//----------------------------------------------------------------------------------------------------------------------

function IdentToEditorCommand(const Ident: String; var Cmd: Longint): Boolean;

begin
  Result := IdentToInt(Ident, Cmd, EditorCommandStrs);
end;

//----------------------------------------------------------------------------------------------------------------------

function EditorCommandToIdent(Cmd: Longint; var Ident: String): Boolean;

begin
  Result := IntToIdent(Cmd, Ident, EditorCommandStrs);
end;

//----------------------------------------------------------------------------------------------------------------------

function EditorCommandToDescrString(Cmd: TEditorCommand): String;

// converts the ecXXXX description into a more appealing phrase,
// The approach used here is to split the string at those positions where
// a capital letter (or number) appears followed by a small letter.

var Temp, Part: String;
    Head, Tail: PChar;

begin
  Result := '';
  if EditorCommandToIdent(Cmd, Temp) then
  begin
    // remove 'ec'
    Delete(Temp, 1, 2);
    Head := PChar(Temp);
    while Head^ <> #0 do
    begin
      Tail := Head;
      // skip leading capital letters or numbers if there are some
      while Tail^ in ['A'..'Z', '0'..'9'] do Inc(Tail);
      // walk through the string until any other than a small letter has been found
      // (this automatically checks for the strings end)
      while Tail^ in ['a'..'z'] do Inc(Tail);
      SetString(Part, Head, Tail - Head);
      if Result <> '' then Result := Result + ' ' + Part
                      else Result := Result + Part;
      Head := Tail;
    end;
  end
  else Result := Int2Str(Cmd);
end;

//----------------------------------------------------------------------------------------------------------------------

function EditorCommandToCodeString(Cmd: TEditorCommand): String;

begin
  if not EditorCommandToIdent(Cmd, Result) then Result := Int2Str(Cmd);
end;

//----------------- TKeyStroke -----------------------------------------------------------------------------------------

function NewKeyStroke(AOwner : PKeyStrokes) : PKeyStroke;
begin
  New(Result, Create);
  Result.FKeyStrokes := AOwner;
end;

//----------------------------------------------------------------------------------------------------------------------

{procedure TKeyStroke.Assign(Source: TPersistent);

begin
  if Source is TKeyStroke then
  begin
    Key := TKeyStroke(Source).Key;
    Shift := TKeyStroke(Source).Shift;
    Command := TKeyStroke(Source).Command;
  end
  else inherited Assign(Source);
end;}

//----------------------------------------------------------------------------------------------------------------------

function TKeyStroke.GetDisplayName: String;

begin
  Result := EditorCommandToCodeString(Command) + ' - ' + ShortCutToText(ShortCut);
  if Result = '' then Result := FDisplayName;
end;

//----------------------------------------------------------------------------------------------------------------------

function TKeyStroke.GetShortCut: TShortCut;

begin
  Result := ShortCut_Get(Key, Shift);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TKeyStroke.SetCommand(const Value: TEditorCommand);

begin
  if Value <> FCommand then FCommand := Value;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TKeyStroke.SetKey(const Value: Word);

begin
  if Value <> FKey then FKey := Value;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TKeyStroke.SetShift(const Value: TShiftState);

begin
  if Value <> FShift then FShift := Value;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TKeyStroke.SetShortCut(const Value: TShortCut);

var
  NewKey: Word;
  NewShift: TShiftState;
  Dup: Integer;

begin
  // Duplicate values of no shortcut are OK.
  if Value <> 0 then
  begin
    // Check for duplicate shortcut in the collection and disallow if there is.
    Dup := FKeyStrokes.FindShortcut(Value);
    if (Dup <> -1) and (Dup <> Self.FKeyStrokes.FList.IndexOf(@Self)) then raise Exception.CreateCustom(9009, 'Shortcut already exists');
  end;

  ShortCutToKey(Value, NewKey, NewShift);
  if (NewKey <> Key) or (NewShift <> Shift) then
  begin
    Key := NewKey;
    Shift := NewShift;
  end;
end;

//----------------- TKeyStrokes ----------------------------------------------------------------------------------------

function NewKeyStrokes : PKeyStrokes;

begin
  New(Result, Create);
  Result.FList := NewList;
end;

//----------------------------------------------------------------------------------------------------------------------

function TKeyStrokes.Add: PKeyStroke;
var KS : PKeyStroke;
begin
  KS := NewKeyStroke(@Self);
  FList.Add(KS);
  Result := KS;
end;

//----------------------------------------------------------------------------------------------------------------------

{procedure TKeyStrokes.Assign(Source: TPersistent);

var
  I: Integer;

begin
  if Source is TKeyStrokes then
  begin
    Clear;
    for I := 0 to TKeyStrokes(Source).Count-1 do
    begin
      with Add do Assign(TKeyStrokes(Source)[I]);
    end;
  end
  else inherited Assign(Source);
end;}

//----------------------------------------------------------------------------------------------------------------------

procedure TKeyStrokes.Clear;
begin
  FList.Clear;
end;

destructor TKeyStrokes.Destroy;
begin
  FList.Free;
end;

function TKeyStrokes.FindCommand(Cmd: TEditorCommand): Integer;

var I: Integer;

begin
  Result := -1;
  for I := 0 to FList.Count - 1 do
    if Items[I].Command = Cmd then
    begin
      Result := I;
      Break;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TKeyStrokes.FindKeycode(Code: Word; SS: TShiftState): Integer;

var
  I: Integer;

begin
  Result := -1;
  for I := 0 to FList.Count-1 do
    if (Items[I].Key = Code) and (Items[I].Shift = SS) then
    begin
      Result := I;
      Break;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TKeyStrokes.FindShortcut(SC: TShortcut): Integer;

var
  I: Integer;

begin
  Result := -1;
  for I := 0 to FList.Count-1 do
    if Items[I].Shortcut = SC then
    begin
      Result := I;
      Break;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TKeyStrokes.GetItem(Index: Integer): PKeyStroke;

begin
 Result := FList.Items[Index];
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TKeyStrokes.ResetDefaults;

  //--------------- local functions -------------------------------------------

  procedure AddKey(const ACmd: TEditorCommand; const AKey: Word; const AShift: TShiftState);

  begin
    with Add^ do
    begin
      Key := AKey;
      Shift := AShift;
      Command := ACmd;
    end;
  end;

  //--------------- end local functions ---------------------------------------

begin
  FList.Clear;

  AddKey(ecSelUp, VK_UP, [ssShift]);

  AddKey(ecUp, VK_UP, []);

  AddKey(ecScrollUp, VK_UP, [ssCtrl]);

  AddKey(ecDown, VK_DOWN, []);

  AddKey(ecSelDown, VK_DOWN, [ssShift]);

  AddKey(ecScrollDown, VK_DOWN, [ssCtrl]);

  AddKey(ecLeft, VK_LEFT, []);

  AddKey(ecSelLeft, VK_LEFT, [ssShift]);

  AddKey(ecWordLeft, VK_LEFT, [ssCtrl]);

  AddKey(ecSelWordLeft, VK_LEFT, [ssShift, ssCtrl]);

  AddKey(ecRight, VK_RIGHT, []);

  AddKey(ecSelRight, VK_RIGHT, [ssShift]);

  AddKey(ecWordRight, VK_RIGHT, [ssCtrl]);

  AddKey(ecSelWordRight, VK_RIGHT, [ssShift, ssCtrl]);

  AddKey(ecPageDown, VK_NEXT, []);

  AddKey(ecSelPageDown, VK_NEXT, [ssShift]);

  AddKey(ecPageBottom, VK_NEXT, [ssCtrl]);

  AddKey(ecSelPageBottom, VK_NEXT, [ssShift, ssCtrl]);

  AddKey(ecPageUp, VK_PRIOR, []);

  AddKey(ecSelPageUp, VK_PRIOR, [ssShift]);

  AddKey(ecPageTop, VK_PRIOR, [ssCtrl]);

  AddKey(ecSelPageTop, VK_PRIOR, [ssShift, ssCtrl]);

  AddKey(ecLineStart, VK_HOME, []);

  AddKey(ecSelLineStart, VK_HOME, [ssShift]);

  AddKey(ecEditorTop, VK_HOME, [ssCtrl]);

  AddKey(ecSelEditorTop, VK_HOME, [ssShift, ssCtrl]);

  AddKey(ecLineEnd, VK_END, []);

  AddKey(ecSelLineEnd, VK_END, [ssShift]);

  AddKey(ecEditorBottom, VK_END, [ssCtrl]);

  AddKey(ecSelEditorBottom, VK_END, [ssShift, ssCtrl]);

  AddKey(ecToggleMode, VK_INSERT, []);

  AddKey(ecPaste, Ord('V'), [ssCtrl]);
  AddKey(ecPaste, VK_INSERT, [ssShift]);

  AddKey(ecDeleteChar, VK_DELETE, []);

  AddKey(ecDeleteLastChar, VK_BACK, []);

  AddKey(ecDeleteLastWord, VK_BACK, [ssCtrl]);

  AddKey(ecUndo, Ord('Z'), [ssCtrl]);
  AddKey(ecUndo, VK_BACK, [ssAlt]);

  AddKey(ecRedo, Ord('Z'), [ssCtrl,ssShift]);
  AddKey(ecRedo, VK_BACK, [ssAlt, ssShift]);

  AddKey(ecLineBreak, VK_RETURN, []);
  AddKey(ecLineBreak, Ord('M'), [ssCtrl]);

  AddKey(ecSelectAll, Ord('A'), [ssCtrl]);

  AddKey(ecCopy, Ord('C'), [ssCtrl]);
  AddKey(ecCopy, VK_INSERT, [ssCtrl]);

  AddKey(ecCut, Ord('X'), [ssCtrl]);
  AddKey(ecCut, VK_DELETE, [ssShift]);

  AddKey(ecBlockIndent, Ord('I'), [ssCtrl, ssShift]);

  AddKey(ecInsertLine, Ord('N'), [ssCtrl]);

  AddKey(ecDeleteWord, Ord('T'), [ssCtrl]);

  AddKey(ecBlockUnindent, Ord('U'), [ssCtrl, ssShift]);

  AddKey(ecDelete, VK_DELETE, [ssCtrl]);

  AddKey(ecDeleteLine, Ord('Y'), [ssCtrl]);

  AddKey(ecDeleteEOL, Ord('Y'), [ssCtrl, ssShift]);

  AddKey(ecGotoMarker0, Ord('0'), [ssCtrl]);

  AddKey(ecGotoMarker1, Ord('1'), [ssCtrl]);

  AddKey(ecGotoMarker2, Ord('2'), [ssCtrl]);

  AddKey(ecGotoMarker3, Ord('3'), [ssCtrl]);

  AddKey(ecGotoMarker4, Ord('4'), [ssCtrl]);

  AddKey(ecGotoMarker5, Ord('5'), [ssCtrl]);

  AddKey(ecGotoMarker6, Ord('6'), [ssCtrl]);

  AddKey(ecGotoMarker7, Ord('7'), [ssCtrl]);

  AddKey(ecGotoMarker8, Ord('8'), [ssCtrl]);

  AddKey(ecGotoMarker9, Ord('9'), [ssCtrl]);

  AddKey(ecToggleMarker0, Ord('0'), [ssCtrl, ssShift]);

  AddKey(ecToggleMarker1, Ord('1'), [ssCtrl, ssShift]);

  AddKey(ecToggleMarker2, Ord('2'), [ssCtrl, ssShift]);

  AddKey(ecToggleMarker3, Ord('3'), [ssCtrl, ssShift]);

  AddKey(ecToggleMarker4, Ord('4'), [ssCtrl, ssShift]);

  AddKey(ecToggleMarker5, Ord('5'), [ssCtrl, ssShift]);

  AddKey(ecToggleMarker6, Ord('6'), [ssCtrl, ssShift]);

  AddKey(ecToggleMarker7, Ord('7'), [ssCtrl, ssShift]);

  AddKey(ecToggleMarker8, Ord('8'), [ssCtrl, ssShift]);

  AddKey(ecToggleMarker9, Ord('9'), [ssCtrl, ssShift]);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TKeyStrokes.SetItem(Index: Integer; Value: PKeyStroke);

begin
  FList.Items[Index] := Value;
end;

//----------------------------------------------------------------------------------------------------------------------

//initialization
//  RegisterIntegerConsts(TypeInfo(TEditorCommand), IdentToEditorCommand, EditorCommandToIdent);
end.
