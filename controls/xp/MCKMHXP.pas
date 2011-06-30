unit MCKMHXP;
//  MHXP Компонент (MHXP Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 14-ноя(nov)-2001
//  Дата коррекции (Last correction Date): 21-апр(apr)-2003
//  Версия (Version): 1.17
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Alexander Pravdin
//  Новое в (New in):
//  V1.17
//  [+] Внешний манифест (External manifest) [KOLnMCK]
//
//  V1.16
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V1.15
//  [+] Поддержка D6 (D6 Support) <Thanks to Alexander Pravdin> [KOLnMCK]
//
//  V1.14
//  [!.] Немного подправил (Small Fixing) [MCK]
//
//  V1.13
//  [+] Tag [MCK]
//  [*] Code MCK Optim-z [MCK]
//
//  V1.12
//  [*] Hide Tag as unused [MCK]
//  [*] Del Unused modules [MCK]
//
//  V1.11
//  [*] Needn't to create and free KOLObj [MCK]
//  [*] Nearly clear KOL-file [KOL]
//
//  V1.1
//  [!] Resource Compile [MCK]
//
//  Список дел (To-Do list):
//  1. Оптимизировать (Optimize)
//  2. Подчистить (Clear Stuff)
//  3. XP должен быть один на проект (XP in Project must be ONE)

interface

uses
  KOL, Mirror, Classes, Windows, Forms, SysUtils,
{$WARNINGS OFF}
  ToolIntf, Exptintf
{$WARNINGS ON}
  ;

type

  TKOLMHXP = class(TKOLObj)
  private
    FAppName: string;
    FDescription: string;
    FExternal: Boolean;
    procedure SetAppName(Value: string);
    procedure SetDescription(Value: string);
    procedure SetExternal(const Value: Boolean);
  protected
    function AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: string); override;
    function NotAutoFree: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AppName: string read FAppName write SetAppName;
    property Description: string read FDescription write SetDescription;
    property External: Boolean read FExternal write SetExternal;
  end;

procedure Register;

implementation

function SaveManifest(AppName, Description, ThemeName: string): Boolean;
var
  RL: TStringList;
begin

    Result := True;
    RL := TStringList.Create;
    RL.Add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    RL.Add('<assembly xmlns="urn:schemas-microsoft-com:asm.v1"');
    RL.Add('manifestVersion="1.0">');
    RL.Add('<assemblyIdentity');
    RL.Add('    name="' + AppName + '"');
    RL.Add('    processorArchitecture="x86"');
    RL.Add('    version="1.0.0.0"');
    RL.Add('    type="win32"/>');
    RL.Add('<description>' + Description + '</description>');
    RL.Add('<dependency>');
    RL.Add('    <dependentAssembly>');
    RL.Add('        <assemblyIdentity');
    RL.Add('            type="win32"');
    RL.Add('            name="Microsoft.Windows.Common-Controls"');
    RL.Add('            version="6.0.0.0"');
    RL.Add('            processorArchitecture="x86"');
    RL.Add('            publicKeyToken="6595b64144ccf1df"');
    RL.Add('            language="*"');
    RL.Add('        />');
    RL.Add('    </dependentAssembly>');
    RL.Add('</dependency>');
    RL.Add('</assembly>');

    RL.SaveToFile(ThemeName);
    RL.Free;
end;

procedure GenerateManifestResource(AppName, Description: string; const RsrcName, FileName: string;
  var Updated: Boolean);
var
  RL: TStringList;
  Buf1, Buf2: PChar;
  S: string;
  I, J: Integer;
  F: THandle;
begin
    if not SaveManifest(AppName, Description, ProjectSourcePath + RsrcName + '.manifest' {'themed.manifest'}) then
      Exit;
    RL := TStringList.Create;
    RL.Add('1 24 "' + RsrcName + '.manifest"'); {'themed.manifest'}
    RL.SaveToFile(ProjectSourcePath + FileName + '.rc');
    RL.Free;
    Buf1 := nil;
    Buf2 := nil;
    I := 0; J := 0;
    S := ProjectSourcePath + FileName + '.res';
    if FileExists(S) then
    begin
      I := FileSize(S);
      if I > 0 then
      begin
        GetMem(Buf1, I);
        F := KOL.FileCreate(S, ofOpenRead or ofShareDenyWrite or ofOpenExisting);
        if F <> THandle(-1) then
        begin
          KOL.FileRead(F, Buf1^, I);
          KOL.FileClose(F);
        end;
      end;
    end;
    ExecuteWait(ExtractFilePath(Application.ExeName) + 'brcc32.exe', '"' +
      ProjectSourcePath + FileName + '.rc' + '"',
      ProjectSourcePath, SW_HIDE, INFINITE, nil);
    if FileExists(S) then
    begin
      J := FileSize(S);
      if J > 0 then
      begin
        GetMem(Buf2, J);
        F := KOL.FileCreate(S, ofOpenRead or ofShareDenyWrite or ofOpenExisting);
        if F <> THandle(-1) then
        begin
          KOL.FileRead(F, Buf2^, J);
          KOL.FileClose(F);
        end;
      end;
    end;
    if (Buf1 = nil) or (I <> J) or
      (Buf2 <> nil) and not CompareMem(Buf1, Buf2, J) then
    begin
      Updated := TRUE;
    end;
    if Buf1 <> nil then FreeMem(Buf1);
    if Buf2 <> nil then FreeMem(Buf2);
end;

constructor TKOLMHXP.Create(AOwner: TComponent);
begin

    inherited;
    FAppName := 'Organization.Division.Name';
    FDescription := 'Application description here';
    FExternal := True;

end;

destructor TKOLMHXP.Destroy;
begin
    inherited;

end;

function TKOLMHXP.AdditionalUnits;
begin
    Result := ', KOLMHXP';

end;

procedure TKOLMHXP.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: string);
var
  RsrcFile, RsrcName, s: string;
begin
  RsrcName := UpperCase(ParentKOLForm.FormName + '_' + Name);
  RsrcFile := ParentKOLForm.FormName + '_' + Name;
  SL.Add(Prefix + 'InitCommonControls;');
  if FExternal then
  begin
    if ToolServices <> nil then
    begin
      s := ToolServices.GetProjectName;
      Delete(s, Length(s) - Length(ExtractFileExt(s)) + 1, Length(ExtractFileExt(s)));
      s := s + '.exe';
      SaveManifest(AppName, Description, s + '.manifest');
      DeleteFile(ProjectSourcePath + RsrcName + '.manifest');
    end;
  end
  else
  begin
  //  SL.Add(Prefix + 'InitCommonControls;');
    SL.Add(Prefix + '{$R ' + RsrcFile + '.RES}');
    GenerateManifestResource(AppName, Description, RsrcName, RsrcFile, fUpdated);
    if ToolServices <> nil then
    begin
      s := ToolServices.GetProjectName;
      Delete(s, Length(s) - Length(ExtractFileExt(s)) + 1, Length(ExtractFileExt(s)));
      s := s + '.exe';
      DeleteFile(s + '.manifest');
    end;
  end;
end;

function TKOLMHXP.NotAutoFree: Boolean;
begin
  Result := True;
end;

procedure TKOLMHXP.SetAppName(Value: string);
begin
    if FAppName <> Value then
    begin
      FAppName := Value;
      Change;
    end;

end;

procedure TKOLMHXP.SetDescription(Value: string);
begin
    if FDescription <> Value then
    begin
      FDescription := Value;
      Change;
    end;
end;

procedure TKOLMHXP.SetExternal(const Value: Boolean);
begin
  FExternal := Value;
  Change;
end;

procedure Register;
begin
  RegisterComponents('KOL MISC', [TKOLMHXP]);
end;

end.

