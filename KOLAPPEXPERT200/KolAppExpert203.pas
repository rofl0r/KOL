{***************************************************************
 *
 * Unit Name: KolAppExpert
 * Purpose  : Creates default empty KOL project
 *            and unit for working with KOL without MCK
 * Author   : Thaddy de Koning
 * History  : First released D4 © 2000,Thaddy de Koning.
 *            This version D4, D5, D6, D7 © 2004, Thaddy de Koning
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


unit KolAppExpert203;

interface

uses
  ExptIntf, EditIntf, Windows,SysUtils;

const crlf = #13#10 ;
type

  TSimpleKolAppExpert = class(TIExpert)
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


  TSimpleKolAppCreator = class(TIProjectCreator)
  public
    function Existing: Boolean; override; stdcall;
    function GetFileName: string; override; stdcall;
    function GetFileSystem: string; override; stdcall;
    function NewProjectSource(
      const ProjectName: string): string; override; stdcall;
    procedure NewDefaultModule; override; stdcall;
    procedure NewProjectResource(Module: TIModuleInterface); override; stdcall;
  end;

 TSimpleKolUnitCreator = class(TiModuleCreator)
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
  RegisterLibraryExpert(TSimpleKolAppExpert.Create);
end;

procedure TSimpleKolAppCreator.NewDefaultModule;
var
UnitCreator:TSimpleKolUnitCreator;
Test:TiModuleInterface;
begin
  if not assigned(Toolservices) then
  begin
    Showmessage('Can''t access Toolservices');
    Exit;
  end;

  UnitCreator:=TSimpleKolUnitCreator.create;
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

procedure TSimpleKolAppExpert.Execute;
var
  PrjCreator: TSimpleKolAppCreator;
  PrjModule: TIModuleInterface;
begin
  if not Assigned(ToolServices) then
  begin
    ShowMessage('Can''t access ToolServices');
    Exit;
  end;
  if not ToolServices.CloseProject then
    Exit;
  PrjCreator := TSimpleKolAppCreator.Create;
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

function TSimpleKolAppExpert.GetAuthor: string;
begin
  Result := 'Thaddy de Koning';
end;

function TSimpleKolAppExpert.GetComment: string;
begin
  Result := 'Creates a new KOL based application project';
end;

function TSimpleKolAppExpert.GetGlyph: HICON;
begin
  Result := LoadIcon(0, IDI_WINLOGO);
end;

function TSimpleKolAppExpert.GetIDString: string;
begin
  Result := 'KOL Simple Expert';
end;

function TSimpleKolAppExpert.GetMenuText: string;
begin
  Result := 'New Simple Kol Project';
end;

function TSimpleKolAppExpert.GetName: string;
begin
  Result := 'Simple KOL application';
end;

function TSimpleKolAppExpert.GetPage: string;
begin
  Result := 'New';
end;

function TSimpleKolAppExpert.GetState: TExpertState;
begin
  Result := [esEnabled];
end;

function TSimpleKolAppExpert.GetStyle: TExpertStyle;
begin
  Result := esProject;
end;


function TSimpleKolAppCreator.Existing: Boolean;
begin
  Result := False;
end;

function TSimpleKolAppCreator.GetFileName: string;
begin
  Result := '';
end;

function TSimpleKolAppCreator.GetFileSystem: string;
begin
  Result := '';
end;


procedure TSimpleKolAppCreator.NewProjectResource(
  Module: TIModuleInterface);
begin
  Module.Free;
end;

function TSimpleKolAppCreator.NewProjectSource(
  const ProjectName: string): string;
begin
  Result :=
    'program Project1;'+
    CrLf +
    '//********************************************************************'+
    CrLf +
    '//  Created by KOL project Expert Version 2.01 on:'+DateTimeToStr(Now)+
    CrLf +
    '//********************************************************************'+
    CrLf +
    CrLf +
    'uses'+
    CrLf +
    '  Kol;'+
    CrLf +
    'begin'+
    CrLf +
    '  NewForm1( Form1, nil);'+
    CrLf+
    '  Run(Form1.form);'+
    CrLf +
    'end.';
end;

{ TSimpleKolUnitCreator }

function TSimpleKolUnitCreator.Existing: Boolean;
begin
  Result:=False;

end;

procedure TSimpleKolUnitCreator.FormCreated(Form: TIFormInterface);
begin
  Form.free;
end;

function TSimpleKolUnitCreator.GetAncestorName: string;
begin
  Result:='';
end;

function TSimpleKolUnitCreator.GetFileName: string;
begin
  Result:='';
end;

function TSimpleKolUnitCreator.GetFileSystem: string;
begin
  Result:='';
end;

function TSimpleKolUnitCreator.GetFormName: string;
begin
  Result:='';
end;

function TSimpleKolUnitCreator.NewModuleSource(const UnitIdent, FormIdent,
  AncestorIdent: string): string;
begin
    Result :=
    'unit unit1;'+
    CrLf +
    '//********************************************************************'+
    CrLf +
    '//  Created by KOL project Expert Version 2.03 on:'+DateTimeToStr(Now)+
    CrLf +
    '//********************************************************************'+
    CrLf +
    CrLf+CrLf+
    'interface'+
    CrLf+
    'uses'+
    CrLf +
    '  Windows, Messages, Kol;'+
    CrLf +
    CrLf +
    'type' +
    CrLf +
    CrLf +
    'PForm1=^TForm1;' +
    CrLf +
    'TForm1=object(Tobj)'+
    CrLf +
    '  Form:pControl;'+
    CrLf+
    'public'+
    CrLf +
    '   // Add your eventhandlers here, example:'+
    CrLf +
     '  function DoMessage(var Msg:Tmsg;var Rslt:integer):boolean;'+
    CrLf +
    'end;'+
    CrLf +
    CrLf+CrLf+
    'procedure NewForm1( var Result: PForm1; AParent: PControl );'+
    CrLf+
    CrLf+
    'var'+
    CrLf+
    '  Form1:pForm1;'+
    CrLf+CrLf+
    'implementation' +
    CrLf+CrLf+
    'procedure NewForm1( var Result: PForm1; AParent: PControl );'+
    CrLf+
    'begin'+
    CrLf+
    '  New(Result,Create);' +
    CrLf+
    '  with Result^ do'+CrLf +
    '  begin'+CrLf +
    '    Form:= NewForm(AParent,''KOLForm'').SetSize(600,400).centeronparent.Tabulate;'+
    CrLf+
    '    Applet:=Form;'+
    CrLf+
    '    Form.OnMessage:=DoMessage;'+
    CrLf+
    '    Form.Add2AutoFree(Result);'+
    CrLf+
    '  end;'+CrLf+
    'end;'+
    CrLf+
    CrLf+CrLf+
    'function TForm1.DoMessage(var Msg:TMsg;var Rslt:integer):Boolean;'+
    CrLf +
    'begin'+
    CrLf +
    '  Result:=false;'+
    CrLf +
    'end;'+
    CrLf +
    CrLf +
    'end.';
end;


end.
