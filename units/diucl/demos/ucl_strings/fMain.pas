{ ------------------------------------------------------------------------------

  DIUcl Demo project to show simple string compression and
  decompression using the UCL Compression Library.

  Copyright (c) 2003 Ralf Junker - The Delphi Inspiration
  <delphi@zeitungsjunge.de>
  http://www.zeitungsjunge.de/delphi/

------------------------------------------------------------------------------ }

unit fMain;

interface

uses
  Windows, Classes, Forms, StdCtrls, Controls, ExtCtrls, ComCtrls;

type
  TfrmMain = class(TForm)
    memOriginal: TMemo;
    pnlOriginal: TPanel;
    pnlDecompressed: TPanel;
    Splitter1: TSplitter;
    memDecompressed: TMemo;
    cbxCompressionLevel: TComboBox;
    pgbRatio: TProgressBar;
    lblOriginal: TLabel;
    procedure memOriginalChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbxCompressionLevelChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

uses
  SysUtils,

  DIUcl;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  cbxCompressionLevel.ItemIndex := 9;
  try
    memOriginal.Lines.LoadFromFile('Welcome.txt');
  except
  end;
  memOriginalChange(nil);
end;

{ ---------------------------------------------------------------------------- }

{$DEFINE Wide}// Default: Off

procedure TfrmMain.memOriginalChange(Sender: TObject);
var
  s: {$IFDEF Wide}WideString{$ELSE}AnsiString{$ENDIF};
  i, l, r: Cardinal;
begin
  Application.Title := Caption;

  s := memOriginal.Text;
  i := Length(s);
  {$IFDEF Wide}
  s := UclCompressStrW(s, cbxCompressionLevel.ItemIndex + 1);
  {$ELSE}
  s := UclCompressStrA(s, cbxCompressionLevel.ItemIndex + 1);
  {$ENDIF}
  l := Length(s);
  if i > 0 then
    r := 100 - l * 100 div i
  else
    r := 0;
  lblOriginal.Caption := Format('Original Text: %d Chars | Compressed: %d Chars | %d Percent', [i, l, r]);
  pgbRatio.Position := r;
  {$IFDEF Wide}
  memDecompressed.Text := UclDecompressStrW(s);
  {$ELSE}
  memDecompressed.Text := UclDecompressStrA(s);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

procedure TfrmMain.cbxCompressionLevelChange(Sender: TObject);
begin
  memOriginalChange(nil);
end;

end.

