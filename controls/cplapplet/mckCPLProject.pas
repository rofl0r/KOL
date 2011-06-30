unit mckCPLProject;

interface

uses mirror,mckobjs, KOLCPLApplet,Classes, Controls,Graphics,Windows, Messages,Forms, Dialogs, SysUtils;

{By Bogus³aw Brandys}

type
  TKOLCPLProject = class(TKOLProject)
  private
  protected
    function GenerateDPR( const Path: String ): Boolean;override;
  public
  published
  end;

procedure Register;

implementation {implementation section}

procedure Register;
begin
  RegisterComponents( 'KOLUtils', [ TKOLCPLProject ] );
end;


{ TKOLCPLProject }
{By Bogus³aw Brandys}

function TKOLCPLProject.GenerateDPR(const Path: String): Boolean;
const BeginMark = 'begin // PROGRAM START HERE -- Please do not remove this comment';
var SL, Source: TStringList;
    S: String;
    I, J: Integer;
    F: TKOLForm;
    Updated: Boolean;
begin
  inherited GenerateDpr(Path);
  Rpt( 'Modify DPR for ' + Path ); //Rpt_Stack;
  Result := False;
  if FLocked then Exit;
  Updated := FALSE;
  SL := TStringList.Create;
  Source := TStringList.Create;


  try

  // First, generate <ProjectName>.dpr
  S := ExtractFilePath( Path ) + ProjectName + '.dpr';
  LoadSource( Source ,S);
  if Source.Count = 0 then
  begin
    Rpt( 'Could not get source from ' + S );
    SL.Free;
    Source.Free;
    Exit;
  end;


  SL.Clear;

  J := -1;

  for I := 0 to Source.Count - 1 do
  begin
    if Source[ I ] = 'begin' then
    begin
      if J = -1 then J := I else J := -2;
    end;
    if Source[ I ] = BeginMark then
    begin
      J := I; break;
    end;
  end;
  if J >= 0 then
    Source[ J ] := BeginMark
  else
  begin
    ShowMessage( 'Error while converting dpr: begin markup could not be found. ' +
                 'Dpr-file of the CPL project must  have a single line  marked ' +
                 'with special comment:'#13 +
                 BeginMark );
    Exit;
  end;


  // copy lines from the first to 'begin', making
  // some changes:
  S := '';
  SL.Add( Signature ); // insert signature
  I := -1;
  while I < Source.Count - 1 do
  begin
    Inc( I );
    S := Source[ I ];
    if S = Signature then continue; // skip signature if present
    if Trim(S) = '' then continue;
    if LowerCase( Trim( S ) ) = LowerCase( 'program ' + ProjectName + ';' ) then
    begin
      SL.Add( 'library ' + ProjectDest + ';' );
      SL.Add( '{$E cpl}');
      continue;
    end;
    if S = BeginMark then
      break;
    if LowerCase( Trim( S ) ) = 'uses' then
    begin
      SL.Add( S );
      SL.Add( 'KOL,' );
      continue;
    end;
    J := pos( 'KOL,', S );
    if J > 0 then
    begin
      S := Copy( S, 1, J-1 ) + Copy( S, J+4, Length( S )-J-3 );
      if Trim( S ) = '' then continue;
    end;
    J := pos( 'Forms,', S );
    if J > 0 then // remove reference to Forms.pas
    begin
      S := Copy( S, 1, J-1 ) + Copy( S, J+6, Length( S )-J-5 );
      if Trim( S ) = '' then continue;
    end;
    J := pos( '{$r *.res}', LowerCase( S ) );
    if J > 0 then // remove/insert reference to project resource file
        S := '//{$R *.res}';
    SL.Add( S );

  end;
  SL.Add('');
  SL.Add(BeginMark);
  SL.Add( '{$IFNDEF KOL_MCK}' );
  SL.Add('Application.Initialize;');
  SL.Add('Application.CreateForm(TForm1, Form1);');
  SL.Add('Application.Run;');
  SL.Add('{$ENDIF}');
  SL.Add( 'end.' );


  // store SL as <ProjectDest>.dpr
  SaveStrings( SL,Path + '.dpr',Updated);

    // at last, generate code for all (opened in designer) forms

  if FormsList <> nil then
  for I := 0 to FormsList.Count - 1 do
  begin
    F := FormsList[ I ];
    F.GenerateUnit( ExtractFilePath( Path ) + F.FormUnit );
  end;

  if Updated then
    MarkModified( Path + '.dpr' );


  Result := True;

  except
  end;

  SL.Free;
  Source.Free;
end;

end.
