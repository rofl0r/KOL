{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/
Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: SynEditHighlighter.pas, released 2000-04-07.

The Original Code is based on mwHighlighter.pas by Martin Waldenburg, part of
the mwEdit component suite.
Portions created by Martin Waldenburg are Copyright (C) 1998 Martin Waldenburg.
All Rights Reserved.

Contributors to the SynEdit and mwEdit projects are listed in the
Contributors.txt file.

$Id: SynEditHighlighter.pas,v 1.18 2002/04/10 19:46:29 harmeister Exp $

You may retrieve the latest version of this file at the SynEdit home page,
located at http://SynEdit.SourceForge.net

Known Issues:
-------------------------------------------------------------------------------}

unit KOLVMHSyntaxEditHighlighter;

interface

uses Windows, kol, err, KOLVMHSyntaxEditTypes;

type
  PHighlighterAttributes = ^THighlighterAttributes;
  THighlighterAttributes = object(TObj)
  private
    fBackground: TColor;
    fBackgroundDefault: TColor;
    fForeground: TColor;
    fForegroundDefault: TColor;
    fName: string;
    fStyle: TFontStyle;
    fStyleDefault: TFontStyle;
    fOnChange: TOnEvent;
    procedure Changed; virtual;
    function GetBackgroundColorStored: boolean;
    function GetForegroundColorStored: boolean;
    function GetFontStyleStored: boolean;
    procedure SetBackground(Value: TColor);
    procedure SetForeground(Value: TColor);
    procedure SetStyle(Value: TFontStyle);
    function GetStyleFromInt: integer;
    procedure SetStyleFromInt(const Value: integer);
  public
    procedure Assign(Source: PHighlighterAttributes); virtual;
    procedure InternalSaveDefaultValues;
    function LoadFromBorlandRegistry(rootKey: HKEY; attrKey, attrName: string;
      oldStyle: boolean): boolean; virtual;
    function LoadFromRegistry(Reg: HKEY): boolean;
    function SaveToRegistry(Reg: HKEY): boolean;
    function LoadFromFile(Ini : PIniFile): boolean;                             //DDH 10/16/01
    function SaveToFile(Ini : PIniFile): boolean;                               //DDH 10/16/01
  public
    property IntegerStyle: integer read GetStyleFromInt write SetStyleFromInt;
    property Name: string read fName;
    property OnChange: TOnEvent read fOnChange write fOnChange;
  //published
    property Background: TColor read fBackground write SetBackground
      stored GetBackgroundColorStored;
    property Foreground: TColor read fForeground write SetForeground
      stored GetForegroundColorStored;
    property Style: TFontStyle read fStyle write SetStyle
      stored GetFontStyleStored;
  end;

  THighlighterCapability = (
    hcUserSettings, // supports Enum/UseUserSettings
    hcRegistry      // supports LoadFrom/SaveToRegistry
  );

  THighlighterCapabilities = set of THighlighterCapability;

const
  SYN_ATTR_COMMENT           =   0;
  SYN_ATTR_IDENTIFIER        =   1;
  SYN_ATTR_KEYWORD           =   2;
  SYN_ATTR_STRING            =   3;
  SYN_ATTR_WHITESPACE        =   4;
  SYN_ATTR_SYMBOL            =   5;                                             //mh 2001-09-13

type
  PVMHCustomHighlighter = ^TVMHCustomHighlighter;
  TKOLVMHCustomHighlighter = PVMHCustomHighlighter;
  TVMHCustomHighlighter = object(TObj)
  private
    procedure SetEnabled(const Value: boolean);                                                          //DDH 2001-10-23
  protected
    fAttributes: PStrListEx;
    fAttrChangeHooks: PList;
    fUpdateCount: integer;                                                      //mh 2001-09-13
    fEnabled: Boolean;
    fWordBreakChars: TSynIdentChars;
    fDefaultFilter: string;
    fUpdateChange: boolean;                                                     //mh 2001-09-13
    procedure AddAttribute(AAttrib: PHighlighterAttributes);
    procedure DefHighlightChange(Sender: PObj);
    procedure FreeHighlighterAttributes;                                        //mh 2001-09-13
    function GetAttribCount: integer; virtual;
    function GetAttribute(idx: integer): PHighlighterAttributes; virtual;
    function GetDefaultAttribute(Index: integer): PHighlighterAttributes;
      virtual; abstract;
    function GetDefaultFilter: string; virtual;
    function GetIdentChars: TSynIdentChars; virtual;
    procedure SetWordBreakChars(AChars: TSynIdentChars); virtual;
    function GetSampleSource: string; virtual;
    function IsFilterStored: boolean; virtual;
    procedure SetAttributesOnChange(AEvent: TOnEvent);
    procedure SetDefaultFilter(Value: string); virtual;
    procedure SetSampleSource(Value: string); virtual;
    destructor Destroy; virtual;
  public
    function GetCapabilities: THighlighterCapabilities; virtual;
    function GetLanguageName: string; virtual;
  public
    //procedure Assign(Source: TPersistent); override;
{begin}                                                                         //mh 2001-09-13
    procedure BeginUpdate;
    procedure EndUpdate;
{end}                                                                           //mh 2001-09-13
    function GetEol: Boolean; virtual; abstract;
    function GetRange: Pointer; virtual;
    function GetToken: String; virtual; abstract;
    function GetTokenAttribute: PHighlighterAttributes; virtual; abstract;
    function GetTokenKind: integer; virtual; abstract;
    function GetTokenPos: Integer; virtual; abstract;
    function IsKeyword(const AKeyword: string): boolean; virtual;               // DJLP 2000-08-09
    procedure Next; virtual; abstract;
    procedure NextToEol;
    procedure SetLine(NewValue: String; LineNumber:Integer); virtual; abstract;
    procedure SetRange(Value: Pointer); virtual;
    procedure ResetRange; virtual;
    function UseUserSettings(settingIndex: integer): boolean; virtual;
    procedure EnumUserSettings(Settings: PStrList); virtual;
    function LoadFromRegistry(RootKey: HKEY; Key: string): boolean; virtual;
    function SaveToRegistry(RootKey: HKEY; Key: string): boolean; virtual;
    function LoadFromFile(AFileName: String): boolean;                          //DDH 10/16/01
    function SaveToFile(AFileName: String): boolean;                            //DDH 10/16/01
    procedure HookAttrChangeEvent(ANotifyEvent: TOnEvent);
    procedure UnhookAttrChangeEvent(ANotifyEvent: TOnEvent);
    property IdentChars: TSynIdentChars read GetIdentChars;
    property WordBreakChars: TSynIdentChars read fWordBreakChars write SetWordBreakChars;
    property LanguageName: string read GetLanguageName;
  public
    property AttrCount: integer read GetAttribCount;
    property Attribute[idx: integer]: PHighlighterAttributes
      read GetAttribute;
    property Capabilities: THighlighterCapabilities read GetCapabilities;
    property SampleSource: string read GetSampleSource write SetSampleSource;
    property CommentAttribute: PHighlighterAttributes
      index SYN_ATTR_COMMENT read GetDefaultAttribute;
    property IdentifierAttribute: PHighlighterAttributes
      index SYN_ATTR_IDENTIFIER read GetDefaultAttribute;
    property KeywordAttribute: PHighlighterAttributes
      index SYN_ATTR_KEYWORD read GetDefaultAttribute;
    property StringAttribute: PHighlighterAttributes
      index SYN_ATTR_STRING read GetDefaultAttribute;
    property SymbolAttribute: PHighlighterAttributes                         //mh 2001-09-13
      index SYN_ATTR_SYMBOL read GetDefaultAttribute;
    property WhitespaceAttribute: PHighlighterAttributes
      index SYN_ATTR_WHITESPACE read GetDefaultAttribute;
  //published
    property DefaultFilter: string read GetDefaultFilter write SetDefaultFilter
      stored IsFilterStored;
    property Enabled: boolean read fEnabled write SetEnabled default TRUE;      //DDH 2001-10-23
  end;

  PHighlighterList = ^THighlighterList;
  THighlighterList = object(TObj)
  private
    hlList: PList;
    function GetItem(idx: integer): PVMHCustomHighlighter;
  public
    destructor Destroy; virtual;
    function Count: integer;
    function FindByName(name: string): integer;
    //function FindByClass(comp: TControl): integer;
    property Items[idx: integer]: PVMHCustomHighlighter read GetItem; default;
  end;

  procedure RegisterPlaceableHighlighter(highlighter:
    PVMHCustomHighlighter);
  function GetPlaceableHighlighters: PHighlighterList;
// Constructors
  function NewHighlighterAttributes(attribName: string): PHighlighterAttributes;
  function NewVMHCustomHighlighter(AOwner: PControl): PVMHCustomHighlighter;
  function NewHighlighterList: PHighlighterList;
implementation

{ THighlighterList }

function THighlighterList.Count: integer;
begin
  Result := hlList.Count;
end;

function NewHighlighterList: PHighlighterList;
begin
  New(Result, Create);
  Result.hlList := NewList;
end;

destructor THighlighterList.Destroy;
begin
  hlList.Free;
  inherited;
end;

{function THighlighterList.FindByClass(comp: TComponent): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to Count-1 do begin
    if comp is Items[i] then begin
      Result := i;
      Exit;
    end;
  end; //for
end;}

function THighlighterList.FindByName(name: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to Count-1 do begin
    if Items[i].GetLanguageName = name then begin
      Result := i;
      Exit;
    end;
  end; //for
end;

function THighlighterList.GetItem(idx: integer): PVMHCustomHighlighter;
begin
  Result := hlList.Items[idx];
end;

var
  G_PlaceableHighlighters: PHighlighterList;

  function GetPlaceableHighlighters: PHighlighterList;
  begin
    Result := G_PlaceableHighlighters;
  end;

  procedure RegisterPlaceableHighlighter(highlighter: PVMHCustomHighlighter);
  begin
    if G_PlaceableHighlighters.hlList.IndexOf(highlighter) < 0 then
      G_PlaceableHighlighters.hlList.Add(highlighter);
  end;

{ THighlighterAttributes }

procedure THighlighterAttributes.Assign(Source: PHighlighterAttributes);
var
  src: PHighlighterAttributes;
  bChanged: boolean;
begin
  bChanged := FALSE;
  src := Source;
  fName := src.fName;
  if fBackground <> src.fBackground then begin
    fBackground := src.fBackground;
    bChanged := TRUE;
  end;
  if fForeground <> src.fForeground then begin
    fForeground := src.fForeground;
    bChanged := TRUE;
  end;
  if fStyle <> src.fStyle then begin
    fStyle := src.fStyle;
    bChanged := TRUE;
  end;
  if bChanged then
    Changed;
end;

procedure THighlighterAttributes.Changed;
begin
  if Assigned(fOnChange) then
    fOnChange(@Self);
end;

function NewHighlighterAttributes(attribName: string): PHighlighterAttributes;
begin
  New(Result, Create);
  Result.Background := clNone;
  Result.Foreground := clNone;
  Result.fName := attribName;
end;

function THighlighterAttributes.GetBackgroundColorStored: boolean;
begin
  Result := fBackground <> fBackgroundDefault;
end;

function THighlighterAttributes.GetForegroundColorStored: boolean;
begin
  Result := fForeground <> fForegroundDefault;
end;

function THighlighterAttributes.GetFontStyleStored: boolean;
begin
  Result := fStyle <> fStyleDefault;
end;

procedure THighlighterAttributes.InternalSaveDefaultValues;
begin
  fForegroundDefault := fForeground;
  fBackgroundDefault := fBackground;
  fStyleDefault := fStyle;
end;

function THighlighterAttributes.LoadFromBorlandRegistry(rootKey: HKEY;
  attrKey, attrName: string; oldStyle: boolean): boolean;
  // How the highlighting information is stored:
  // Delphi 1.0:
  //   I don't know and I don't care.
  // Delphi 2.0 & 3.0:
  //   In the registry branch HKCU\Software\Borland\Delphi\x.0\Highlight
  //   where x=2 or x=3.
  //   Each entry is one string value, encoded as
  //     <foreground RGB>,<background RGB>,<font style>,<default fg>,<default Background>,<fg index>,<Background index>
  //   Example:
  //     0,16777215,BI,0,1,0,15
  //     foreground color (RGB): 0
  //     background color (RGB): 16777215 ($FFFFFF)
  //     font style: BI (bold italic), possible flags: B(old), I(talic), U(nderline)
  //     default foreground: no, specified color will be used (black (0) is used when this flag is 1)
  //     default background: yes, white ($FFFFFF, 15) will be used for background
  //     foreground index: 0 (foreground index (Pal16), corresponds to foreground RGB color)
  //     background index: 15 (background index (Pal16), corresponds to background RGB color)
  // Delphi 4.0 & 5.0:
  //   In the registry branch HKCU\Software\Borland\Delphi\4.0\Editor\Highlight.
  //   Each entry is subkey containing several values:
  //     Foreground Color: foreground index (Pal16), 0..15 (dword)
  //     Background Color: background index (Pal16), 0..15 (dword)
  //     Bold: fsBold yes/no, 0/True (string)
  //     Italic: fsItalic yes/no, 0/True (string)
  //     Underline: fsUnderline yes/no, 0/True (string)
  //     Default Foreground: use default foreground (clBlack) yes/no, False/-1 (string)
  //     Default Background: use default backround (clWhite) yes/no, False/-1 (string)
const
  Pal16: array [0..15] of TColor = (clBlack, clMaroon, clGreen, clOlive,
          clNavy, clPurple, clTeal, clLtGray, clDkGray, clRed, clLime,
          clYellow, clBlue, clFuchsia, clAqua, clWhite);

  function LoadOldStyle(rootKey: HKEY; attrKey, attrName: string): boolean;
  var
    descript : string;
    fgColRGB : string;
    bgColRGB : string;
    fontStyle: string;
    fgDefault: string;
    bgDefault: string;
    fgIndex16: string;
    bgIndex16: string;
    reg      : HKEY;

    function Get(var name: string): string;
    var
      p: integer;
    begin
      p := Pos(',',name);
      if p = 0 then p := Length(name)+1;
      Result := Copy(name,1,p-1);
      name := Copy(name,p+1,Length(name)-p);
    end; { Get }

  begin { LoadOldStyle }
    Result := false;
    reg := rootKey;
    Reg := RegKeyOpenRead(Reg, attrKey);
    if Reg <> 0 then
    begin
      if RegKeyValExists(Reg, attrName) then
      begin
        descript := RegKeyGetStr(Reg, attrName);
        fgColRGB  := Get(descript);
        bgColRGB  := Get(descript);
        fontStyle := Get(descript);
        fgDefault := Get(descript);
        bgDefault := Get(descript);
        fgIndex16 := Get(descript);
        bgIndex16 := Get(descript);
        if bgDefault = '1'
          then Background := clWindow
          else Background := Pal16[Str2Int(bgIndex16)];
        if fgDefault = '1'
          then Foreground := clWindowText
          else Foreground := Pal16[Str2Int(fgIndex16)];
        Style := [];
        if Pos('B',fontStyle) > 0 then Style := Style + [fsBold];
        if Pos('I',fontStyle) > 0 then Style := Style + [fsItalic];
        if Pos('U',fontStyle) > 0 then Style := Style + [fsUnderline];
        Result := true;
        end;
      RegCloseKey(Reg);
    end;
  end; { LoadOldStyle }

  function LoadNewStyle(rootKey: HKEY; attrKey, attrName: string): boolean;
  var
    fgIndex16    : DWORD;
    bgIndex16    : DWORD;
    fontBold     : string;
    fontItalic   : string;
    fontUnderline: string;
    fgDefault    : string;
    bgDefault    : string;
    reg          : HKEY;

    function IsTrue(value: string): boolean;
    begin
      Result := not ((UpperCase(value) = 'FALSE') or (value = '0'));
    end; { IsTrue }

  begin
    Result := false;
    reg := rootKey;
    Reg := RegKeyOpenRead(Reg, attrKey + '\' + attrName);
    if Reg <> 0 then
    begin
      if RegKeyValExists(Reg, 'Foreground Color')
        then fgIndex16 := RegKeyGetDw(Reg, 'Foreground Color')
        else Exit;
      if RegKeyValExists(Reg, 'Background Color')
        then bgIndex16 := RegKeyGetDw(Reg, 'Background Color')
        else Exit;
      if RegKeyValExists(Reg, 'Bold')
        then fontBold := RegKeyGetStr(Reg, 'Bold')
        else Exit;
      if RegKeyValExists(Reg, 'Italic')
        then fontItalic := RegKeyGetStr(Reg, 'Italic')
        else Exit;
      if RegKeyValExists(Reg, 'Underline')
        then fontUnderline := RegKeyGetStr(Reg, 'Underline')
        else Exit;
      if RegKeyValExists(Reg, 'Default Foreground')
        then fgDefault := RegKeyGetStr(Reg, 'Default Foreground')
        else Exit;
      if RegKeyValExists(Reg, 'Default Background')
        then bgDefault := RegKeyGetStr(Reg, 'Default Background')
        else Exit;
      if IsTrue(bgDefault)
        then Background := clWindow
        else Background := Pal16[bgIndex16];
      if IsTrue(fgDefault)
        then Foreground := clWindowText
        else Foreground := Pal16[fgIndex16];
      Style := [];
      if IsTrue(fontBold) then Style := Style + [fsBold];
      if IsTrue(fontItalic) then Style := Style + [fsItalic];
      if IsTrue(fontUnderline) then Style := Style + [fsUnderline];
      Result := true;
      RegKeyClose(Reg);
    end;
  end; { LoadNewStyle }

begin
  if oldStyle then Result := LoadOldStyle(rootKey, attrKey, attrName)
              else Result := LoadNewStyle(rootKey, attrKey, attrName);
end; { THighlighterAttributes.LoadFromBorlandRegistry }

procedure THighlighterAttributes.SetBackground(Value: TColor);
begin
  if fBackGround <> Value then begin
    fBackGround := Value;
    Changed;
  end;
end;

procedure THighlighterAttributes.SetForeground(Value: TColor);
begin
  if fForeGround <> Value then begin
    fForeGround := Value;
    Changed;
  end;
end;

procedure THighlighterAttributes.SetStyle(Value: TFontStyle);
begin
  if fStyle <> Value then begin
    fStyle := Value;
    Changed;
  end;
end;

{$IFNDEF SYN_CLX}
function THighlighterAttributes.LoadFromRegistry(Reg: HKEY): boolean;
var
  key: HKEY;
begin
  key := Reg;
  Key := RegKeyOpenRead(Key, Name);
  if Key <> 0 then
  begin
    if RegKeyValExists(Key, 'Background') then
      Background := RegKeyGetDw(Key, 'Background');
    if RegKeyValExists(Key, 'Foreground') then
      Foreground := RegKeyGetDw(Key, 'Foreground');
    if RegKeyValExists(Key, 'Style') then
      IntegerStyle := RegKeyGetDw(Key, 'Style');
    RegKeyClose(Key);
    Result := true;
  end
  else Result := false;
end;

function THighlighterAttributes.SaveToRegistry(Reg: HKEY): boolean;
var
  key: HKEY;
begin
  key := Reg;
  Key := RegKeyOpenCreate(Key, Name);
  if Key <> 0 then
  begin
    RegKeySetDw(Key, 'Background', Background);
    RegKeySetDw(Key, 'Foreground', Foreground);
    RegKeySetDw(Key, 'Style', IntegerStyle);
    RegKeyClose(Key);
    Result := true;
  end
  else Result := false;
end;

function THighlighterAttributes.LoadFromFile(Ini : PIniFile): boolean;       //DDH 10/16/01
begin
  // Ini must be in read mode
  Ini.Section := Name;
  Background := Ini.ValueInteger('Background', fBackground);
  Foreground := Ini.ValueInteger('Foreground', fForeground);
  IntegerStyle := Ini.ValueInteger('Style', IntegerStyle);
  Result := true;
end;

function THighlighterAttributes.SaveToFile(Ini : PIniFile): boolean;         //DDH 10/16/01
begin
  // Ini must be in write mode
  Ini.Section := Name;
  Ini.ValueInteger('Background', Background);
  Ini.ValueInteger('Foreground', Foreground);
  Ini.ValueInteger('Style', IntegerStyle);
  Result := true;
end;

{$ENDIF}

function THighlighterAttributes.GetStyleFromInt: integer;
begin
  if fsBold in Style then Result:= 1 else Result:= 0;
  if fsItalic in Style then Result:= Result + 2;
  if fsUnderline in Style then Result:= Result + 4;
  if fsStrikeout in Style then Result:= Result + 8;
end;

procedure THighlighterAttributes.SetStyleFromInt(const Value: integer);
begin
  if Value and $1 = 0 then  Style:= [] else Style:= [fsBold];
  if Value and $2 <> 0 then Style:= Style + [fsItalic];
  if Value and $4 <> 0 then Style:= Style + [fsUnderline];
  if Value and $8 <> 0 then Style:= Style + [fsStrikeout];
end;

{ TCustomHighlighter }

function NewVMHCustomHighlighter(AOwner: PControl): PVMHCustomHighlighter;
begin
  New(Result, Create);
  Result.fWordBreakChars := TSynWordBreakChars;
  Result.fAttributes := NewStrListEx;
  //Result.fAttributes.Duplicates := dupError;
  //Result.fAttributes.Sorted := TRUE;
  Result.fDefaultFilter := '';
  Result.fEnabled := True;
end;

{begin}                                                                         //mh 2001-09-13
destructor TVMHCustomHighlighter.Destroy;
begin
//  for i := fAttributes.Count - 1 downto 0 do
//    THighlighterAttributes(fAttributes.Objects[i]).Free;
  FreeHighlighterAttributes;
  fAttributes.Free;
  fAttrChangeHooks.Free;
  inherited Destroy;
end;

procedure TVMHCustomHighlighter.BeginUpdate;
begin
  Inc(fUpdateCount);
end;

procedure TVMHCustomHighlighter.EndUpdate;
begin
  if fUpdateCount > 0 then begin
    Dec(fUpdateCount);
    if (fUpdateCount = 0) and fUpdateChange then begin
      fUpdateChange := FALSE;
      DefHighlightChange(@Self);
    end;
  end;
end;

procedure TVMHCustomHighlighter.FreeHighlighterAttributes;
var
  i: integer;
begin
  if fAttributes <> nil then begin
    for i := fAttributes.Count - 1 downto 0 do
      PObj(fAttributes.Objects[i]).Free;
    fAttributes.Clear;
  end;
end;
{end}                                                                           //mh 2001-09-13

{procedure TCustomHighlighter.Assign(Source: TPersistent);
var
  Src: TCustomHighlighter;
  i, j: integer;
  AttriName: string;
  SrcAttri: THighlighterAttributes;
begin
  if (Source <> nil) and (Source is TCustomHighlighter) then begin
    Src := TCustomHighlighter(Source);
    for i := 0 to AttrCount - 1 do begin
      // assign first attribute with the same name
      AttriName := Attribute[i].Name;
      for j := 0 to Src.AttrCount - 1 do begin
        SrcAttri := Src.Attribute[j];
        if AttriName = SrcAttri.Name then begin
          Attribute[i].Assign(SrcAttri);
          continue;
        end;
      end;
    end;
    // assign the sample source text only if same or descendant class
    if Src is ClassType then
      SampleSource := Src.SampleSource;
    fWordBreakChars := Src.WordBreakChars;
    DefaultFilter := Src.DefaultFilter;
    Enabled := Src.Enabled;
  end else
    inherited Assign(Source);
end;}

procedure TVMHCustomHighlighter.EnumUserSettings(Settings: PStrList);
begin
  Settings.Clear;
end;

function TVMHCustomHighlighter.UseUserSettings(settingIndex: integer): boolean;
begin
  Result := false;
end;

{$IFNDEF SYN_CLX}
function TVMHCustomHighlighter.LoadFromRegistry(RootKey: HKEY;
  Key: string): boolean;
var
  r: HKEY;
  i: integer;
begin
  r := RootKey;
  r := RegKeyOpenRead(r, Key);
  if r <> 0 then
  begin
    Result := true;
    for i := 0 to AttrCount-1 do
      Result := Result and Attribute[i].LoadFromRegistry(r);
    RegCloseKey(r);
  end
  else Result := false;
end;

function TVMHCustomHighlighter.SaveToRegistry(RootKey: HKEY;
  Key: string): boolean;
var
  r: HKEY;
  i: integer;
begin
  r := RootKey;
  r := RegKeyOpenCreate(r, Key);
  if r <> 0 then
  begin
    Result := true;
    for i := 0 to AttrCount-1 do
      Result := Result and Attribute[i].SaveToRegistry(r);
    RegCloseKey(r);
  end
  else Result := false;
end;

function TVMHCustomHighlighter.LoadFromFile(AFileName : String): boolean;       //DDH 10/16/01
VAR AIni : PIniFile;
    i : Integer;
begin
  AIni := OpenIniFile(AFileName);
  AIni.Mode := ifmRead;
  with AIni^ do
  begin
    Result := true;
    for i := 0 to AttrCount-1 do
      Result := Attribute[i].LoadFromFile(AIni) and Result;
  end;
  AIni.Free;
end;

function TVMHCustomHighlighter.SaveToFile(AFileName : String): boolean;         //DDH 10/16/01
var AIni : PIniFile;
    i: integer;
begin
  AIni := OpenIniFile(AFileName);
  AIni.Mode := ifmWrite;
  with AIni^ do
  begin
    Result := true;
    for i := 0 to AttrCount-1 do
      Result := Result and Attribute[i].SaveToFile(AIni);
  end;
  AIni.Free;
end;

{$ENDIF}

procedure TVMHCustomHighlighter.AddAttribute(AAttrib: PHighlighterAttributes);
begin
  fAttributes.AddObject(AAttrib.Name, Integer(AAttrib));
end;

procedure TVMHCustomHighlighter.DefHighlightChange(Sender: PObj);
var I : Integer;
begin
{begin}                                                                         //mh 2001-09-13
  if fUpdateCount > 0 then
    fUpdateChange := TRUE
  else
{end}
  if not Assigned(fAttrChangeHooks) then Exit;                                                                           //mh 2001-09-13
  for I := 0 to fAttrChangeHooks.Count-1 do
    TOnEvent(MakeMethod(fAttrChangeHooks.Items[I], nil))(@Self);
end;

function TVMHCustomHighlighter.GetAttribCount: integer;
begin
  Result := fAttributes.Count;
end;

function TVMHCustomHighlighter.GetAttribute(idx: integer):
  PHighlighterAttributes;
begin
  Result := nil;
  if (idx >= 0) and (idx < fAttributes.Count) then
    Result := Pointer(fAttributes.Objects[idx]);
end;

function TVMHCustomHighlighter.GetCapabilities: THighlighterCapabilities;
begin
  Result := [hcRegistry]; //registry save/load supported by default
end;

function TVMHCustomHighlighter.GetDefaultFilter: string;
begin
  Result := fDefaultFilter;
end;

function TVMHCustomHighlighter.GetIdentChars: TSynIdentChars;
begin
  Result := [#33..#255];
end;

procedure TVMHCustomHighlighter.SetWordBreakChars(AChars: TSynIdentChars);
begin
  fWordBreakChars := AChars;
end;


function TVMHCustomHighlighter.GetLanguageName: string;
begin
  //raise Exception.CreateFmt('%s.GetLanguageName not implemented', [ClassName]);
  Result := '<Unknown>';
end;

function TVMHCustomHighlighter.GetRange: pointer;
begin
  Result := nil;
end;

function TVMHCustomHighlighter.GetSampleSource: string;
begin
  Result := '';
end;

procedure TVMHCustomHighlighter.HookAttrChangeEvent(ANotifyEvent: TOnEvent);
begin
  if not Assigned(fAttrChangeHooks) then
    fAttrChangeHooks := NewList;
  fAttrChangeHooks.Add(@ANotifyEvent);
end;

function TVMHCustomHighlighter.IsFilterStored: boolean;
begin
  Result := TRUE;
end;

{begin}                                                                         // DJLP 2000-08-09
function TVMHCustomHighlighter.IsKeyword(const AKeyword: string): boolean;
begin
  Result := FALSE;
end;
{end}                                                                           // DJLP 2000-08-09

procedure TVMHCustomHighlighter.NextToEol;
begin
  while not GetEol do Next;
end;

procedure TVMHCustomHighlighter.ResetRange;
begin
end;

procedure TVMHCustomHighlighter.SetAttributesOnChange(AEvent: TOnEvent);
var
  i: integer;
  Attri: PHighlighterAttributes;
begin
  for i := fAttributes.Count - 1 downto 0 do begin
    Attri := Pointer(fAttributes.Objects[i]);
    if Attri <> nil then begin
      Attri.OnChange := AEvent;
      Attri.InternalSaveDefaultValues;
    end;
  end;
end;

procedure TVMHCustomHighlighter.SetRange(Value: Pointer);
begin
end;

procedure TVMHCustomHighlighter.SetDefaultFilter(Value: string);
begin
  fDefaultFilter := Value;
end;

procedure TVMHCustomHighlighter.SetSampleSource(Value: string);
begin
end;

procedure TVMHCustomHighlighter.UnhookAttrChangeEvent(ANotifyEvent: TOnEvent);
begin
  if not Assigned(fAttrChangeHooks) then Exit;
  fAttrChangeHooks.Remove(@ANotifyEvent);
  if fAttrChangeHooks.Count = 0 then
    fAttrChangeHooks.Free;
end;

procedure TVMHCustomHighlighter.SetEnabled(const Value: boolean);
begin
  if fEnabled <> Value then
  begin
    fEnabled := Value;
    //we need to notify any editor that we are attached to to repaint,
    //but a highlighter doesn't know what editor it is attached to.
    //Until this is resolved, you will have to manually call repaint
    //on the editor in question.
    DefHighlightChange( @Self );
  end;
end;

{$IFNDEF SYN_CPPB_1}

initialization
  G_PlaceableHighlighters := NewHighlighterList;
finalization
  G_PlaceableHighlighters.Free;
  G_PlaceableHighlighters := nil;
{$ENDIF}
end.


