{ KOL MCK }// Do not remove this line!
{$DEFINE KOL_MCK}
unit UCL_Streams_KOL_Form;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL{$IFNDEF KOL_MCK}, mirror, Classes, mckCtrls, Controls{$ENDIF};
{$ELSE}
{$I uses.inc}
Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm1 = class; PForm1 = TForm1; {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
    {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
    {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    Form1: TKOLForm;
    TabControl1: TKOLTabControl;
    TabControl1_Tab0: TKOLPanel;
    lblRichCompress: TKOLLabel;
    lblRichDecompress: TKOLLabel;
    btnRichEdit: TKOLButton;
    richOriginal: TKOLRichEdit;
    richDecompressed: TKOLRichEdit;
    procedure btnRichEditClick(Sender: PObj);
  private
    procedure OnMemoCompressionProgress(const Sender: PObj; const InBytes, OutBytes: Cardinal);
    procedure OnMemoDeCompressionProgress(const Sender: PObj; const InBytes, OutBytes: Cardinal);
  public
    { Public declarations }
  end;

var
  Form1{$IFDEF KOL_MCK}: PForm1{$ELSE}: TForm1{$ENDIF};

  {$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

uses
  DIUclStreams;

{$IFNDEF KOL_MCK}{$R *.DFM}{$ENDIF}

{$IFDEF KOL_MCK}
{$I UCL_Streams_KOL_Form_1.inc}
{$ENDIF}

const
  COMPRESSION_LEVEL = 10;
  BUFFER_SIZE = $4000;

procedure TForm1.btnRichEditClick(Sender: PObj);
var
  TempStream: PStream;
  CompressionStream: PStream;
  DecompressionStream: PStream;
begin
  btnRichEdit.Enabled := False;
  TempStream := NewMemoryStream;

  // Save and compress the memo to the stream.
  NewUclCCStream(CompressionStream, COMPRESSION_LEVEL, BUFFER_SIZE, TempStream, OnMemoCompressionProgress);
  richOriginal.RE_SaveToStream(CompressionStream, reRTF, False);
  CompressionStream.Free;

  // Rewind the compressed temporary stream.
  TempStream.Seek(0, spBegin);

  // Decompress and load the memo from the stream.
  NewUclDDStream(DecompressionStream, BUFFER_SIZE, TempStream, OnMemoDeCompressionProgress);
  richDecompressed.RE_LoadFromStream(DecompressionStream, -1, reRTF, False);
  DecompressionStream.Free;

  TempStream.Free;
  btnRichEdit.Enabled := True;
end;

{ ---------------------------------------------------------------------------- }

procedure TForm1.OnMemoCompressionProgress(const Sender: PObj; const InBytes, OutBytes: Cardinal);
begin
  lblRichCompress.Caption := 'Compressing: ' + Int2Str(InBytes) + ' -> ' + Int2Str(OutBytes);
end;

{ ---------------------------------------------------------------------------- }

procedure TForm1.OnMemoDeCompressionProgress(const Sender: PObj; const InBytes, OutBytes: Cardinal);
begin
  lblRichDecompress.Caption := 'DeCompressing: ' + Int2Str(InBytes) + ' -> ' + Int2Str(OutBytes);
end;

end.

