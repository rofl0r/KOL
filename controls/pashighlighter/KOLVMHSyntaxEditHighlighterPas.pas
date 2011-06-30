unit KOLVMHSyntaxEditHighlighterPas;
//  VMHPasHighlighter Компонент (VMHPasHighlighter Component)
//  Автор (Author):
//    Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//    Вокс (Vox)
//  Дата создания (Create date): 1-ноя(nov)-2002
//  Дата коррекции (Last correction Date): 1-ноя(nov)-2002
//  Версия (Version): 1.0
//  EMail:
//    Gandalf@kol.mastak.ru
//    vox@smtp.ru
//  WWW:
//    http://kol.mastak.ru
//  Благодарности (Thanks):
//    Martin Waldenburg
//
//  Новое в (New in):
//  V1.0
//  [N] Создан! (Created!)
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Подчистить (Clear Stuff)
//  4. Ошибки (Errors)
//  5. Помощь (Help)
//  6. Установки по умолчанию (Defaults)

interface

uses
  Windows, KOLVMHSyntaxEditor, kol, KOLVMHSyntaxEditTypes, KOLVMHSyntaxEditHighlighter;

type
  TtkTokenKind = (tkAsm, tkComment, tkIdentifier, tkKey, tkNull, tkNumber,
    tkSpace, tkString, tkSymbol, tkUnknown, tkFloat, tkHex, tkDirec, tkChar); // dj

  TRangeState = (rsANil, rsAnsi, rsAnsiAsm, rsAsm, rsBor, rsBorAsm, rsProperty,
    rsExports, rsUnKnown);

  TProcTableProc = procedure of object;

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = function: TtkTokenKind of object;

  TDelphiVersion = (dvDelphi1, dvDelphi2, dvDelphi3, dvDelphi4, dvDelphi5,      //pp 2001-08-14
    dvDelphi6);

const
  LastDelphiVersion = dvDelphi6;                                                //pp 2001-08-14

type
  PVMHPasHighlighter = ^TVMHPasHighlighter;
  TKOLVMHPasHighlighter = PVMHPasHighlighter;
  TVMHPasHighlighter = object(TVMHCustomHighlighter)
  private
    fAsmStart: Boolean;
    fRange: TRangeState;
    fLine: PChar;
    fLineNumber: Integer;
    fProcTable: array[#0..#255] of TProcTableProc;
    Run: LongInt;
    fStringLen: Integer;
    fToIdent: PChar;
    fIdentFuncTable: array[0..191] of TIdentFuncTableFunc;
    fTokenPos: Integer;
    FTokenID: TtkTokenKind;
    fStringAttri: PHighlighterAttributes;
    fCharAttri: PHighlighterAttributes;
    fNumberAttri: PHighlighterAttributes;
    fFloatAttri: PHighlighterAttributes;
    fHexAttri: PHighlighterAttributes;
    fKeyAttri: PHighlighterAttributes;
    fSymbolAttri: PHighlighterAttributes;
    fAsmAttri: PHighlighterAttributes;
    fCommentAttri: PHighlighterAttributes;
    fDirecAttri: PHighlighterAttributes;
    fIdentifierAttri: PHighlighterAttributes;
    fSpaceAttri: PHighlighterAttributes;
    fD4syntax: boolean;
    fDelphiVersion: TDelphiVersion;
    fPackageSource: Boolean;
    function KeyHash(ToHash: PChar): Integer;
    function KeyComp(const aKey: string): Boolean;
    function Func15: TtkTokenKind;
    function Func19: TtkTokenKind;
    function Func20: TtkTokenKind;
    function Func21: TtkTokenKind;
    function Func23: TtkTokenKind;
    function Func25: TtkTokenKind;
    function Func27: TtkTokenKind;
    function Func28: TtkTokenKind;
    function Func29: TtkTokenKind;                                              //pp 2001-08-13
    function Func32: TtkTokenKind;
    function Func33: TtkTokenKind;
    function Func35: TtkTokenKind;
    function Func37: TtkTokenKind;
    function Func38: TtkTokenKind;
    function Func39: TtkTokenKind;
    function Func40: TtkTokenKind;
    function Func41: TtkTokenKind;
    function Func44: TtkTokenKind;
    function Func45: TtkTokenKind;
    function Func47: TtkTokenKind;
    function Func49: TtkTokenKind;
    function Func52: TtkTokenKind;
    function Func54: TtkTokenKind;
    function Func55: TtkTokenKind;
    function Func56: TtkTokenKind;
    function Func57: TtkTokenKind;
    function Func59: TtkTokenKind;
    function Func60: TtkTokenKind;
    function Func61: TtkTokenKind;
    function Func63: TtkTokenKind;
    function Func64: TtkTokenKind;
    function Func65: TtkTokenKind;
    function Func66: TtkTokenKind;
    function Func69: TtkTokenKind;
    function Func71: TtkTokenKind;
    function Func73: TtkTokenKind;
    function Func75: TtkTokenKind;
    function Func76: TtkTokenKind;
    function Func79: TtkTokenKind;
    function Func81: TtkTokenKind;
    function Func84: TtkTokenKind;
    function Func85: TtkTokenKind;
    function Func87: TtkTokenKind;
    function Func88: TtkTokenKind;
    function Func91: TtkTokenKind;
    function Func92: TtkTokenKind;
    function Func94: TtkTokenKind;
    function Func95: TtkTokenKind;
    function Func96: TtkTokenKind;
    function Func97: TtkTokenKind;
    function Func98: TtkTokenKind;
    function Func99: TtkTokenKind;
    function Func100: TtkTokenKind;
    function Func101: TtkTokenKind;
    function Func102: TtkTokenKind;
    function Func103: TtkTokenKind;
    function Func105: TtkTokenKind;
    function Func106: TtkTokenKind;
    function Func112: TtkTokenKind;
    function Func117: TtkTokenKind;
    function Func126: TtkTokenKind;
    function Func129: TtkTokenKind;
    function Func132: TtkTokenKind;
    function Func133: TtkTokenKind;
    function Func136: TtkTokenKind;
    function Func141: TtkTokenKind;
    function Func143: TtkTokenKind;
    function Func166: TtkTokenKind;
    function Func168: TtkTokenKind;
    function Func191: TtkTokenKind;
    function AltFunc: TtkTokenKind;
    procedure InitIdent;
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
    procedure AddressOpProc;
    procedure AsciiCharProc;
    procedure AnsiProc;
    procedure BorProc;
    procedure BraceOpenProc;
    procedure ColonOrGreaterProc;
    procedure CRProc;
    procedure IdentProc;
    procedure IntegerProc;
    procedure LFProc;
    procedure LowerProc;
    procedure NullProc;
    procedure NumberProc;
    procedure PointProc;
    procedure RoundOpenProc;
    procedure SemicolonProc;                                                    //mh 2000-10-08
    procedure SlashProc;
    procedure SpaceProc;
    procedure StringProc;
    procedure SymbolProc;
    procedure UnknownProc;
    procedure SetD4syntax(const Value: boolean);
    procedure SetDelphiVersion(const Value: TDelphiVersion);                    //pp 2001-08-14
    procedure SetPackageSource(const Value: Boolean);                           //pp 2001-08-14
  protected
    function GetIdentChars: TSynIdentChars; virtual;
    function GetSampleSource: string; virtual;                                 //pp 2001-08-13
    function IsFilterStored: boolean; virtual;                                 //mh 2000-10-08
  public
    function GetCapabilities: THighlighterCapabilities; virtual;
    function GetLanguageName: string; virtual;
  public
    function GetDefaultAttribute(Index: integer): PHighlighterAttributes;
      virtual;
    function GetEol: Boolean; virtual;
    function GetRange: Pointer; virtual;
    function GetToken: string; virtual;
    function GetTokenAttribute: PHighlighterAttributes; virtual;
    function GetTokenID: TtkTokenKind;
    function GetTokenKind: integer; virtual;
    function GetTokenPos: Integer; virtual;
    procedure Next; virtual;
    procedure ResetRange; virtual;
    procedure SetLine(NewValue: string; LineNumber:Integer); virtual;
    procedure SetRange(Value: Pointer); virtual;
    function UseUserSettings(settingIndex: integer): boolean; virtual;
    procedure EnumUserSettings(settings: PStrList); virtual;
    property IdentChars;
  //published
    property AsmAttri: PHighlighterAttributes read fAsmAttri write fAsmAttri;
    property CommentAttri: PHighlighterAttributes read fCommentAttri
      write fCommentAttri;
    property DirectiveAttri: PHighlighterAttributes read fDirecAttri
      write fDirecAttri;
    property IdentifierAttri: PHighlighterAttributes read fIdentifierAttri
      write fIdentifierAttri;
    property KeyAttri: PHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: PHighlighterAttributes read fNumberAttri
      write fNumberAttri;
    property FloatAttri: PHighlighterAttributes read fFloatAttri
      write fFloatAttri;
    property HexAttri: PHighlighterAttributes read fHexAttri
      write fHexAttri;
    property SpaceAttri: PHighlighterAttributes read fSpaceAttri
      write fSpaceAttri;
    property StringAttri: PHighlighterAttributes read fStringAttri
      write fStringAttri;
    property CharAttri: PHighlighterAttributes read fCharAttri
      write fCharAttri;
    property SymbolAttri: PHighlighterAttributes read fSymbolAttri
      write fSymbolAttri;
    property D4syntax: boolean read fD4syntax write SetD4syntax stored False;
    property DelphiVersion: TDelphiVersion read fDelphiVersion write SetDelphiVersion
      default LastDelphiVersion;
    property PackageSource: Boolean read fPackageSource write SetPackageSource default True;
  end;

  function NewVMHPasHighlighter(AOwner: PControl): PVMHPasHighlighter;
  
implementation

uses
  KOLVMHSyntaxEditStrConst;

var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable: array[#0..#255] of Integer;

procedure MakeIdentTable;
var
  I, J: Char;
begin
  for I := #0 to #255 do
  begin
    Case I of
      '_', '0'..'9', 'a'..'z', 'A'..'Z': Identifiers[I] := True;
    else Identifiers[I] := False;
    end;
    J := UpCase(I);
    Case I of
      'a'..'z', 'A'..'Z', '_': mHashTable[I] := Ord(J) - 64;
    else mHashTable[Char(I)] := 0;
    end;
  end;
end;

procedure TVMHPasHighlighter.InitIdent;
var
  I: Integer;
  pF: PIdentFuncTableFunc;
begin
  pF := PIdentFuncTableFunc(@fIdentFuncTable);
  for I := Low(fIdentFuncTable) to High(fIdentFuncTable) do begin
    pF^ := AltFunc;
    Inc(pF);
  end;
  fIdentFuncTable[15] := Func15;
  fIdentFuncTable[19] := Func19;
  fIdentFuncTable[20] := Func20;
  fIdentFuncTable[21] := Func21;
  fIdentFuncTable[23] := Func23;
  fIdentFuncTable[25] := Func25;
  fIdentFuncTable[27] := Func27;
  fIdentFuncTable[28] := Func28;
  fIdentFuncTable[29] := Func29;                                                //pp 2001-08-13
  fIdentFuncTable[32] := Func32;
  fIdentFuncTable[33] := Func33;
  fIdentFuncTable[35] := Func35;
  fIdentFuncTable[37] := Func37;
  fIdentFuncTable[38] := Func38;
  fIdentFuncTable[39] := Func39;
  fIdentFuncTable[40] := Func40;
  fIdentFuncTable[41] := Func41;
  fIdentFuncTable[44] := Func44;
  fIdentFuncTable[45] := Func45;
  fIdentFuncTable[47] := Func47;
  fIdentFuncTable[49] := Func49;
  fIdentFuncTable[52] := Func52;
  fIdentFuncTable[54] := Func54;
  fIdentFuncTable[55] := Func55;
  fIdentFuncTable[56] := Func56;
  fIdentFuncTable[57] := Func57;
  fIdentFuncTable[59] := Func59;
  fIdentFuncTable[60] := Func60;
  fIdentFuncTable[61] := Func61;
  fIdentFuncTable[63] := Func63;
  fIdentFuncTable[64] := Func64;
  fIdentFuncTable[65] := Func65;
  fIdentFuncTable[66] := Func66;
  fIdentFuncTable[69] := Func69;
  fIdentFuncTable[71] := Func71;
  fIdentFuncTable[73] := Func73;
  fIdentFuncTable[75] := Func75;
  fIdentFuncTable[76] := Func76;
  fIdentFuncTable[79] := Func79;
  fIdentFuncTable[81] := Func81;
  fIdentFuncTable[84] := Func84;
  fIdentFuncTable[85] := Func85;
  fIdentFuncTable[87] := Func87;
  fIdentFuncTable[88] := Func88;
  fIdentFuncTable[91] := Func91;
  fIdentFuncTable[92] := Func92;
  fIdentFuncTable[94] := Func94;
  fIdentFuncTable[95] := Func95;
  fIdentFuncTable[96] := Func96;
  fIdentFuncTable[97] := Func97;
  fIdentFuncTable[98] := Func98;
  fIdentFuncTable[99] := Func99;
  fIdentFuncTable[100] := Func100;
  fIdentFuncTable[101] := Func101;
  fIdentFuncTable[102] := Func102;
  fIdentFuncTable[103] := Func103;
  fIdentFuncTable[105] := Func105;
  fIdentFuncTable[106] := Func106;
  fIdentFuncTable[112] := Func112;
  fIdentFuncTable[117] := Func117;
  fIdentFuncTable[126] := Func126;
  fIdentFuncTable[129] := Func129;
  fIdentFuncTable[132] := Func132;
  fIdentFuncTable[133] := Func133;
  fIdentFuncTable[136] := Func136;
  fIdentFuncTable[141] := Func141;
  fIdentFuncTable[143] := Func143;
  fIdentFuncTable[166] := Func166;
  fIdentFuncTable[168] := Func168;
  fIdentFuncTable[191] := Func191;
end;

function TVMHPasHighlighter.KeyHash(ToHash: PChar): Integer;
begin
  Result := 0;
  while ToHash^ in ['a'..'z', 'A'..'Z'] do
  begin
    inc(Result, mHashTable[ToHash^]);
    inc(ToHash);
  end;
  if ToHash^ in ['_', '0'..'9'] then inc(ToHash);
  fStringLen := ToHash - fToIdent;
end; { KeyHash }

function TVMHPasHighlighter.KeyComp(const aKey: string): Boolean;
var
  I: Integer;
  Temp: PChar;
begin
  Temp := fToIdent;
  if Length(aKey) = fStringLen then
  begin
    Result := True;
    for i := 1 to fStringLen do
    begin
      if mHashTable[Temp^] <> mHashTable[aKey[i]] then
      begin
        Result := False;
        break;
      end;
      inc(Temp);
    end;
  end else Result := False;
end; { KeyComp }

function TVMHPasHighlighter.Func15: TtkTokenKind;
begin
  if KeyComp('If') then Result := tkKey else Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func19: TtkTokenKind;
begin
  if KeyComp('Do') then Result := tkKey else
    if KeyComp('And') then Result := tkKey else Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func20: TtkTokenKind;
begin
  if KeyComp('As') then Result := tkKey else Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func21: TtkTokenKind;
begin
  if KeyComp('Of') then Result := tkKey else Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func23: TtkTokenKind;
begin
  if KeyComp('End') then
  begin
    Result := tkKey;
    fRange := rsUnknown;
  end
  else if KeyComp('In') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func25: TtkTokenKind;
begin
  if KeyComp('Far') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func27: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi2) and KeyComp('Cdecl') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func28: TtkTokenKind;
begin
  if KeyComp('Is') then
    Result := tkKey
  else if (fRange = rsProperty) and KeyComp('Read') then
    Result := tkKey
  else if KeyComp('Case') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func29: TtkTokenKind;                                       //pp 2001-08-13
begin
  if KeyComp('on') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func32: TtkTokenKind;
begin
  if KeyComp('Label') then
    Result := tkKey
  else if KeyComp('Mod') then
    Result := tkKey
  else if KeyComp('File') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func33: TtkTokenKind;
begin
  if KeyComp('Or') then
    Result := tkKey
  else if KeyComp('Asm') then
  begin
    Result := tkKey;
    fRange := rsAsm;
    fAsmStart := True;
  end
  else if (fRange = rsExports) and KeyComp('name') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func35: TtkTokenKind;
begin
  if KeyComp('Nil') then
    Result := tkKey
  else if KeyComp('To') then
    Result := tkKey
  else if KeyComp('Div') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func37: TtkTokenKind;
begin
  if KeyComp('Begin') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func38: TtkTokenKind;
begin
  if KeyComp('Near') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func39: TtkTokenKind;
begin
  if KeyComp('For') then
    Result := tkKey
  else if KeyComp('Shl') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func40: TtkTokenKind;
begin
  if KeyComp('Packed') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func41: TtkTokenKind;
begin
  if KeyComp('Else') then
    Result := tkKey
  else if KeyComp('Var') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func44: TtkTokenKind;
begin
  if KeyComp('Set') then
    Result := tkKey
  else if PackageSource and KeyComp('package') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func45: TtkTokenKind;
begin
  if KeyComp('Shr') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func47: TtkTokenKind;
begin
  if KeyComp('Then') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func49: TtkTokenKind;
begin
  if KeyComp('Not') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func52: TtkTokenKind;
begin
  if KeyComp('Pascal') then
    Result := tkKey
  else if KeyComp('Raise') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func54: TtkTokenKind;
begin
  if KeyComp('Class') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func55: TtkTokenKind;
begin
  if KeyComp('Object') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func56: TtkTokenKind;
begin
  if (fRange in [rsProperty, rsExports]) and KeyComp('Index') then
    Result := tkKey
  else if KeyComp('Out') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;


function TVMHPasHighlighter.Func57: TtkTokenKind;
begin
  if KeyComp('Goto') then
    Result := tkKey
  else if KeyComp('While') then
    Result := tkKey
  else if KeyComp('Xor') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func59: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Safecall') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func60: TtkTokenKind;
begin
  if KeyComp('With') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func61: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Dispid') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func63: TtkTokenKind;
begin
  if KeyComp('Public') then
    Result := tkKey
  else if KeyComp('Record') then
    Result := tkKey
  else if KeyComp('Array') then
    Result := tkKey
  else if KeyComp('Try') then
    Result := tkKey
  else if KeyComp('Inline') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func64: TtkTokenKind;
begin
  if KeyComp('Unit') then
    Result := tkKey
  else if KeyComp('Uses') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func65: TtkTokenKind;
begin
  if KeyComp('Repeat') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func66: TtkTokenKind;
begin
  if KeyComp('Type') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func69: TtkTokenKind;
begin
  if KeyComp('Default') then
    Result := tkKey
  else if KeyComp('Dynamic') then
    Result := tkKey
  else if KeyComp('Message') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func71: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi2) and KeyComp('Stdcall') then
    Result := tkKey
  else if KeyComp('Const') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func73: TtkTokenKind;
begin
  if KeyComp('Except') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func75: TtkTokenKind;
begin
  if (fRange = rsProperty) and KeyComp('Write') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func76: TtkTokenKind;
begin
  if KeyComp('Until') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func79: TtkTokenKind;
begin
  if KeyComp('Finally') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func81: TtkTokenKind;
begin
  if (fRange = rsProperty) and KeyComp('Stored') then
    Result := tkKey
  else if KeyComp('Interface') then
    Result := tkKey
  else if (DelphiVersion >= dvDelphi6) and KeyComp('deprecated') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func84: TtkTokenKind;
begin
  if KeyComp('Abstract') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func85: TtkTokenKind;
begin
  if KeyComp('Forward') then
    Result := tkKey
  else if KeyComp('Library') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func87: TtkTokenKind;
begin
  if KeyComp('String') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func88: TtkTokenKind;
begin
  if KeyComp('Program') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func91: TtkTokenKind;
begin
  if KeyComp('Downto') then
    Result := tkKey
  else if KeyComp('Private') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func92: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi4) and KeyComp('overload') then
    Result := tkKey
  else if KeyComp('Inherited') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func94: TtkTokenKind;
begin
  if KeyComp('Assembler') then
    Result := tkKey
  else if (DelphiVersion >= dvDelphi3) and (fRange = rsProperty) and KeyComp('Readonly') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func95: TtkTokenKind;
begin
  if KeyComp('Absolute') then
    Result := tkKey
  else if PackageSource and KeyComp('contains') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func96: TtkTokenKind;
begin
  if KeyComp('Published') then
    Result := tkKey
  else if KeyComp('Override') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func97: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Threadvar') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func98: TtkTokenKind;
begin
  if KeyComp('Export') then
    Result := tkKey
  else if (fRange = rsProperty) and KeyComp('Nodefault') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func99: TtkTokenKind;
begin
  if KeyComp('External') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func100: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Automated') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func101: TtkTokenKind;
begin
  if KeyComp('Register') then
    Result := tkKey
  else if (DelphiVersion >= dvDelphi6) and KeyComp('platform') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func102: TtkTokenKind;
begin
  if KeyComp('Function') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func103: TtkTokenKind;
begin
  if KeyComp('Virtual') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func105: TtkTokenKind;
begin
  if KeyComp('Procedure') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func106: TtkTokenKind;
begin
  if KeyComp('Protected') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func112: TtkTokenKind;
begin
  if PackageSource and KeyComp('requires') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func117: TtkTokenKind;
begin
  if KeyComp('Exports') then
  begin
    Result := tkKey;
    fRange := rsExports;
  end
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func126: TtkTokenKind;
begin
  if (fRange = rsProperty) and (DelphiVersion >= dvDelphi4) and KeyComp('Implements') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func129: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Dispinterface') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func132: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi4) and KeyComp('Reintroduce') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func133: TtkTokenKind;
begin
  if KeyComp('Property') then
  begin
    Result := tkKey;
    fRange := rsProperty;
  end
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func136: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi2) and KeyComp('Finalization') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;


function TVMHPasHighlighter.Func141: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and (fRange = rsProperty) and KeyComp('Writeonly') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func143: TtkTokenKind;
begin
  if KeyComp('Destructor') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func166: TtkTokenKind;
begin
  if KeyComp('Constructor') then
    Result := tkKey
  else if KeyComp('Implementation') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func168: TtkTokenKind;
begin
  if KeyComp('Initialization') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.Func191: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Resourcestring') then
    Result := tkKey
  else if (DelphiVersion >= dvDelphi3) and KeyComp('Stringresource') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TVMHPasHighlighter.AltFunc: TtkTokenKind;
begin
  Result := tkIdentifier
end;

function TVMHPasHighlighter.IdentKind(MayBe: PChar): TtkTokenKind;
var
  HashKey: Integer;
begin
  fToIdent := MayBe;
  HashKey := KeyHash(MayBe);
  if HashKey < 192 then Result := fIdentFuncTable[HashKey] else
    Result := tkIdentifier;
end;

procedure TVMHPasHighlighter.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #0: fProcTable[I] := NullProc;
      #10: fProcTable[I] := LFProc;
      #13: fProcTable[I] := CRProc;
      #1..#9, #11, #12, #14..#32:
        fProcTable[I] := SpaceProc;
      '#': fProcTable[I] := AsciiCharProc;
      '$': fProcTable[I] := IntegerProc;
      #39: fProcTable[I] := StringProc;
      '0'..'9': fProcTable[I] := NumberProc;
      'A'..'Z', 'a'..'z', '_':
        fProcTable[I] := IdentProc;
      '{': fProcTable[I] := BraceOpenProc;
      '}', '!', '"', '%', '&', '('..'/', ':'..'@', '['..'^', '`', '~':
        begin
          case I of
            '(': fProcTable[I] := RoundOpenProc;
            '.': fProcTable[I] := PointProc;
            ';': fProcTable[I] := SemicolonProc;                                //mh 2000-10-08
            '/': fProcTable[I] := SlashProc;
            ':', '>': fProcTable[I] := ColonOrGreaterProc;
            '<': fProcTable[I] := LowerProc;
            '@': fProcTable[I] := AddressOpProc;
          else
            fProcTable[I] := SymbolProc;
          end;
        end;
    else
      fProcTable[I] := UnknownProc;
    end;
end;

function NewVMHPasHighlighter(AOwner: PControl): PVMHPasHighlighter;
begin
  New(Result, Create);
//  AOwner.Add2AutoFree(Result);
  Result.fWordBreakChars := TSynWordBreakChars;
  Result.fAttributes := NewStrListEx;
  Result.fAttrChangeHooks := NewList;
  Result.fEnabled := True;
  Result.fD4syntax := True;
  Result.fDelphiVersion := LastDelphiVersion;
  Result.fPackageSource := True;

  Result.fAsmAttri := NewHighlighterAttributes(SYNS_AttrAssembler);
  Result.AddAttribute(Result.fAsmAttri);
  Result.fCommentAttri := NewHighlighterAttributes(SYNS_AttrComment);
  Result.fCommentAttri.Style:= [fsItalic];
  Result.AddAttribute(Result.fCommentAttri);
  Result.fDirecAttri := NewHighlighterAttributes(SYNS_AttrPreprocessor);
  Result.fDirecAttri.Style:= [fsItalic];
  Result.AddAttribute(Result.fDirecAttri);
  Result.fIdentifierAttri := NewHighlighterAttributes(SYNS_AttrIdentifier);
  Result.AddAttribute(Result.fIdentifierAttri);
  Result.fKeyAttri := NewHighlighterAttributes(SYNS_AttrReservedWord);
  Result.fKeyAttri.Style:= [fsBold];
  Result.AddAttribute(Result.fKeyAttri);
  Result.fNumberAttri := NewHighlighterAttributes(SYNS_AttrNumber);
  Result.AddAttribute(Result.fNumberAttri);
  Result.fFloatAttri := NewHighlighterAttributes(SYNS_AttrFloat);
  Result.AddAttribute(Result.fFloatAttri);
  Result.fHexAttri := NewHighlighterAttributes(SYNS_AttrHexadecimal);
  Result.AddAttribute(Result.fHexAttri);
  Result.fSpaceAttri := NewHighlighterAttributes(SYNS_AttrSpace);
  Result.AddAttribute(Result.fSpaceAttri);
  Result.fStringAttri := NewHighlighterAttributes(SYNS_AttrString);
  Result.AddAttribute(Result.fStringAttri);
  Result.fCharAttri := NewHighlighterAttributes(SYNS_AttrCharacter);
  Result.AddAttribute(Result.fCharAttri);
  Result.fSymbolAttri := NewHighlighterAttributes(SYNS_AttrSymbol);
  Result.AddAttribute(Result.fSymbolAttri);
  Result.SetAttributesOnChange(Result.DefHighlightChange);

  Result.InitIdent;
  Result.MakeMethodTables;
  Result.fRange := rsUnknown;
  Result.fAsmStart := False;
  Result.fDefaultFilter := SYNS_FilterPascal;
end; { Create }

procedure TVMHPasHighlighter.SetLine(NewValue: string; LineNumber:Integer);
begin
  fLine := PChar(NewValue);
  Run := 0;
  fLineNumber := LineNumber;
  Next;
end; { SetLine }

procedure TVMHPasHighlighter.AddressOpProc;
begin
  fTokenID := tkSymbol;
  inc(Run);
  if fLine[Run] = '@' then inc(Run);
end;

procedure TVMHPasHighlighter.AsciiCharProc;
begin
  fTokenID := tkChar;
  Inc(Run);
  while FLine[Run] in ['0'..'9', '$', 'A'..'F', 'a'..'f'] do
    Inc(Run);
end;

procedure TVMHPasHighlighter.BorProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      if fLine[Succ(Run)] = '$' then
        fTokenID := tkDirec
      else
        fTokenID := tkComment;
      repeat
        if fLine[Run] = '}' then
        begin
          Inc(Run);
          if fRange = rsBorAsm then
            fRange := rsAsm
          else
            fRange := rsUnKnown;
          break;
        end;
        Inc(Run);
      until fLine[Run] in [#0, #10, #13];
    end;
  end;
end;

procedure TVMHPasHighlighter.BraceOpenProc;
begin
  if fRange = rsAsm then
    fRange := rsBorAsm
  else
    fRange := rsBor;
  BorProc;
end;

procedure TVMHPasHighlighter.ColonOrGreaterProc;
begin
  fTokenID := tkSymbol;
  inc(Run);
  if fLine[Run] = '=' then inc(Run);
end;

procedure TVMHPasHighlighter.CRProc;
begin
  fTokenID := tkSpace;
  inc(Run);
  if fLine[Run] = #10 then
    Inc(Run);
end; { CRProc }


procedure TVMHPasHighlighter.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do
    Inc(Run);
end; { IdentProc }


procedure TVMHPasHighlighter.IntegerProc;
begin
  inc(Run);
  fTokenID := tkHex;
  while FLine[Run] in ['0'..'9', 'A'..'F', 'a'..'f'] do
    Inc(Run);
end; { IntegerProc }


procedure TVMHPasHighlighter.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end; { LFProc }


procedure TVMHPasHighlighter.LowerProc;
begin
  fTokenID := tkSymbol;
  inc(Run);
  if fLine[Run] in ['=', '>'] then
    Inc(Run);
end; { LowerProc }


procedure TVMHPasHighlighter.NullProc;
begin
  fTokenID := tkNull;
end; { NullProc }

procedure TVMHPasHighlighter.NumberProc;
begin
  Inc(Run);
  fTokenID := tkNumber;
  while FLine[Run] in ['0'..'9', '.', 'e', 'E', '-', '+'] do
  begin
    case FLine[Run] of
      '.':
        if FLine[Run + 1] = '.' then
          Break
        else
          fTokenID := tkFloat;
      'e', 'E': fTokenID := tkFloat;
      '-', '+':
        begin
          if fTokenID <> tkFloat then // arithmetic
            Break;
          if not (FLine[Run - 1] in ['e', 'E']) then
            Break; //float, but it ends here
        end;
    end;
    Inc(Run);
  end;
end; { NumberProc }

procedure TVMHPasHighlighter.PointProc;
begin
  fTokenID := tkSymbol;
  inc(Run);
  if fLine[Run] in ['.', ')'] then
    Inc(Run);
end; { PointProc }

procedure TVMHPasHighlighter.AnsiProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    fTokenID := tkComment;
    repeat
      if (fLine[Run] = '*') and (fLine[Run + 1] = ')') then begin
        Inc(Run, 2);
        if fRange = rsAnsiAsm then
          fRange := rsAsm
        else
          fRange := rsUnKnown;
        break;
      end;
      Inc(Run);
    until fLine[Run] in [#0, #10, #13];
  end;
end;


procedure TVMHPasHighlighter.RoundOpenProc;
begin
  Inc(Run);
  case fLine[Run] of
    '*':
      begin
        Inc(Run);
        if fRange = rsAsm then
          fRange := rsAnsiAsm
        else
          fRange := rsAnsi;
        fTokenID := tkComment;
        if not (fLine[Run] in [#0, #10, #13]) then
          AnsiProc;
      end;
    '.':
      begin
        inc(Run);
        fTokenID := tkSymbol;
      end;
  else
    fTokenID := tkSymbol;
  end;
end;

{begin}                                                                         //mh 2000-10-08
procedure TVMHPasHighlighter.SemicolonProc;
begin
  Inc(Run);
  fTokenID := tkSymbol;
  if fRange in [rsProperty, rsExports] then                                     //pp 2001-14-08
    fRange := rsUnknown;
end;
{end}                                                                           //mh 2000-10-08

procedure TVMHPasHighlighter.SlashProc;
begin
  Inc(Run);
  if (fLine[Run] = '/') and (fDelphiVersion > dvDelphi1) then                   //pp 2001-14-08
  begin
    fTokenID := tkComment;
    repeat
      Inc(Run);
    until fLine[Run] in [#0, #10, #13];
  end
  else
    fTokenID := tkSymbol;
end;

procedure TVMHPasHighlighter.SpaceProc;
begin
  inc(Run);
  fTokenID := tkSpace;
  while FLine[Run] in [#1..#9, #11, #12, #14..#32] do inc(Run);
end;

procedure TVMHPasHighlighter.StringProc;
begin
  fTokenID := tkString;
  Inc(Run);
  while not (fLine[Run] in [#0, #10, #13]) do begin
    if fLine[Run] = #39 then begin
      Inc(Run);
      if fLine[Run] <> #39 then
        break;
    end;
    Inc(Run);
  end;
end;

procedure TVMHPasHighlighter.SymbolProc;
begin
  inc(Run);
  fTokenID := tkSymbol;
end;

procedure TVMHPasHighlighter.UnknownProc;
begin
  inc(Run);
  fTokenID := tkUnknown;
end;

procedure TVMHPasHighlighter.Next;
begin
  fAsmStart := False;
  fTokenPos := Run;
  case fRange of
    rsAnsi, rsAnsiAsm:
      AnsiProc;
    rsBor, rsBorAsm:
      BorProc;
  else
    fProcTable[fLine[Run]];
  end;
end;

function TVMHPasHighlighter.GetDefaultAttribute(Index: integer):
  PHighlighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_STRING: Result := fStringAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
    SYN_ATTR_SYMBOL: Result := fSymbolAttri;
  else
    Result := nil;
  end;
end;

function TVMHPasHighlighter.GetEol: Boolean;
begin
  Result := fTokenID = tkNull;
end;

function TVMHPasHighlighter.GetToken: string;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

function TVMHPasHighlighter.GetTokenID: TtkTokenKind;
begin
  if not fAsmStart and (fRange = rsAsm)
    and not (fTokenId in [tkNull, tkComment, tkSpace])
  then
    Result := tkAsm
  else
    Result := fTokenId;
end;

function TVMHPasHighlighter.GetTokenAttribute: PHighlighterAttributes;
begin
  case GetTokenID of
    tkAsm: Result := fAsmAttri;
    tkComment: Result := fCommentAttri;
    tkDirec: Result := fDirecAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNumber: Result := fNumberAttri;
    tkFloat: Result := fFloatAttri;
    tkHex: Result := fHexAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkChar: Result := fCharAttri;
    tkSymbol: Result := fSymbolAttri;
    tkUnknown: Result := fSymbolAttri;
  else
    Result := nil;
  end;
end;

function TVMHPasHighlighter.GetTokenKind: integer;
begin
  Result := Ord(GetTokenID);
end;

function TVMHPasHighlighter.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

function TVMHPasHighlighter.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

procedure TVMHPasHighlighter.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

procedure TVMHPasHighlighter.ResetRange;
begin
  fRange:= rsUnknown;
end;

procedure TVMHPasHighlighter.EnumUserSettings(settings: PStrList);
var Key : HKEY;
begin
  { returns the user settings that exist in the registry }
  Key := HKEY_LOCAL_MACHINE;
  Key := RegKeyOpenRead(Key, 'SOFTWARE\Borland\Delphi');
  if Key <> 0 then
  begin
    RegKeyGetSubKeys(Key, settings);
    RegCloseKey(Key);
  end;
end;

function TVMHPasHighlighter.UseUserSettings(settingIndex: integer): boolean;
// Possible parameter values:
//   index into TStrings returned by EnumUserSettings
// Possible return values:
//   true : settings were read and used
//   false: problem reading settings or invalid version specified - old settings
//          were preserved

  function ReadDelphiSettings(settingIndex: integer): boolean;

    function ReadDelphiSetting(settingTag: string; attri: PHighlighterAttributes; key: string): boolean;

      function ReadDelphi2Or3(settingTag: string; attri: PHighlighterAttributes; name: string): boolean;
      var
        i: integer;
      begin
        for i := 1 to Length(name) do
          if name[i] = ' ' then name[i] := '_';
        Result := attri.LoadFromBorlandRegistry(HKEY_CURRENT_USER,
                'Software\Borland\Delphi\'+settingTag+'\Highlight',name,true);
      end; { ReadDelphi2Or3 }

      function ReadDelphi4OrMore(settingTag: string; attri: PHighlighterAttributes; key: string): boolean;
      begin
        Result := attri.LoadFromBorlandRegistry(HKEY_CURRENT_USER,
               'Software\Borland\Delphi\'+settingTag+'\Editor\Highlight',key,false);
      end; { ReadDelphi4OrMore }

    begin { ReadDelphiSetting }
      try
        if (settingTag[1] = '2') or (settingTag[1] = '3')
          then Result := ReadDelphi2Or3(settingTag,attri,key)
          else Result := ReadDelphi4OrMore(settingTag,attri,key);
      except Result := false; end;
    end; { ReadDelphiSetting }

  var
    tmpStringAttri    : PHighlighterAttributes;
    tmpNumberAttri    : PHighlighterAttributes;
    tmpKeyAttri       : PHighlighterAttributes;
    tmpSymbolAttri    : PHighlighterAttributes;
    tmpAsmAttri       : PHighlighterAttributes;
    tmpCommentAttri   : PHighlighterAttributes;
    tmpIdentifierAttri: PHighlighterAttributes;
    tmpSpaceAttri     : PHighlighterAttributes;
    tmpCharAttri      : PHighlighterAttributes;
    tmpHexAttri       : PHighlighterAttributes;
    tmpFloatAttri     : PHighlighterAttributes;
    s                 : PStrList;

  begin { ReadDelphiSettings }
    s := NewStrList;
    try
      EnumUserSettings(s);
      if (settingIndex < 0) or (settingIndex >= s.Count) then Result := false
      else begin
        tmpStringAttri    := NewHighlighterAttributes('');
        tmpNumberAttri    := NewHighlighterAttributes('');
        tmpKeyAttri       := NewHighlighterAttributes('');
        tmpSymbolAttri    := NewHighlighterAttributes('');
        tmpAsmAttri       := NewHighlighterAttributes('');
        tmpIdentifierAttri:= NewHighlighterAttributes('');
        tmpSpaceAttri     := NewHighlighterAttributes('');
        tmpCommentAttri   := NewHighlighterAttributes('');
        tmpCharAttri      := NewHighlighterAttributes('');
        tmpHexAttri       := NewHighlighterAttributes('');
        tmpFloatAttri     := NewHighlighterAttributes('');
        tmpStringAttri    .Assign(fStringAttri);
        tmpNumberAttri    .Assign(fNumberAttri);
        tmpKeyAttri       .Assign(fKeyAttri);
        tmpSymbolAttri    .Assign(fSymbolAttri);
        tmpAsmAttri       .Assign(fAsmAttri);
        tmpCommentAttri   .Assign(fCommentAttri);
        tmpIdentifierAttri.Assign(fIdentifierAttri);
        tmpSpaceAttri     .Assign(fSpaceAttri);
        tmpCharAttri      .Assign(fCharAttri);
        tmpHexAttri       .Assign(fHexAttri);
        tmpFloatAttri     .Assign(fFloatAttri);
        Result := ReadDelphiSetting(s.Items[settingIndex],fAsmAttri,'Assembler')         and
                  ReadDelphiSetting(s.Items[settingIndex],fCommentAttri,'Comment')       and
                  ReadDelphiSetting(s.Items[settingIndex],fIdentifierAttri,'Identifier') and
                  ReadDelphiSetting(s.Items[settingIndex],fKeyAttri,'Reserved word')     and
                  ReadDelphiSetting(s.Items[settingIndex],fNumberAttri,'Number')         and
                  ReadDelphiSetting(s.Items[settingIndex],fSpaceAttri,'Whitespace')      and
                  ReadDelphiSetting(s.Items[settingIndex],fStringAttri,'String')         and
                  ReadDelphiSetting(s.Items[settingIndex],fCharAttri,'Character')        and
                  ReadDelphiSetting(s.Items[settingIndex],fHexAttri,'Hex')               and
                  ReadDelphiSetting(s.Items[settingIndex],fFloatAttri,'Float')           and
                  ReadDelphiSetting(s.Items[settingIndex],fSymbolAttri,'Symbol');
        fDirecAttri := fCommentAttri;
        if not Result then
        begin
          fStringAttri.Assign(tmpStringAttri);
          {fCharAttri.Foreground := tmpStringAttri.Foreground; // Delphi lacks #xx support
          fCharAttri.Background := tmpStringAttri.Background;
          fCharAttri.Style := tmpStringAttri.Style;}
          fCharAttri.Assign(tmpCharAttri);
          fNumberAttri.Assign(tmpNumberAttri);
          {fFloatAttri.Foreground := tmpNumberAttri.Foreground; // Delphi lacks float/hex support
          fFloatAttri.Background := tmpNumberAttri.Background;
          fFloatAttri.Style := tmpNumberAttri.Style;
          fHexAttri.Foreground := tmpNumberAttri.Foreground;
          fHexAttri.Background := tmpNumberAttri.Background;
          fHexAttri.Style := tmpNumberAttri.Style;}
          fFloatAttri.Assign(tmpFloatAttri);
          fHexAttri.Assign(tmpHexAttri);
          fKeyAttri.Assign(tmpKeyAttri);
          fSymbolAttri.Assign(tmpSymbolAttri);
          fAsmAttri.Assign(tmpAsmAttri);
          fCommentAttri.Assign(tmpCommentAttri);
          fDirecAttri.Foreground := tmpCommentAttri.Foreground; // Delphi lacks directive support
          fDirecAttri.Background := tmpCommentAttri.Background;
          fDirecAttri.Style := tmpCommentAttri.Style;
          fIdentifierAttri.Assign(tmpIdentifierAttri);
          fSpaceAttri.Assign(tmpSpaceAttri);
        end;
        tmpStringAttri    .Free;
        tmpNumberAttri    .Free;
        tmpKeyAttri       .Free;
        tmpSymbolAttri    .Free;
        tmpAsmAttri       .Free;
        tmpCommentAttri   .Free;
        tmpIdentifierAttri.Free;
        tmpSpaceAttri     .Free;
        tmpCharAttri      .Free;
        tmpHexAttri       .Free;
        tmpFloatAttri     .Free;
      end;
    finally s.Free; end;
  end; { ReadDelphiSettings }

begin
{$IFNDEF SYN_CLX}//js 07-04-2002 changed from SYN_KYLIX to SYN_CLX
  Result := ReadDelphiSettings(settingIndex);
{$ELSE}
  Result := False;
{$ENDIF}
end; { TVMHPasHighlighter.UseUserSettings }

function TVMHPasHighlighter.GetIdentChars: TSynIdentChars;
begin
  Result := TSynValidStringChars;
end;

function TVMHPasHighlighter.GetSampleSource: string;                                    //pp 2001-08-13
begin
  Result := '{ Syntax highlighting }'#13#10 +
             'procedure TForm1.Button1Click(Sender: TObject);'#13#10 +
             'var'#13#10 +
             '  Number, I, X: Integer;'#13#10 +
             'begin'#13#10 +
             '  Number := 123456;'#13#10 +
             '  Caption := ''The Number is'' + #32 + IntToStr(Number);'#13#10 +
             '  for I := 0 to Number do'#13#10 +
             '  begin'#13#10 +
             '    Inc(X);'#13#10 +
             '    Dec(X);'#13#10 +
             '    X := X + 1.0;'#13#10 +
             '    X := X - $5E;'#13#10 +
             '  end;'#13#10 +
             '  {$R+}'#13#10 +
             '  asm'#13#10 +
             '    mov AX, 1234H'#13#10 +
             '    mov Number, AX'#13#10 +
             '  end;'#13#10 +
             '  {$R-}'#13#10 +
             'end;';
end; { GetSampleSource }


function TVMHPasHighlighter.GetLanguageName: string;
begin
  Result := SYNS_LangPascal;
end;

function TVMHPasHighlighter.GetCapabilities: THighlighterCapabilities;
begin
  Result := inherited GetCapabilities + [hcUserSettings];
end;

{begin}                                                                         //mh 2000-10-08
function TVMHPasHighlighter.IsFilterStored: boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterPascal;
end;
{end}                                                                           //mh 2000-10-08


procedure TVMHPasHighlighter.SetD4syntax(const Value: boolean);                         //pp 2001-08-14
begin
  
end;


procedure TVMHPasHighlighter.SetDelphiVersion(const Value: TDelphiVersion);             //pp 2001-08-14
begin
  fDelphiVersion := Value;
  fD4Syntax := fDelphiVersion >= dvDelphi4;
  if (fDelphiVersion < dvDelphi3) and fPackageSource then
    fPackageSource := False;
end;


procedure TVMHPasHighlighter.SetPackageSource(const Value: Boolean);                    //pp 2001-08-14
begin
  fPackageSource := Value;
  if fPackageSource and (fDelphiVersion < dvDelphi3) then
    fDelphiVersion := dvDelphi3;
end;


initialization
  MakeIdentTable;
//  RegisterPlaceableHighlighter(TVMHPasHighlighter);
end.

