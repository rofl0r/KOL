{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckObjs, Controls, mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    OpenSaveDialog1: TKOLOpenSaveDialog;
    EditBox1: TKOLEditBox;
    Button1: TKOLButton;
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    EditBox2: TKOLEditBox;
    Button2: TKOLButton;
    OpenDirDialog1: TKOLOpenDirDialog;
    Button3: TKOLButton;
    Button4: TKOLButton;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure Button4Click(Sender: PObj);
    procedure EditChange(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure Button3Click(Sender: PObj);
  private
    { Private declarations }
    function NextFile( Sender: PCABFile; var FileName: String ): Boolean;
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.Button1Click(Sender: PObj);
begin
  if OpenSaveDialog1.Execute then
    EditBox1.Text := OpenSaveDialog1.Filename;
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
  if OpenDirDialog1.Execute then
    EditBox2.Text := OpenDirDialog1.Path;
end;

procedure TForm1.Button4Click(Sender: PObj);
begin
  if DirectoryExists( EditBox2.Text ) then
    ShellExecute( 0, 'open', PChar( EditBox2.Text ), nil, nil, SW_SHOW );
end;

procedure TForm1.EditChange(Sender: PObj);
begin
  Button3.Enabled := FileExists( EditBox1.Text )
                  and DirectoryExists( EditBox2.Text );
  Button4.Enabled := DirectoryExists( EditBox2.Text );
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  OpenDirDialog1.InitialPath := GetStartDir;
end;

procedure TForm1.Button3Click(Sender: PObj);
var Cab: PCABFile;
begin
  Cab := OpenCABFile( [ EditBox1.Text ] );
  Cab.TargetPath := EditBox2.Text;
  Cab.OnFile := NextFile;
  Cab.Execute;
end;

function TForm1.NextFile(Sender: PCABFile; var FileName: String): Boolean;
var Dir: String;
begin
  Result := TRUE;
  Dir := IncludeTrailingPathDelimiter( EditBox2.Text ) +
         ExtractFilePath( FileName );
  if not DirectoryExists( Dir ) then
    ForceDirectories( Dir );
end;

end.


