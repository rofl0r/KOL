{ ------------------------------------------------------------------------------

  DIUcl Demo project to show how to save objects to UCL compression streams and
  load them back from UCL decompression streams.

  Copyright (c) 2003 Ralf Junker - The Delphi Inspiration
  <delphi@zeitungsjunge.de>
  http://www.zeitungsjunge.de/delphi/

------------------------------------------------------------------------------ }

unit UCL_Streams_VCL_Form;

interface

uses
  Classes, Forms, StdCtrls, Graphics, Controls, ExtCtrls, ComCtrls,

  DIUclStreams;

type
  TfrmStreamVCL = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    imgOriginal: TImage;
    imgDecompressed: TImage;
    btnImage: TButton;
    memOriginal: TMemo;
    memDecompressed: TMemo;
    btnMemo: TButton;
    lblImageCompress: TLabel;
    lblMemoCompress: TLabel;
    lblMemoDecompress: TLabel;
    lblImageDecompress: TLabel;
    procedure btnMemoClick(Sender: TObject);
    procedure btnImageClick(Sender: TObject);
  private
    procedure OnMemoCompressionProgress(const Sender: TUclCustomStream; const InBytes, OutBytes: Cardinal);
    procedure OnMemoDeCompressionProgress(const Sender: TUclCustomStream; const InBytes, OutBytes: Cardinal);

    procedure OnImageCompressionProgress(const Sender: TUclCustomStream; const InBytes, OutBytes: Cardinal);
    procedure OnImageDeCompressionProgress(const Sender: TUclCustomStream; const InBytes, OutBytes: Cardinal);
  end;

var
  frmStreamVCL: TfrmStreamVCL;

implementation

uses
  SysUtils;

{$R *.dfm}

const
  COMPRESSION_LEVEL = 10;
  BUFFER_SIZE = $4000;

  { ---------------------------------------------------------------------------- }

procedure TfrmStreamVCL.btnMemoClick(Sender: TObject);
var
  TempStream: TMemoryStream;
  CompressionStream: TUclCompressionStream;
  DecompressionStream: TUclDeCompressionStream;
begin
  TempStream := TMemoryStream.Create;

  // Save and compress the memo to the stream.
  CompressionStream := TUclCompressionStream.Create(COMPRESSION_LEVEL, BUFFER_SIZE, TempStream);
  CompressionStream.OnProgress := OnMemoCompressionProgress;
  memOriginal.Lines.SaveToStream(CompressionStream);
  CompressionStream.Free;

  // Rewind the compressed temporary stream.
  TempStream.Seek(0, soFromBeginning);

  // Decompress and load the memo from the stream.
  DecompressionStream := TUclDeCompressionStream.Create(BUFFER_SIZE, TempStream);
  DecompressionStream.OnProgress := OnMemoDeCompressionProgress;
  memDecompressed.Lines.LoadFromStream(DecompressionStream);
  DecompressionStream.Free;

  TempStream.Free;
end;

{ ---------------------------------------------------------------------------- }

procedure TfrmStreamVCL.OnMemoCompressionProgress(const Sender: TUclCustomStream; const InBytes, OutBytes: Cardinal);
begin
  lblMemoCompress.Caption := 'Compressing: ' + IntToStr(InBytes) + ' -> ' + IntToStr(OutBytes);
  lblMemoCompress.Refresh;
end;

{ ---------------------------------------------------------------------------- }

procedure TfrmStreamVCL.OnMemoDeCompressionProgress(const Sender: TUclCustomStream; const InBytes, OutBytes: Cardinal);
begin
  lblMemoDecompress.Caption := 'Decompressing: ' + IntToStr(InBytes) + ' -> ' + IntToStr(OutBytes);
  lblMemoDecompress.Refresh;
end;

{ ---------------------------------------------------------------------------- }

procedure TfrmStreamVCL.btnImageClick(Sender: TObject);
var
  TempStream: TMemoryStream;
  CompressionStream: TUclCompressionStream;
  DecompressionStream: TUclDeCompressionStream;
begin
  TempStream := TMemoryStream.Create;

  // Save and compress the bitmap to the stream.
  CompressionStream := TUclCompressionStream.Create(COMPRESSION_LEVEL, BUFFER_SIZE, TempStream);
  CompressionStream.OnProgress := OnImageCompressionProgress;
  imgOriginal.Picture.Bitmap.SaveToStream(CompressionStream);
  CompressionStream.Free;

  // Rewind the compressed temporary stream.
  TempStream.Seek(0, soFromBeginning);

  // Decompress and load the image from the stream.
  DecompressionStream := TUclDeCompressionStream.Create(BUFFER_SIZE, TempStream);
  DecompressionStream.OnProgress := OnImageDeCompressionProgress;
  imgDecompressed.Picture.Bitmap.LoadFromStream(DecompressionStream);
  DecompressionStream.Free;

  TempStream.Free;
end;

{ ---------------------------------------------------------------------------- }

procedure TfrmStreamVCL.OnImageCompressionProgress(const Sender: TUclCustomStream; const InBytes, OutBytes: Cardinal);
begin
  lblImageCompress.Caption := 'Compressing: ' + IntToStr(InBytes) + ' -> ' + IntToStr(OutBytes);
  lblImageCompress.Refresh;
end;

{ ---------------------------------------------------------------------------- }

procedure TfrmStreamVCL.OnImageDeCompressionProgress(const Sender: TUclCustomStream; const InBytes, OutBytes: Cardinal);
begin
  lblImageDecompress.Caption := 'Decompressing: ' + IntToStr(InBytes) + ' -> ' + IntToStr(OutBytes);
  lblImageDecompress.Refresh;
end;

end.

