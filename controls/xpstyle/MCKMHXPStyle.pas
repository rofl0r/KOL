unit MCKMHXPStyle;
//  MHXPStyle Компонент (MHXPStyle Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 20-июл(jul)-2003
//  Дата коррекции (Last correction Date): 10-июл(jul)-2003
//  Версия (Version): 0.7
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    MTsv DN
//  Новое в (New in):
//  V0.7
//  [+] Сделал (Made it) [KOLnMCK]
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Подчистить (Clear Stuff)
//  4. Ошибки (Errors)
//  5. Меню
//  6. Ошибка + XP
//  7. Баги отрисовок
//  8. Шрифт кнопки

interface

uses
  Windows, Controls, Classes, KOLMHXPStyle, mirror, mckCtrls, KOL, Graphics;

type

  TKOLMHXPEditBox = class(TKOLEditBox)
  protected
    function AdditionalUnits: string; override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: string); override;
  end;

  TKOLMHXPButton = class(TKOLButton)
  protected
    function AdditionalUnits: string; override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: string); override;
  end;

  TKOLMHXPCheckBox = class(TKOLCheckBox)
  protected
    function AdditionalUnits: string; override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: string); override;
  end;

  TKOLMHXPRadioBox = class(TKOLRadioBox)
  protected
    function AdditionalUnits: string; override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: string); override;
  end;

  TKOLMHXPComboBox = class(TKOLComboBox)
  protected
    function AdditionalUnits: string; override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: string); override;
  end;

  TKOLMHXPRichEdit = class(TKOLRichEdit)
  protected
    function AdditionalUnits: string; override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: string); override;
  end;

  TKOLMHXPMemo = class(TKOLMemo)
  protected
    function AdditionalUnits: string; override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: string); override;
  end;

  TKOLMHXPPanel = class(TKOLPanel)
  protected
    function AdditionalUnits: string; override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: string); override;
  end;

procedure Register;

implementation

procedure TKOLMHXPEditBox.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: string);
var
  S: string;
begin
  S := GenerateTransparentInits;
  SL.Add(Prefix + AName + ' := PMHXPControl( New' + TypeName + '( '
    + SetupParams(AName, AParent) + ' )' + S + ');');
end;

function TKOLMHXPEditBox.AdditionalUnits;
begin
  Result := ', KOLMHXPStyle';
end;

procedure TKOLMHXPButton.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: string);
var
  S: string;
begin
  S := GenerateTransparentInits;
  SL.Add(Prefix + AName + ' := PMHXPControl( New' + TypeName + '( '
    + SetupParams(AName, AParent) + ' )' + S + ');');
end;

function TKOLMHXPButton.AdditionalUnits;
begin
  Result := ', KOLMHXPStyle';
end;

procedure TKOLMHXPCheckBox.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: string);
var
  S: string;
begin
  S := GenerateTransparentInits;
  SL.Add(Prefix + AName + ' := PMHXPControl( New' + TypeName + '( '
    + SetupParams(AName, AParent) + ' )' + S + ');');
end;

function TKOLMHXPCheckBox.AdditionalUnits;
begin
  Result := ', KOLMHXPStyle';
end;

procedure TKOLMHXPRadioBox.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: string);
var
  S: string;
begin
  S := GenerateTransparentInits;
  SL.Add(Prefix + AName + ' := PMHXPControl( New' + TypeName + '( '
    + SetupParams(AName, AParent) + ' )' + S + ');');
end;

function TKOLMHXPRadioBox.AdditionalUnits;
begin
  Result := ', KOLMHXPStyle';
end;

procedure TKOLMHXPComboBox.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: string);
var
  S: string;
begin
  S := GenerateTransparentInits;
  SL.Add(Prefix + AName + ' := PMHXPControl( New' + TypeName + '( '
    + SetupParams(AName, AParent) + ' )' + S + ');');
end;

function TKOLMHXPComboBox.AdditionalUnits;
begin
  Result := ', KOLMHXPStyle';
end;

procedure TKOLMHXPRichEdit.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: string);
var
  S: string;
begin
  S := GenerateTransparentInits;
  SL.Add(Prefix + AName + ' := PMHXPControl( New' + TypeName + '( '
    + SetupParams(AName, AParent) + ' )' + S + ');');
end;

function TKOLMHXPRichEdit.AdditionalUnits;
begin
  Result := ', KOLMHXPStyle';
end;

procedure TKOLMHXPMemo.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: string);
var
  S: string;
begin
  S := GenerateTransparentInits;
  SL.Add(Prefix + AName + ' := PMHXPControl( New' + TypeName + '( '
    + SetupParams(AName, AParent) + ' )' + S + ');');
end;

function TKOLMHXPMemo.AdditionalUnits;
begin
  Result := ', KOLMHXPStyle';
end;

procedure TKOLMHXPPanel.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: string);
var
  S: string;
begin
  S := GenerateTransparentInits;
  SL.Add(Prefix + AName + ' := PMHXPControl( New' + TypeName + '( '
    + SetupParams(AName, AParent) + ' )' + S + ');');
end;

function TKOLMHXPPanel.AdditionalUnits;
begin
  Result := ', KOLMHXPStyle';
end;

procedure Register;
begin
  RegisterComponents('KOL XPStyle', [TKOLMHXPEditBox]);
  RegisterComponents('KOL XPStyle', [TKOLMHXPButton]);
  RegisterComponents('KOL XPStyle', [TKOLMHXPCheckBox]);
  RegisterComponents('KOL XPStyle', [TKOLMHXPRadioBox]);
  RegisterComponents('KOL XPStyle', [TKOLMHXPComboBox]);
  RegisterComponents('KOL XPStyle', [TKOLMHXPRichEdit]);
  RegisterComponents('KOL XPStyle', [TKOLMHXPMemo]);
  RegisterComponents('KOL XPStyle', [TKOLMHXPPanel]);
end;

end.

