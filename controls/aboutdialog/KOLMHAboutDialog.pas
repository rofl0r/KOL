unit KOLMHAboutDialog;
//  MHAboutDialog Компонент (MHAboutDialog Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 21-окт(oct)-2001
//  Дата коррекции (Last correction Date): 15-фев(feb)-2003
//  Версия (Version): 1.14
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Michael Beschetov
//    Alexander Pravdin
//  Новое в (New in):
//  V1.14
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V1.13
//  [+] Поддержка D6 (D6 Support) <Thanks to Alexander Pravdin> [KOLnMCK]
//
//  V1.12 2002-июль-10
//  Opti-z (KOL)
//
//  V1.11 2002-март-20
//  PChar Bug Fix (Thanks to Michael Beschetov)
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)

interface

uses
  KOL, Windows, ShellAPI;

type

  TIconType=(itShell,itApplication,itCustom);
  {
  Тип Иконки
  it_Shell - Системная (Флажок Windows)
  it_Application - Ваше приложение (Applet.Icon)
  it_Custom - Выбранная (MHAboutDialog.Icon)
  }

  PMHAboutDialog =^TMHAboutDialog;
  TKOLMHAboutDialog = PMHAboutDialog;

  TMHAboutDialog = object(TObj)
  private
  public
    Title:String;
    CopyRight:String;
    Text:String;
    Icon:HIcon;
    IconType:TIconType;
    destructor Destroy; virtual;
    procedure Execute;
  end;

function NewMHAboutDialog:PMHAboutDialog;

implementation

function NewMHAboutDialog:PMHAboutDialog;
begin
  New(Result, Create);
end;

destructor TMHAboutDialog.Destroy;
begin
  DestroyIcon(Icon);
  inherited;
end;

procedure TMHAboutDialog.Execute;
var
  HWndOwner:THandle;
  TMPIcon:HIcon;
begin
  if Assigned(Applet) then
    HWndOwner:=Applet.Handle
  else
    HWndOwner:=0;
  case IconType of
    itShell:TMPIcon:=0;
    itApplication:TMPIcon:=Applet.Icon;
    itCustom:TMPIcon:=Icon;
  end; //case
  ShellAbout(HWndOwner,PChar(Title+'#'+Text),PChar(CopyRight),TMPIcon);
end;

end.
