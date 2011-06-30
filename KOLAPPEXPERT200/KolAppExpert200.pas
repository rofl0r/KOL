{***************************************************************
 *
 * Unit Name: KolAppExpert
 * Purpose  : Creates default empty KOL project
 *            and unit for working with KOL without MCK
 * Author   : Thaddy de Koning
 * History  : D4 © 2000, This version D4, D5, D6, D7 © 2003
 * Status   : Freeware
 * Remarks  :
 *            Simply install it in a Package of choice(f.e.users)
 *            Depending on the Delphi version it shows up under:
 *            File|new|Kol Application
 *                or
 *            File|New|Other|Kol Application
 *
 *            It creates a project file and a unit file with
 *            an empty form with a basic messagehandler
 *            The code is equivalent to that of an MCK project,
 *            but without confusing conditional defines and inc
 *            files.
 * Remarks2 :
 *            I wrote this, because I rarely use the MCK,
 *            I think this gives more readable code.
 *            The MCK is recommended, though!
 * Note:
 *            The OpenTools Api I used is deprecated, but so is
 *            Tobject  0_-)
 *
 ****************************************************************}


unit KolAppExpert200;

interface

uses
  ExptIntf, EditIntf, Windows,SysUtils;

type

  TKolAppExpert = class(TIExpert)
  public
    function GetName: string; override; stdcall;
    function GetAuthor: string; override; stdcall;
    function GetComment: string; override; stdcall;
    function GetPage: string; override; stdcall;
    function GetGlyph: HICON; override; stdcall;
    function GetStyle: TExpertStyle; override; stdcall;
    function GetState: TExpertState; override; stdcall;
    function GetIDString: string; override; stdcall;
    function GetMenuText: string; override; stdcall;
    procedure Execute; override; stdcall;
  end;


  TKOLAppCreator = class(TIProjectCreator)
  public
    function Existing: Boolean; override; stdcall;
    function GetFileName: string; override; stdcall;
    function GetFileSystem: string; override; stdcall;
    function NewProjectSource(
      const ProjectName: string): string; override; stdcall;
    procedure NewDefaultModule; override; stdcall;
    procedure NewProjectResource(Module: TIModuleInterface); override; stdcall;
  end;

 TKolUnitCreator = class(TiModuleCreator)
 public
    function Existing: Boolean; override; stdcall;
    function GetAncestorName: string; override; stdcall;
    function GetFileName: string; override; stdcall;
    function GetFileSystem: string; override; stdcall;
    function GetFormName: string; override; stdcall;
    function NewModuleSource(const UnitIdent, FormIdent,
      AncestorIdent: string): string; override; stdcall;
    procedure FormCreated(Form: TIFormInterface); override; stdcall;
  end;

procedure Register;

implementation

uses
  ToolIntf, Dialogs;


procedure Register;
begin
  RegisterLibraryExpert(TKOLAppExpert.Create);
end;

procedure TKOLAppCreator.NewDefaultModule;
var
UnitCreator:TkolUnitCreator;
Test:TiModuleInterface;
begin
  if not assigned(Toolservices) then
  begin
    Showmessage('Can''t access Toolservices');
    Exit;
  end;

  UnitCreator:=TKolUnitCreator.create;
  try
    Test:=Toolservices.ModuleCreate(UnitCreator,[cmMarkModified, cmNewUnit, cmUnNamed,cmAddtoProject,cmShowSource]);
    Try
      ;
    finally
      Test.free;
    end;
  finally
    UnitCreator.free;
  end;
end;

procedure TKOLAppExpert.Execute;
var
  PrjCreator: TKOLAppCreator;
  PrjModule: TIModuleInterface;
begin
  if not Assigned(ToolServices) then
  begin
    ShowMessage('Can''t access ToolServices');
    Exit;
  end;
  if not ToolServices.CloseProject then
    Exit;
  PrjCreator := TKOLAppCreator.Create;
  try
    PrjModule := ToolServices.ProjectCreate(PrjCreator, []);
    try
      ;
    finally
      PrjModule.Free;
    end;
  finally
    PrjCreator.Free;
  end;
end;

function TKOLAppExpert.GetAuthor: string;
begin
  Result := 'Thaddy de Koning';
end;

function TKOLAppExpert.GetComment: string;
begin
  Result := 'Creates a new KOL based application project';
end;

function TKOLAppExpert.GetGlyph: HICON;
begin
  Result := LoadIcon(0, IDI_WINLOGO);
end;

function TKOLAppExpert.GetIDString: string;
begin
  Result := 'KOLExpert';
end;

function TKOLAppExpert.GetMenuText: string;
begin
  Result := 'New Kol Project';
end;

function TKOLAppExpert.GetName: string;
begin
  Result := 'KOL application';
end;

function TKOLAppExpert.GetPage: string;
begin
  Result := 'New';
end;

function TKOLAppExpert.GetState: TExpertState;
begin
  Result := [esEnabled];
end;

function TKOLAppExpert.GetStyle: TExpertStyle;
begin
  Result := esProject;
end;


function TKOLAppCreator.Existing: Boolean;
begin
  Result := False;
end;

function TKOLAppCreator.GetFileName: string;
begin
  Result := '';
end;

function TKOLAppCreator.GetFileSystem: string;
begin
  Result := '';
end;


procedure TKOLAppCreator.NewProjectResource(
  Module: TIModuleInterface);
begin
  Module.Free;
end;

function TKOLAppCreator.NewProjectSource(
  const ProjectName: string): string;
begin
  Result :=
    'program Project1;'+
    #13#10 +
    '//********************************************************************'+
    #13#10 +
    '//  Created by KOL project Expert Version 2.00 on:'+DateTimeToStr(Now)+
    #13#10 +
    '//********************************************************************'+
    #13#10 +
    #13#10 +
    'uses'+
    #13#10 +
    '  Kol;'+
    #13#10 +
    'begin'+
    #13#10 +
    '  NewForm1( Form1, nil);'+
    #13#10+
    '  Run(Form1.form);'+
    #13#10 +
    'end.';
end;

{ TKolUnitCreator }

function TKolUnitCreator.Existing: Boolean;
begin
  Result:=False;

end;

procedure TKolUnitCreator.FormCreated(Form: TIFormInterface);
begin
  Form.free;
end;

function TKolUnitCreator.GetAncestorName: string;
begin
  Result:='';
end;

function TKolUnitCreator.GetFileName: string;
begin
  Result:='';
end;

function TKolUnitCreator.GetFileSystem: string;
begin
  Result:='';
end;

function TKolUnitCreator.GetFormName: string;
begin
  Result:='';
end;

function TKolUnitCreator.NewModuleSource(const UnitIdent, FormIdent,
  AncestorIdent: string): string;
begin
    Result :=
    'unit unit1;'+
    #13#10 +
    '//********************************************************************'+
    #13#10 +
    '//  Created by KOL project Expert Version 2.00 on:'+DateTimeToStr(Now)+
    #13#10 +
    '//********************************************************************'+
    #13#10 +
    #13#10#13#10+
    'interface'+
    #13#10+
    'uses'+
    #13#10 +
    '  Windows, Messages, Kol;'+
    #13#10 +
    #13#10 +
    'type' +
    #13#10 +
    #13#10 +
    'PForm1=^TForm1;' +
    #13#10 +
    'TForm1=object(Tobj)'+
    #13#10 +
    '  Form:pControl;'+
    #13#10+
    'public'+
    #13#10 +
    '   // Add your eventhandlers here, example:'+
    #13#10 +
     '  function DoMessage(var Msg:Tmsg;var Rslt:integer):boolean;'+
    #13#10 +
    'end;'+
    #13#10 +
    #13#10#13#10+
    'procedure NewForm1( var Result: PForm1; AParent: PControl );'+
    #13#10+
    #13#10+
    'var'+
    #13#10+
    '  Form1:pForm1;'+
    #13#10#13#10+
    'implementation' +
    #13#10#13#10+
    'procedure NewForm1( var Result: PForm1; AParent: PControl );'+
    #13#10+
    'begin'+
    #13#10+
    '  New(Result,Create);' +
    #13#10+
    '  with Result^ do'#13#10 +
    '  begin'#13#10 +
    '    Form:= NewForm(AParent,''KOLForm'').SetSize(600,400).centeronparent.Tabulate;'+
    #13#10+
    '    Applet:=Form;'+
    #13#10+
    '    Form.OnMessage:=DoMessage;'+
    #13#10+
    '    Form.Add2AutoFree(Result);'+
    #13#10+
    '  end;'#13#10+
    'end;'+
    #13#10+
    #13#10#13#10+
    'function TForm1.DoMessage(var Msg:TMsg;var Rslt:integer):Boolean;'+
    #13#10 +
    'begin'+
    #13#10 +
    '  Result:=false;'+
    #13#10 +
    'end;'+
    #13#10 +
    #13#10 +
    'end.';
end;


end.
