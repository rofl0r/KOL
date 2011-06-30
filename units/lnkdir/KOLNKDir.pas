//  NKDir v1.1 - модуль KOL
//  Автор: Предводителев Сергей aka Niko
//  Дата создания: 12 марта 2003 года
//  Дата коррекции: 17 марта 2003 года
//  Версия: 1.1
//  E-Mail: nikosoft@box.vsi.ru
//  WWW: http://delpas.narod.ru
//  Благодарности:
//   Жаров Дмитрий aka Gandalf

unit KOLNKDir;
interface
uses KOL, windows;
 function GetProgramsDir:string;
 function GetStartUpDir:string;
 function GetStartMenuDir:string;
 function GetDesktopDir:string;
 function GetFavoritesDir:string;
 function GetFontsDir:string;
 function GetHistoryDir:string;
 function GetMyDocumentDir:string;
 function GetSendToDir:string;
implementation

function GetProgramsDir:string;
var
 reg:HKey;
begin
 reg:=RegKeyOpenRead(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
 result:=RegKeyGetStr(reg,'Programs');
 RegKeyClose(reg);
end;

function GetStartUpDir:string;
var
 reg:HKey;
begin
 reg:=RegKeyOpenRead(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
 result:=RegKeyGetStr(reg,'Startup');
 RegKeyClose(reg);
end;

function GetStartMenuDir:string;
var
 reg:HKey;
begin
 reg:=RegKeyOpenRead(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
 result:=RegKeyGetStr(reg,'Start Menu');
 RegKeyClose(reg);
end;

function GetDesktopDir:string;
var
 reg:HKey;
begin
 reg:=RegKeyOpenRead(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
 result:=RegKeyGetStr(reg,'Desktop');
 RegKeyClose(reg);
end;

function GetFavoritesDir:string;
var
 reg:HKey;
begin
 reg:=RegKeyOpenRead(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
 result:=RegKeyGetStr(reg,'Favorites');
 RegKeyClose(reg);
end;

function GetFontsDir:string;
var
 reg:HKey;
begin
 reg:=RegKeyOpenRead(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
 result:=RegKeyGetStr(reg,'Fonts');
 RegKeyClose(reg);
end;

function GetHistoryDir:string;
var
 reg:HKey;
begin
 reg:=RegKeyOpenRead(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
 result:=RegKeyGetStr(reg,'History');
 RegKeyClose(reg);
end;

function GetMyDocumentDir:string;
var
 reg:HKey;
begin
 reg:=RegKeyOpenRead(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
 result:=RegKeyGetStr(reg,'Personal');
 RegKeyClose(reg);
end;

function GetSendToDir:string;
var
 reg:HKey;
begin
 reg:=RegKeyOpenRead(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
 result:=RegKeyGetStr(reg,'SendTo');
 RegKeyClose(reg);
end;

end.

