unit MCKMHVersionInfo;
//  MHVersionInfo Компонент (MHVersionInfo Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 14-мар(mar)-2002
//  Дата коррекции (Last correction Date): 25-мар(mar)-2003
//  Версия (Version): 1.11
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Lee Vang
//    Alexander Pravdin 
//  Новое в (New in):
//  V1.11
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V1.1
//  [+] Поддержка D6 (D6 Support) <Thanks to Alexander Pravdin> [KOLnMCK]
//
//  V1.0
//  [+] Константы FileSubType (FileSubType consts) [MCK]
//  [N] Хммм... Релиз (Hmmm... Release)
//
//  V0.99
//  [+] Редактор CodePage (CodePage editor) [MCK]
//  [+] Константы CodePage (CodePage consts) [MCK]
//  [*] Уникальное имя ресурса (Uni Resource Name) [MCK]
//
//  V0.955
//  Add Language consts
//  V0.952
//  Brazil - England 2:1 !!!
//  +Add Language Property Editor
//  V0.951
//  +Add Minimize KOL part
//  V0.95
//  +Add Multi-Languages
//  +Add CodePage
//  +Add File Sub Type
//  V0.9
//  +Add Language Infos
//  +Add Create Defaults
//  V0.2
//  +Add Template
//  +Add Minor,Major,Release,Build
//  +Add OS Type
//  +Add FileFlags
//  +Add FileType
//
//  Список дел (To-Do list):
//  1. Оптимизировать (Optimize)
//  2. Подчистить (Clear Stuff)
//  3. XP должен быть один на проект (XP in Project must be ONE)
//  4. Удобные константы (Another Types (as a consts) - make them pretty to use (E.g. FileSubType))
//  5. Поддержка многих строк (C-Line/MultiLine Convert)
//  6. Переименуй Private Build (Rename Private Build)
//  7. Переименуй Special Build (Rename Special Build)
//  8. Нормальное обновление (Good Updata)
//  9. Добавь страндартный язык при создании (Add Default Language on Create)

interface

{$I KOLDEF.INC}

uses
  KOL, KOLMHVersionInfo, mirror, mckObjs, Classes, Graphics,Windows,Forms,ComCtrls,SysUtils,
    {$IFDEF _D6orHigher}
    // Delphi 6 Support
    DesignIntf, DesignEditors, DesignConst, Variants
  {$ELSE}
    DsgnIntf
  {$ENDIF};

const
  // File Sub Type
  VFT2_UNKNOWN=0;
  VFT2_FONT_RASTER=1;
  VFT2_FONT_VECTOR=2;
  VFT2_FONT_TRUETYPE=3;

  VFT2_DRV_PRINTER=1;
  VFT2_DRV_KEYBOARD=2;
  VFT2_DRV_LANGUAGE=3;
  VFT2_DRV_DISPLAY=4;
  VFT2_DRV_MOUSE=5;
  VFT2_DRV_NETWORK=6;
  VFT2_DRV_SYSTEM=7;
  VFT2_DRV_INSTALLABLE=8;
  VFT2_DRV_SOUND=9;
  VFT2_DRV_COMM=10;

  FileSubTypeFont: array[0..3] of TIdentMapEntry = (
  (Value:VFT2_UNKNOWN; Name: 'VFT2_UNKNOWN'),
  (Value:VFT2_FONT_RASTER; Name: 'VFT2_FONT_RASTER'),
  (Value:VFT2_FONT_VECTOR; Name: 'VFT2_FONT_VECTOR'),
  (Value:VFT2_FONT_TRUETYPE; Name: 'VFT2_FONT_TRUETYPE')
  );

  FileSubTypeDRV: array[0..10] of TIdentMapEntry = (
  (Value:VFT2_UNKNOWN; Name: 'VFT2_UNKNOWN'),
  (Value:VFT2_DRV_PRINTER; Name: 'VFT2_DRV_PRINTER'),
  (Value:VFT2_DRV_KEYBOARD; Name: 'VFT2_DRV_KEYBOARD'),
  (Value:VFT2_DRV_LANGUAGE; Name: 'VFT2_DRV_LANGUAGE'),
  (Value:VFT2_DRV_DISPLAY; Name: 'VFT2_DRV_DISPLAY'),
  (Value:VFT2_DRV_MOUSE; Name: 'VFT2_DRV_MOUSE'),
  (Value:VFT2_DRV_NETWORK; Name: 'VFT2_DRV_NETWORK'),
  (Value:VFT2_DRV_SYSTEM; Name: 'VFT2_DRV_SYSTEM'),
  (Value:VFT2_DRV_INSTALLABLE; Name: 'VFT2_DRV_INSTALLABLE'),
  (Value:VFT2_DRV_SOUND; Name: 'VFT2_DRV_SOUND'),
  (Value:VFT2_DRV_COMM; Name: 'VFT2_DRV_COMM')
  );

  // Code Pages
  ASCII7=0;
  Unicode=$04B0;
  WinArabic=$04E8;
  WinCyrillic=$04E3;
  WinGreek=$04E5;
  WinHebrew=$04E7;
  WinJapanese=$03A4;
  WinKorean=$03B5;
  WinEastEurope=$04E2;
  WinMultiling=$04E4;
  WinTaiwanese=$3B6;
  WinTurkish=$04E6;

  CodePages: array[0..11] of TIdentMapEntry = (
  (Value:ASCII7; Name: 'ASCII 7'),
  (Value:Unicode; Name: 'Unicode'),
  (Value:WinArabic; Name: 'Windows arabic'),
  (Value:WinCyrillic; Name: 'Windows cyrillic'),
  (Value:WinGreek; Name: 'Windows greek'),
  (Value:WinHebrew; Name: 'Windows hebrew'),
  (Value:WinJapanese; Name: 'Windows japanese'),
  (Value:WinKorean; Name: 'Windows korean'),
  (Value:WinEastEurope; Name: 'Windows easteurope'),
  (Value:WinMultiling; Name: 'Windows multilingual'),
  (Value:WinTaiwanese; Name: 'Windows taiwanese'),
  (Value:WinTurkish; Name: 'Windows turkish'));


  // Languages
  Albanian=$041C;
  Arabic=$0401;
  Bahasa=$0421;
  BelgiumDut=$0813;
  BelgiumFre=$0813;
  BelgiumPor=$0416;
  Bulgarian=$0402;
  CanadaFre=$0C0C;
  CastilleSpa=$040A;
  Catalan=$0403;
  CroatianSerbianLat=$041A;
  Czech=$0405;
  Danish=$0406;
  Dutch=$0413;
  Finnish=$040B;
  French=$040C;
  German=$0407;
  Greek=$0408;
  Hebrew=$040D;
  Hungarian=$040E;
  Icelandic=$040F;
  Italian=$0410;
  Japanese=$0411;
  Korean=$0412;
  MexicanSpa=$080A;
  Nynorsk=$0814;
  Bokmal=$0414;
  Polish=$0415;
  Portuguese=$0816;
  RetroRomance=$0417;
  Roumanian=$0418;
  SerbianCroatianCyr=$081A;
  ChineseSim=$0804;
  Slovak=$041B;
  Swedish=$041D;
  SwissFre=$100C;
  SwissGer=$0807C;
  SwissIta=$0810C;
  Thai=$041E;
  ChineseTra=$0404;
  Turkish=$041F;
  Urdu=$0420;
  Russian=$0419;
  EnglishUK=$0809;
  EnglishAmer=$0409;

  Languages: array[0..44] of TIdentMapEntry = (
  (Value:  Albanian; Name: 'Albanian'),
  (Value:Arabic; Name: 'Arabic'),
  (Value:Bahasa; Name: 'Bahasa'),
  (Value:BelgiumDut; Name: 'Belgium (Dut)'),
  (Value:BelgiumFre; Name: 'Belgium (Fre)'),
  (Value:BelgiumPor; Name: 'Belgium (Por)'),
 (Value: Bulgarian; Name: 'Bulgarian'),
 (Value: CanadaFre; Name: 'Canada (Fre)'),
  (Value:CastilleSpa; Name: 'Castille (Spa)'),
  (Value:Catalan; Name: 'Catalan'),
  (Value:CroatianSerbianLat; Name: 'Croatian-Serbian (Lat)'),
 (Value: Czech; Name: 'Czech'),
 (Value: Danish; Name: 'Danish'),
 (Value: Dutch; Name: 'Dutch'),
 (Value: Finnish; Name: 'Finnish'),
 (Value: French; Name: 'French'),
 (Value: German; Name: 'German'),
 (Value: Greek; Name: 'Greek'),
 (Value: Hebrew; Name: 'Hebrew'),
 (Value: Hungarian; Name: 'Hungarian'),
 (Value: Icelandic; Name: 'Icelandic'),
  (Value:Italian; Name: 'Italian'),
 (Value: Japanese; Name: 'Japanese'),
 (Value: Korean; Name: 'Korean'),
 (Value: MexicanSpa; Name: 'Mexican (Spa)'),
 (Value: Nynorsk; Name: 'Nynorsk'),
 (Value: Bokmal; Name: 'Bokmal'),
  (Value:Polish; Name: 'Polish'),
 (Value: Portuguese; Name: 'Portuguese'),
  (Value:RetroRomance; Name: 'Retro Romance'),
  (Value:Roumanian; Name: 'Roumanian'),
  (Value:SerbianCroatianCyr; Name: 'Serbian-Croatian (Cyr)'),
  (Value:ChineseSim; Name: 'Chinese (Sim)'),
  (Value:Slovak; Name: 'Slovak'),
  (Value:Swedish; Name: 'Swedish'),
  (Value:SwissFre; Name: 'Swiss (Fre)'),
  (Value:SwissGer; Name: 'Swiss (Ger)'),
  (Value:SwissIta; Name: 'Swiss (Ita)'),
  (Value:Thai; Name: 'Thai'),
  (Value:ChineseTra; Name: 'Chinese (Tra)'),
  (Value:Turkish; Name: 'Turkish'),
  (Value:Urdu; Name: 'Urdu'),
    (Value: Russian; Name: 'Russian'),
    (Value: EnglishUK; Name: 'English (UK)'),
    (Value: EnglishAmer; Name: 'English (Amer)')
    );

type

  TLanguage=Integer;

  TLanguageProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  TCodePage=Integer;

  TCodePageProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  TKOLMHVersionInfo=class;
  TLangInfo = class(TCollectionItem)
  private
    FLanguage:TLanguage;
    FCodePage:TCodePage;
    FComments:String;
    FCompanyName:String;
    FFileDescription:String;
    FFileVersion:String;
    FInternalName:String;
    FLegalCopyRight:String;
    FLegalTrademarks:String;
    FOriginalFileName:String;
    FPrivateBuild:String;
    FProductName:String;
    FProductVersion:String;
    FSpecialBuild:String;
    procedure SetLanguage(const Value:TLanguage);
    procedure SetCodePage(const Value:TCodePage);
    procedure SetComments(const Value:String);
    procedure SetCompanyName(const Value:String);
    procedure SetFileDescription(const Value:String);
    procedure SetInternalName(const Value:String);
    procedure SetFileVersion(const Value:String);
    procedure SetLegalCopyRight(const Value:String);
    procedure SetLegalTrademarks(const Value:String);
    procedure SetOriginalFileName(const Value:String);
    procedure SetPrivateBuild(const Value:String);
    procedure SetProductName(const Value:String);
    procedure SetProductVersion(const Value:String);
    procedure SetSpecialBuild(const Value:String);
  protected
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Language:TLanguage read FLanguage write SetLanguage;
    property CodePage:TCodePage read FCodePage write SetCodePage;
    property Comments:String read FComments write SetComments;
    property CompanyName:String read FCompanyName write SetCompanyName;
    property FileDescription:String read FFileDescription write SetFileDescription;
    property FileVersion:String read FFileVersion write SetFileVersion;
    property InternalName:String read FInternalName write SetInternalName;
    property LegalCopyRight:String read FLegalCopyRight write SetLegalCopyRight;
    property LegalTrademarks:String read FLegalTrademarks write SetLegalTrademarks;
    property OriginalFileName:String read FOriginalFileName write SetOriginalFileName;
    property PrivateBuild:String read FPrivateBuild write SetPrivateBuild;
    property ProductName:String read FProductName write SetProductName;
    property ProductVersion:String read FProductVersion write SetProductVersion;
    property SpecialBuild:String read FSpecialBuild write SetSpecialBuild;
  end;

  TLangInfos = class(TCollection)
  private
    FKOLMHVersionInfo: TKOLMHVersionInfo;
    function GetItem(Index: Integer): TLangInfo;
    procedure SetItem(Index: Integer; Value: TLangInfo);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(KOLMHVersionInfo: TKOLMHVersionInfo);
    function Add: TLangInfo;
    property Items[Index: Integer]: TLangInfo read GetItem write SetItem; default;
  end;

  TOS=(VOS_UNKNOWN,VOS_DOS,VOS_OS216,VOS_OS232,VOS_NT,VOS_WINDOWS16,
  VOS_PM16,VOS_PM32,VOS_WINDOWS32,VOS_DOS_WINDOWS16,VOS_DOS_WINDOWS32,VOS_OS216_PM16,
  VOS_OS232_PM32,VOS_NT_WINDOWS32);

  TFileFlag=(VS_FF_DEBUG,VS_FF_PRELEASE,VS_FF_PATCHED,VS_FF_PRIVATEBUILD,
  VS_FF_INFOINFERRED,VS_FF_SPECIALBUILD);

  TFileFlags=set of TFileFlag;

  TFileType=(VFT_UNKNOWN,VFT_APP,VFT_DLL,VFT_DRV,VFT_FONT,VFT_VXD,VFT_STSTIC_LIB);

  TKOLMHVersionInfo = class(TKOLObj)
  private
     FMajorVersion:Word;
     FMinorVersion:Word;
     FRelease:Word;
     FBuild:Word;
     FOS:TOS;
     FFileFlags:TFileFlags;
     FFileType:TFileType;
     FFileSubType:Integer;
     FLangInfos:TLangInfos;
     procedure SetMajorVersion(const Value:Word);
     procedure SetMinorVersion(const Value:Word);
     procedure SetRelease(const Value:Word);
     procedure SetBuild(const Value:Word);
     procedure SetOS(const Value:TOS);
     procedure SetFileFlags(const Value:TFileFlags);
     procedure SetFileType(const Value:TFileType);
     procedure SetFileSubType(const Value:Integer);
     procedure SetLangInfos(Value: TLangInfos);
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName,AParent, Prefix: String); override;
    function NotAutoFree: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property MajorVersion:Word read FMajorVersion  write SetMajorVersion;
    property MinorVersion:Word read FMinorVersion write SetMinorVersion;
    property Release:Word read FRelease write SetRelease;
    property Build:Word read FBuild write SetBuild;
    property OS:TOS read FOS write SetOS;
    property FileFlags:TFileFlags read FFileFlags write SetFileFlags;
    property FileType:TFileType read FFileType write SetFileType;
    property FileSubType:Integer read FFileSubType write SetFileSubType;
    property LangInfos:TLangInfos read FLangInfos write SetLangInfos;
  end;

  procedure Register;

implementation

procedure GetCodePageValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  for I := Low(CodePages) to High(CodePages) do
    Proc(CodePages[I].Name);
end;

function IdentToCodePage(const Ident: string; var CodePage: Longint): Boolean;
begin
  Result := IdentToInt(Ident, CodePage, CodePages);
end;

function CodePageToIdent(CodePage: Longint; var Ident: string): Boolean;
begin
  Result := IntToIdent(CodePage, Ident, CodePages);
end;

function CodePageToString(CodePage: TCodePage): string;
begin
  if not CodePageToIdent(CodePage, Result) then
    Result:=IntToStr(CodePage);
//    FmtStr(Result, '%s%.4x', [HexDisplayPrefix, CodePage]);
end;

function TCodePageProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paDialog, paValueList, paRevertable];
end;

function TCodePageProperty.GetValue: string;
begin
  Result := CodePageToString(TCodePage(GetOrdValue));
end;

procedure TCodePageProperty.GetValues(Proc: TGetStrProc);
begin
  GetCodePageValues(Proc);
end;

procedure TCodePageProperty.SetValue(const Value: string);
var
  NewValue: Longint;
begin
  if IdentToCodePage(Value, NewValue) then
    SetOrdValue(NewValue)
  else
    inherited SetValue(Value);
end;

procedure GetLanguageValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  for I := Low(Languages) to High(Languages) do
    Proc(Languages[I].Name);
end;

function IdentToLanguage(const Ident: string; var Language: Longint): Boolean;
begin
  Result := IdentToInt(Ident, Language, Languages);
end;

function LanguageToIdent(Language: Longint; var Ident: string): Boolean;
begin
  Result := IntToIdent(Language, Ident, Languages);
end;

function LanguageToString(Language: TLanguage): string;
begin
  if not LanguageToIdent(Language, Result) then
    FmtStr(Result, '%s%.4x', [HexDisplayPrefix, Language]);
end;

function TLanguageProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paDialog, paValueList, paRevertable];
end;

function TLanguageProperty.GetValue: string;
begin
  Result := LanguageToString(TLanguage(GetOrdValue));
end;

procedure TLanguageProperty.GetValues(Proc: TGetStrProc);
begin
  GetLanguageValues(Proc);
end;

procedure TLanguageProperty.SetValue(const Value: string);
var
  NewValue: Longint;
begin
  if IdentToLanguage(Value, NewValue) then
    SetOrdValue(NewValue)
  else
    inherited SetValue(Value);
end;

constructor TLangInfo.Create(Collection: TCollection);
begin
  FLanguage:=Russian;
  FComments:='Comments';
  FCompanyName:='Your Company Name';
  FFileDescription:='File Description';
  FFileVersion:='1, 1, 1, 1';
  FInternalName:='Your Application Name ';
  FLegalCopyRight:='Copyright © 2002';
  FLegalTrademarks:='Your TradeMarks';
  FOriginalFileName:='File Name';
  FPrivateBuild:='Private Build';
  FProductName:='Your Product Name';
  FProductVersion:='1, 1, 1, 1';
  FSpecialBuild:='Special Build';
  inherited Create(Collection);
end;

procedure TLangInfo.Assign(Source: TPersistent);
begin
  if Source is TLangInfo then
  begin
    Comments:=TLangInfo(Source).Comments;
    Language:=TLangInfo(Source).Language;
    CompanyName:=TLangInfo(Source).CompanyName;
    FileDescription:=TLangInfo(Source).FileDescription;
    FileVersion:=TLangInfo(Source).FileVersion;
    InternalName:=TLangInfo(Source).InternalName;
    LegalCopyRight:=TLangInfo(Source).LegalCopyRight;
    LegalTrademarks:=TLangInfo(Source).LegalTrademarks;
    OriginalFileName:=TLangInfo(Source).OriginalFileName;
    PrivateBuild:=TLangInfo(Source).PrivateBuild;
    ProductName:=TLangInfo(Source).ProductName;
    ProductVersion:=TLangInfo(Source).ProductVersion;
    SpecialBuild:=TLangInfo(Source).SpecialBuild;
  end
  else inherited Assign(Source);
end;

procedure TLangInfo.SetLanguage(const Value:TLanguage);
begin
  if FLanguage<>Value then
  begin
    FLanguage:=Value;
  end;
end;

procedure TLangInfo.SetCodePage(const Value:TCodePage);
begin
  if FCodePage<>Value then
  begin
    FCodePage:=Value;
  end;
end;

procedure TLangInfo.SetComments(const Value:String);
begin
  if FComments<>Value then
  begin
    FComments:=Value;
  end;
end;

procedure TLangInfo.SetFileDescription(const Value:String);
begin
  if FFileDescription<>Value then
  begin
    FFileDescription:=Value;
  end;
end;

procedure TLangInfo.SetCompanyName(const Value:String);
begin
  if FCompanyName<>Value then
  begin
    FCompanyName:=Value;
  end;
end;

procedure TLangInfo.SetFileVersion(const Value:String);
begin
  if FFileVersion<>Value then
  begin
    FFileVersion:=Value;
  end;
end;

procedure TLangInfo.SetInternalName(const Value:String);
begin
  if FInternalName<>Value then
  begin
    FInternalName:=Value;
  end;
end;

procedure TLangInfo.SetLegalCopyRight(const Value:String);
begin
  if FLegalCopyRight<>Value then
  begin
    FLegalCopyRight:=Value;
  end;
end;

procedure TLangInfo.SetLegalTrademarks(const Value:String);
begin
  if FLegalTrademarks<>Value then
  begin
    FLegalTrademarks:=Value;
  end;
end;

procedure TLangInfo.SetOriginalFileName(const Value:String);
begin
  if FOriginalFileName<>Value then
  begin
    FOriginalFileName:=Value;
  end;
end;

procedure TLangInfo.SetPrivateBuild(const Value:String);
begin
  if FPrivateBuild<>Value then
  begin
    FPrivateBuild:=Value;
  end;
end;

procedure TLangInfo.SetProductName(const Value:String);
begin
  if FProductName<>Value then
  begin
    FProductName:=Value;
  end;
end;

procedure TLangInfo.SetProductVersion(const Value:String);
begin
  if FProductVersion<>Value then
  begin
    FProductVersion:=Value;
  end;
end;

procedure TLangInfo.SetSpecialBuild(const Value:String);
begin
  if FSpecialBuild<>Value then
  begin
    FSpecialBuild:=Value;
  end;
end;

constructor TLangInfos.Create(KOLMHVersionInfo: TKOLMHVersionInfo);
begin
  inherited Create(TLangInfo);
  FKOLMHVersionInfo:=KOLMHVersionInfo;
end;

function TLangInfos.Add:TLangInfo;
begin
  Result := TLangInfo(inherited Add);
  FKOLMHVersionInfo.Change;
end;

function TLangInfos.GetItem(Index: Integer): TLangInfo;
begin
  Result := TLangInfo(inherited GetItem(Index));
  FKOLMHVersionInfo.Change;
end;

function TLangInfos.GetOwner: TPersistent;
begin
  Result := FKOLMHVersionInfo;
end;

procedure TLangInfos.SetItem(Index: Integer; Value: TLangInfo);
begin
  inherited SetItem(Index, Value);
  FKOLMHVersionInfo.Change;
end;

{procedure TLangInfos.Update(Item: TCollectionItem);
begin
//  if Item <> nil then
//    FKOLMHVersionInfo.UpdatePanel(Item.Index, False) else
//    FKOLMHVersionInfo.UpdatePanels(True, False);
end;                  }

function FileType2Str(FileType:TFileType):String;
begin
  case FileType of
    VFT_UNKNOWN: Result:=Int2Str($0);
    VFT_APP: Result:=Int2Str($1);
    VFT_DLL: Result:=Int2Str($2);
    VFT_DRV: Result:=Int2Str($3);
    VFT_FONT: Result:=Int2Str($4);
    VFT_VXD: Result:=Int2Str($5);
    VFT_STSTIC_LIB: Result:=Int2Str($7);
  end;  //case
end;

function FileFlags2Str(FileFlags:TFileFlags):String;
var
  Flag:DWord;
begin
  Flag:=0;
  if VS_FF_DEBUG in FileFlags then
    Flag:=Flag or $01;
  if VS_FF_PRELEASE in FileFlags then
    Flag:=Flag or $02;
  if VS_FF_PATCHED in FileFlags then
    Flag:=Flag or $04;
  if VS_FF_PRIVATEBUILD in FileFlags then
    Flag:=Flag or $08;
  if VS_FF_INFOINFERRED in FileFlags then
    Flag:=Flag or $10;
  if VS_FF_SPECIALBUILD in FileFlags then
    Flag:=Flag or $20;
  Result:=Int2Str(Flag);
end;

function OS2Str(OS:TOS):String;
begin
  case OS of
    VOS_UNKNOWN: Result:=Int2Str($0);
    VOS_DOS: Result:=Int2Str($10000);
    VOS_OS216: Result:=Int2Str($20000);
    VOS_OS232: Result:=Int2Str($30000);
    VOS_NT: Result:=Int2Str(40000);
    VOS_WINDOWS16: Result:=Int2Str($1);
    VOS_PM16: Result:=Int2Str($2);
    VOS_PM32: Result:=Int2Str($3);
    VOS_WINDOWS32: Result:=Int2Str($4);
    VOS_DOS_WINDOWS16: Result:=Int2Str($10001);
    VOS_DOS_WINDOWS32: Result:=Int2Str($10004);
    VOS_OS216_PM16: Result:=Int2Str($20002);
    VOS_OS232_PM32: Result:=Int2Str($30003);
    VOS_NT_WINDOWS32: Result:=Int2Str($40004);
  end;  //case
end;

procedure GenerateVersionResource( MajorVersion,MinorVersion,Release,Build:Word; FileFlags:TFileFlags; OS:TOS; FileType:TFileType; FileSubType:Integer; LangInfos:TLangInfos;
const RsrcName, FileName: String;
          var Updated: Boolean );
var RL: TStringList;
    Buf1, Buf2: PChar;
    S: String;
    I, J: Integer;
    F: THandle;
    TranslationStr:String;
begin
  RL := TStringList.Create;
  {VS_VERSION_INFO}
  RL.Add( RsrcName+' VERSIONINFO' );
  RL.Add( 'FILEVERSION '+Int2Str(MajorVersion)+','+Int2Str(MinorVersion)+','+Int2Str(Release)+','+Int2Str(Build) );
  RL.Add( 'PRODUCTVERSION 1,0,0,1' );
  RL.Add( 'FILEFLAGSMASK 0x3fL' );
  RL.Add( 'FILEFLAGS '+FileFlags2Str(FileFlags) );
  RL.Add( 'FILEOS '+OS2Str(OS) );
  RL.Add( 'FILETYPE '+FileType2Str(FileType) );
  RL.Add( 'FILESUBTYPE '+Int2Str(FileSubType) );
  if LangInfos.Count<>0 then
  begin
    RL.Add( 'BEGIN' );
    RL.Add( '  BLOCK "StringFileInfo"' );
    RL.Add( '  BEGIN' );
  end;
  For i:=0 to LangInfos.Count-1 do
  begin
    with LangInfos[i] do
    begin
      RL.Add( '      BLOCK "'+Int2Hex(LangInfos[i].Language,4)+Int2Hex(LangInfos[i].CodePage,4)+'"' );
      RL.Add( '      BEGIN' );
      if Comments<>'' then
        RL.Add( '          VALUE "Comments", "'+Comments+'\0"' );
      if CompanyName<>'' then
        RL.Add( '          VALUE "CompanyName", "'+CompanyName+'\0"' );
      if FileDescription<>'' then
        RL.Add( '          VALUE "FileDescription", "'+FileDescription+'\0"' );
      if FileVersion<>'' then
        RL.Add( '          VALUE "FileVersion", "'+FileVersion+'\0"' );
      if InternalName<>'' then
        RL.Add( '          VALUE "InternalName", "'+InternalName+'\0"' );
      if LegalCopyright<>'' then
        RL.Add( '          VALUE "LegalCopyright", "'+LegalCopyright+'\0"' );
      if LegalTrademarks<>'' then
        RL.Add( '          VALUE "LegalTrademarks", "'+LegalTrademarks+'\0"' );
      if OriginalFilename<>'' then
        RL.Add( '          VALUE "OriginalFilename", "'+OriginalFilename+'\0"' );
      if PrivateBuild<>'' then
        RL.Add( '          VALUE "PrivateBuild", "'+PrivateBuild+'\0"' );
      if ProductName<>'' then
        RL.Add( '          VALUE "ProductName", "'+ProductName+'\0"' );
      if ProductVersion<>'' then
        RL.Add( '          VALUE "ProductVersion", "'+ProductVersion+'\0"' );
      if SpecialBuild<>'' then
        RL.Add( '          VALUE "SpecialBuild", "'+SpecialBuild+'\0"' );
      RL.Add( '      END' );
    end;
  end;
  if LangInfos.Count<>0 then
  begin
    RL.Add( '  END' );
    RL.Add( '  BLOCK "VarFileInfo"' );
    RL.Add( '  BEGIN' );
    TranslationStr:='';
    For i:=0 to LangInfos.Count-1 do
      TranslationStr:=TranslationStr+', '+Int2Str(LangInfos[i].Language)+', '+Int2Str(LangInfos[i].CodePage);
    RL.Add( '      VALUE "Translation"'+TranslationStr );
    RL.Add( '  END' );
    RL.Add( 'END' );
  end;


  RL.SaveToFile( ProjectSourcePath + FileName + '.rc' );
  RL.Free;
  Buf1 := nil;
  Buf2 := nil;
  I := 0; J := 0;
  S := ProjectSourcePath + FileName + '.res';
  if FileExists( S ) then
  begin
    I := FileSize( S );
    if I > 0 then
    begin
      GetMem( Buf1, I );
      F := KOL.FileCreate( S, ofOpenRead or ofShareDenyWrite or ofOpenExisting );
      if F <> THandle( -1 ) then
      begin
        KOL.FileRead( F, Buf1^, I );
        KOL.FileClose( F );
      end;
    end;
  end;
  ExecuteWait( ExtractFilePath( Application.ExeName ) + 'brcc32.exe',
  '"'+ProjectSourcePath + FileName + '.rc'+'"',ProjectSourcePath, SW_HIDE, INFINITE, nil );
  if FileExists( S ) then
  begin
    J := FileSize( S );
    if J > 0 then
    begin
      GetMem( Buf2, J );
      F := KOL.FileCreate( S, ofOpenRead or ofShareDenyWrite or ofOpenExisting );
      if F <> THandle( -1 ) then      begin
        KOL.FileRead( F, Buf2^, J );
        KOL.FileClose( F );
      end;
    end;
  end;
  if (Buf1 = nil) or (I <> J) or
     (Buf2 <> nil) and not CompareMem( Buf1, Buf2, J ) then
  begin
    Updated := TRUE;
  end;
  if Buf1 <> nil then FreeMem( Buf1 );
  if Buf2 <> nil then FreeMem( Buf2 );
end;

constructor TKOLMHVersionInfo.Create(AOwner: TComponent);
begin
  inherited;
  FLangInfos := TLangInfos.Create(Self);
  FMajorVersion:=1;
  FMinorVersion:=1;
  FRelease:=1;
  FBuild:=1;
  FOS:=VOS_WINDOWS32;
  FFileFlags:=[];
  FFileType:=VFT_APP;
end;

destructor TKOLMHVersionInfo.Destroy;
begin
  inherited;
end;

function TKOLMHVersionInfo.AdditionalUnits;
begin
  Result := ', KOLMHVersionInfo';
end;

procedure TKOLMHVersionInfo.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var RsrcName, RsrcFile: String;
begin
  RsrcName:=UpperCase(ParentKOLForm.FormName+'_'+Name);
  RsrcFile:=ParentKOLForm.FormName+'_'+Name;
  SL.Add( Prefix + '  {$R ' + RsrcFile + '.RES}' );
  GenerateVersionResource( FMajorVersion,FMinorVersion,FRelease,FBuild, FFileFlags,FOS,FFileType, FFileSubType, FLangInfos, RsrcName, RsrcFile, fUpdated );
end;

function TKOLMHVersionInfo.NotAutoFree: Boolean;
begin
  Result:=True;
end;

procedure TKOLMHVersionInfo.SetMajorVersion(const Value:Word);
begin
  FMajorVersion:=Value;
  Change;
end;

procedure TKOLMHVersionInfo.SetMinorVersion(const Value:Word);
begin
  FMinorVersion:=Value;
  Change;
end;

procedure TKOLMHVersionInfo.SetRelease(const Value:Word);
begin
  FRelease:=Value;
  Change;
end;

procedure TKOLMHVersionInfo.SetBuild(const Value:Word);
begin
  FBuild:=Value;
  Change;
end;

procedure TKOLMHVersionInfo.SetOS(const Value:TOS);
begin
  FOS:=Value;
  Change;
end;

procedure TKOLMHVersionInfo.SetFileFlags(const Value:TFileFlags);
begin
  FFileFlags:=Value;
  Change;
end;

procedure TKOLMHVersionInfo.SetFileType(const Value:TFileType);
begin
  FFileType:=Value;
  Change;
end;

procedure TKOLMHVersionInfo.SetFileSubType(const Value:Integer);
begin
  FFileSubType:=Value;
  Change;
end;

procedure TKOLMHVersionInfo.SetLangInfos(Value: TLangInfos);
begin
  FLangInfos.Assign(Value);
  Change;
end;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(Integer),TLangInfo,'Language',TLanguageProperty);
  RegisterPropertyEditor(TypeInfo(Integer),TLangInfo,'CodePage',TCodePageProperty);
  RegisterComponents('KOL Misc', [TKOLMHVersionInfo]);
end;

end.

