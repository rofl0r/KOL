unit MCKMHCDRIP;
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
  KOL, KOLMHCDRIP, Mirror, MCKObjs, Classes, Graphics;

type

  TKOLMHCDRIP = class(TKOLObj)
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

constructor TKOLMHCDRip.Create(AOwner: TComponent);
begin
  inherited;
  // Значения по умолчанию
end;

destructor TKOLMHCDRip.Destroy;
begin
  inherited;
end;

function TKOLMHCDRip.AdditionalUnits;
begin
   Result := ', KOLMHCDRip';
end;


procedure TKOLMHCDRip.SetupFirst(SL: TStringList; const AName, AParent, Prefix: String);
begin
  SL.Add('');
  SL.Add(Prefix+AName+':=NewMHCDRIP('+AParent+');');
end;

function TKOLMHCDRip.SetupParams(const AName, AParent: String): String;
begin
  Result:='';
end;

procedure Register;
begin
  RegisterComponents('KOL Misc', [TKOLMHCDRip]);
end;

end.

