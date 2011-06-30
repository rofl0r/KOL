unit MCKMHLameCoder;
//  MHLame Компонент (MHLame Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 15-фев(feb)-2003
//  Дата коррекции (Last correction Date): 15-фев(feb)-2003
//  Версия (Version): 1.0
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Alexei O. Sabline
//  Новое в (New in):
//  V1.0
//  [+] Создан
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Исключения (Exceptions)


interface

uses
  KOL, KOLMHLameCoder, Mirror, MCKObjs, Classes, Graphics;

type

  TKOLMHLameCoder = class(TKOLObj)
  private
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName,AParent, Prefix: String); override;
    function SetupParams(const AName, AParent: String): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

  procedure Register;

implementation

constructor TKOLMHLameCoder.Create(AOwner: TComponent);
begin
  inherited;
  // Значения по умолчанию
end;

destructor TKOLMHLameCoder.Destroy;
begin
  inherited;
end;

function TKOLMHLameCoder.AdditionalUnits;
begin
   Result := ', KOLMHLameCoder';
end;


procedure TKOLMHLameCoder.SetupFirst(SL: TStringList; const AName, AParent, Prefix: String);
begin
  SL.Add('');
  SL.Add(Prefix+AName+':=NewMHLameCoder('+AParent+');');
end;

function TKOLMHLameCoder.SetupParams(const AName, AParent: String): String;
begin
  Result:='';
end;

procedure Register;
begin
  RegisterComponents('KOL Misc', [TKOLMHLameCoder]);
end;

end.

