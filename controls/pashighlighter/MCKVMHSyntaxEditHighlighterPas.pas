unit MCKVMHSyntaxEditHighlighterPas;
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
  Windows{, Controls},Classes{, SysUtils}, mirror{, KOL, Graphics, MCKCtrls},MCKVMHSyntaxEditHighlighter,KOLVMHSyntaxEditHighlighterPas,Dialogs,Graphics;

type
  TKOLVMHPasHighlighter=class(TKOLVMHCustomHighlighter)
  private
    FAsmAttri: THighlighterAttributes;
    FCommentAttri: THighlighterAttributes;
    FDirectiveAttri: THighlighterAttributes;
    FIdentifierAttri: THighlighterAttributes;
    FKeyAttri: THighlighterAttributes;
    FNumberAttri: THighlighterAttributes;
    FFloatAttri: THighlighterAttributes;
    FHexAttri: THighlighterAttributes;
    FSpaceAttri: THighlighterAttributes;
    FStringAttri: THighlighterAttributes;
    FCharAttri: THighlighterAttributes;
    FSymbolAttri: THighlighterAttributes;
    FD4syntax: boolean;
    FDelphiVersion: TDelphiVersion;
    FPackageSource: Boolean;
    procedure SetAsmAttri(const Value: THighlighterAttributes);
    procedure SetCommentAttri(const Value: THighlighterAttributes);
    procedure SetDirectiveAttri(const Value: THighlighterAttributes);
    procedure SetIdentifierAttri(const Value: THighlighterAttributes);
    procedure SetKeyAttri(const Value: THighlighterAttributes);
    procedure SetNumberAttri(const Value: THighlighterAttributes);
    procedure SetFloatAttri(const Value: THighlighterAttributes);
    procedure SetHexAttri(const Value: THighlighterAttributes);
    procedure SetSpaceAttri(const Value: THighlighterAttributes);
    procedure SetStringAttri(const Value: THighlighterAttributes);
    procedure SetCharAttri(const Value: THighlighterAttributes);
    procedure SetSymbolAttri(const Value: THighlighterAttributes);
    procedure SetD4syntax(const Value: boolean);
    procedure SetDelphiVersion(const Value: TDelphiVersion);
    procedure SetPackageSource(const Value: Boolean);
  protected
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );override;
    function  AdditionalUnits: string; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property AsmAttri: THighlighterAttributes read fAsmAttri write SetAsmAttri;
    property CommentAttri: THighlighterAttributes read fCommentAttri write SetCommentAttri;
    property DirectiveAttri: THighlighterAttributes read FDirectiveAttri write SetDirectiveAttri;
    property IdentifierAttri: THighlighterAttributes read FIdentifierAttri write SetIdentifierAttri;
    property KeyAttri: THighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: THighlighterAttributes read fNumberAttri write fNumberAttri;
    property FloatAttri: THighlighterAttributes read fFloatAttri write fFloatAttri;
    property HexAttri: THighlighterAttributes read fHexAttri write fHexAttri;
    property SpaceAttri: THighlighterAttributes read fSpaceAttri write fSpaceAttri;
    property StringAttri: THighlighterAttributes read fStringAttri write fStringAttri;
    property CharAttri: THighlighterAttributes read fCharAttri write fCharAttri;
    property SymbolAttri: THighlighterAttributes read fSymbolAttri write fSymbolAttri;
    property D4syntax: boolean read fD4syntax write SetD4syntax stored False;
    property DelphiVersion: TDelphiVersion read fDelphiVersion write SetDelphiVersion     default LastDelphiVersion;
    property PackageSource: Boolean read fPackageSource write SetPackageSource default True;
//    property DefaultFilter: String read FDefaultFilter write SetDefaultFilter;
//    property Enabled:Boolean read FEnabled write SetEnabled;
  end;

  procedure Register;

implementation

constructor TKOLVMHPasHighlighter.Create( AOwner: TComponent );
begin
  inherited;// Create;
  FAsmAttri:=THighlighterAttributes.Create(Self);
  FCommentAttri:=THighlighterAttributes.Create(Self);
  FDirectiveAttri:=THighlighterAttributes.Create(Self);
  FIdentifierAttri:=THighlighterAttributes.Create(Self);
  FKeyAttri:=THighlighterAttributes.Create(Self);
  FNumberAttri:=THighlighterAttributes.Create(Self);
  FFloatAttri:=THighlighterAttributes.Create(Self);
  FHexAttri:=THighlighterAttributes.Create(Self);
  FSpaceAttri:=THighlighterAttributes.Create(Self);
  FStringAttri:=THighlighterAttributes.Create(Self);
  FCharAttri:=THighlighterAttributes.Create(Self);
  FSymbolAttri:=THighlighterAttributes.Create(Self);
  
  // Set Default Values
  FD4syntax:=False;
  FDelphiVersion:=LastDelphiVersion;
  FPackageSource:=True;
end;

destructor TKOLVMHPasHighlighter.Destroy;
begin
  FAsmAttri.Free;
  FCommentAttri.Free;
  FDirectiveAttri.Free;
  FIdentifierAttri.Free;
  FKeyAttri.Free;
  FNumberAttri.Free;
  FFloatAttri.Free;
  FHexAttri.Free;
  FSpaceAttri.Free;
  FStringAttri.Free;
  FCharAttri.Free;
  FSymbolAttri.Free;
  inherited;
end;


function TKOLVMHPasHighlighter.AdditionalUnits;
begin
  Result := ', KOLVMHSyntaxEditHighlighterPas';
end;

procedure TKOLVMHPasHighlighter.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
const
  Boolean2Str:array [Boolean] of String=('False','True');
begin
  SL.Add('');
  SL.Add( Prefix + AName + ' := NewVMHPasHighlighter(nil);');// + Owner.Name + ' );' );
  AsmAttri.GenerateCode(SL,Prefix + AName,'AsmAttri');
  CommentAttri.GenerateCode(SL,Prefix + AName,'CommentAttri');
  DirectiveAttri.GenerateCode(SL,Prefix + AName,'DirectiveAttri');
  IdentifierAttri.GenerateCode(SL,Prefix + AName,'IdentifierAttri');
  KeyAttri.GenerateCode(SL,Prefix + AName,'KeyAttri');
  NumberAttri.GenerateCode(SL,Prefix + AName,'NumberAttri');
  FloatAttri.GenerateCode(SL,Prefix + AName,'FloatAttri');
  HexAttri.GenerateCode(SL,Prefix + AName,'HexAttri');
  SpaceAttri.GenerateCode(SL,Prefix + AName,'SpaceAttri');
  StringAttri.GenerateCode(SL,Prefix + AName,'StringAttri');
  CharAttri.GenerateCode(SL,Prefix + AName,'CharAttri');
  SymbolAttri.GenerateCode(SL,Prefix + AName,'SymbolAttri');
  inherited;
end;

procedure TKOLVMHPasHighlighter.SetAsmAttri(const Value: THighlighterAttributes);
begin
  FAsmAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetCommentAttri(const Value: THighlighterAttributes);
begin
  FCommentAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetDirectiveAttri(const Value: THighlighterAttributes);
begin
  FDirectiveAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetIdentifierAttri(const Value: THighlighterAttributes);
begin
  FIdentifierAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetKeyAttri(const Value: THighlighterAttributes);
begin
  FKeyAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetNumberAttri(const Value: THighlighterAttributes);
begin
  FNumberAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetFloatAttri(const Value: THighlighterAttributes);
begin
  FFloatAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetHexAttri(const Value: THighlighterAttributes);
begin
  FHexAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetSpaceAttri(const Value: THighlighterAttributes);
begin
  FSpaceAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetStringAttri(const Value: THighlighterAttributes);
begin
  FStringAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetCharAttri(const Value: THighlighterAttributes);
begin
  FCharAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetSymbolAttri(const Value: THighlighterAttributes);
begin
  FSymbolAttri:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetD4syntax(const Value: boolean);
begin
  FD4syntax:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetDelphiVersion(const Value: TDelphiVersion);
begin
  FDelphiVersion:=Value;
  Change;
end;

procedure TKOLVMHPasHighlighter.SetPackageSource(const Value: Boolean);
begin
  FPackageSource:=Value;
  Change;
end;
(*
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
  *)
procedure Register;
begin
  RegisterComponents('KOL SyntaxEditor', [TKOLVMHPasHighlighter]);
end;

end.

