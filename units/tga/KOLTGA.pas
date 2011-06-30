unit KOLTGA;

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
////      KOL TARGA translated for KOL by MrBrdo     ////
////  I don't know who orignaly made this, but the   ////
////  component was to be registered under A-Team.   ////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

interface

uses
  Windows, KOL, Messages;

var
  Color16to24: array[0..31] of Byte = (0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112,
                                       120, 128, 136, 144, 152, 160, 168, 176, 184, 192, 200, 208,
                                       216, 224, 232, 240, 248);
const

NO_COLORMAP_INCLUDED = 0;
COLORMAP_IS_INCLUDED = 1;

NO_IMAGEDATA_INCLUDED = 0;
COLORMAPPED_IMAGE = 1;
TRUECOLOR_IMAGE = 2;
BLACKANDWHITE_IMAGE = 3;
RLE_COLORMAPPED_IMAGE = 9;
RLE_TRUECOLOR_IMAGE = 10;
RLE_BLACKANDWHITE_IMAGE = 11;

CF_TARGA = 20;

type
PByteArray = ^TByteArray;
TByteArray = array[0..32767] of Byte;

TTargaID = packed record
  Length: Byte;
  Text: PChar;
  end;

TTargaColorMapSpec = packed record
  FirstEntryIndex: Word;
  ColorMapLength: Word;
  ColorMapEntrySize: Byte;
  end;

TTargaImageDescriptor = packed record
  AlphaChannelBits: Byte;
  Top: Boolean;
  Left: Boolean;
  end;

TTargaImageSpec = packed record
  X: Word;
  Y: Word;
  Width: Word;
  Height: Word;
  PixelDepth: Byte;
  ImageDescriptor: TTargaImageDescriptor;
  end;

TRGBA = packed record
  Red: Byte;
  Green: Byte;
  Blue: Byte;
  Alpha: Byte;
  end;

TColorMap = packed array[0..999] of TRGBA;

TTargaType = (ttNoImageData, ttColorMapedImage, ttTrueColorImage, ttBlackAndWhiteImage, ttRLEColorMapedImage,
              ttRLETrueColorImage, ttRLEBlackAndWhiteImage);

TTargaViewType = (tvBitmap, tvAlphaChannel, tvUseAlphaChannel);

TTargaColorDepthType = (cd8bit, cd16bit, cd24bit, cd32bit);

TTargaClipboardType = (ctTarga, ctBitmap, ctAlphaChannel);

type
   PTarga = ^TTarga;
   TTarga = object(TObj)
   private
    FColorDepth: TTargaColorDepthType;
    FColorMapType: Byte;
    FColorMap: TColorMap;
    FColorMapSpec: TTargaColorMapSpec;
    FID: TTargaID;
    FImageType: Byte;
    FImageSpec: TTargaImageSpec;
    FIncludeAlphaChannel: Boolean;
    FTargaType: TTargaType;
    FBitmap: PBitmap;
    FAlphaChannel: PBitmap;
    procedure SetBitmap(Value: PBitmap);
    procedure SetAlphaChannel(Value: PBitmap);
    function RLEDecompress(DataLength: Integer; var RLEBuffer: PChar; var Buffer: PChar): Integer;
    function RLECompress(DataLength: Integer; var RLEBuffer: PChar; var Buffer: PChar): Integer;
   protected
//    function Equals(Graphic: TGraphic): Boolean; virtual;
    function GetEmpty: Boolean; virtual;
    function GetHeight: Integer; virtual;
//    function GetPalette: HPALETTE; virtual;
//    function GetTransparent: Boolean; virtual;
    function GetWidth: Integer; virtual;
//    procedure Progress(Sender: TObject; Stage: TProgressStage; PercentDone: Byte;  RedrawNow: Boolean; const R: TRect; const Msg: string); dynamic;
    procedure SetHeight(Value: Integer); virtual;
//    procedure SetPalette(Value: HPALETTE); virtual;
//    procedure SetTransparent(Value: Boolean); virtual;
    procedure SetWidth(Value: Integer); virtual;
   public
//    constructor Create; virtual;
    procedure Draw(ACanvas: PCanvas; const Rect: TRect); virtual;
    destructor Destroy; virtual;
    procedure LoadFromResourceName(Instance: THandle; const ResName: String);
    procedure LoadFromResourceID(Instance: THandle; ResID: Integer);
    procedure LoadFromFile(const FileName: string); virtual;
    procedure LoadFromStream(Stream: PStream); virtual;
    procedure SaveToFile(const FileName: string); virtual;
    procedure SaveToStream(Stream: PStream); virtual;
    procedure Assign(Source: PTarga); virtual;
    property Bitmap: PBitmap read FBitmap write SetBitmap;
    property AlphaChannel: PBitmap read FAlphaChannel write SetAlphaChannel;
    property Empty: Boolean read GetEmpty;
   end;

function NewTarga: PTarga;

implementation

function NewTarga: PTarga;
begin
  New(Result,Create);
  with Result^ do
  begin
    FBitmap := NewBitmap(0,0);
    FBitmap.PixelFormat:=pf32bit;
    FAlphaChannel:=NewBitmap(0,0);
    FAlphaChannel.PixelFormat:=pf32bit;
  end;
end;

destructor TTarga.Destroy;
begin
  if Assigned(FBitmap) then
    FBitmap.Free;
  if Assigned(FAlphaChannel) then
    FAlphaChannel.Free;
  inherited Destroy;
end;

procedure TTarga.LoadFromFile(const FileName: string);
var fsOpen: PStream;
begin
  fsOpen:=NewReadFileStream(FileName);
  try
    LoadFromStream(fsOpen);
  finally
    fsOpen.Free;
    end;
end;

procedure TTarga.SaveToFile(const FileName: string);
var fsOpen: PStream;
begin
  if not Assigned(FBitmap) then Exit;
  if UpperCase(CopyTail(FileName,3))='.BMP' then
    begin
    FBitmap.SaveToFile(FileName);
    end
  else
    begin
    fsOpen:=NewWriteFileStream(FileName);
    try
      SaveToStream(fsOpen);
    finally
      fsOpen.Free;
      end;
    end;
end;

procedure TTarga.Draw(ACanvas: PCanvas; const Rect: TRect);
begin
  StretchBlt(ACanvas.Handle, Rect.Left, Rect.Top, Rect.Right - Rect.Left,
             Rect.Bottom - Rect.Top, FBitmap.Canvas.Handle, 0, 0, FBitmap.Width, FBitmap.Height, ACanvas.ModeCopy);
end;

procedure TTarga.SetBitmap(Value: PBitmap);
begin
  if FBitmap <> Value then
  begin
    FBitmap.Assign(Value);
  end;
end;

procedure TTarga.SetAlphaChannel(Value: PBitmap);
begin
  if FAlphaChannel <> Value then
  begin
    FAlphaChannel.Assign(Value);
  end;
end;

function TTarga.GetEmpty: Boolean;
begin
  Result := FBitmap.Empty;
end;

function TTarga.GetHeight: Integer;
begin
  Result:=FImageSpec.Height;
end;

function TTarga.GetWidth: Integer;
begin
  Result:=FImageSpec.Width;
end;

procedure TTarga.SetHeight(Value: Integer);
begin
end;

procedure TTarga.SetWidth(Value: Integer);
begin
end;

procedure TTarga.Assign(Source: PTarga);
begin
  FBitmap.Assign(Source^.FBitmap);
  FAlphaChannel.Assign(Source^.FAlphaChannel);
end;

procedure TTarga.LoadFromResourceName(Instance: THandle; const ResName: String);
var
  Stream: PStream;
begin
  Stream := NewMemoryStream;
  Resource2Stream(Stream, Instance, PChar(ResName), RT_RCDATA);
  Stream.Seek(0, spBegin);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TTarga.LoadFromResourceID(Instance: THandle; ResID: Integer);
var
  Stream: PStream;
begin
  Stream := NewMemoryStream;
  Resource2Stream(Stream, Instance, MAKEINTRESOURCE( ResID ), RT_RCDATA);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TTarga.LoadFromStream(Stream: PStream);
var Buffer: PChar;
    RLEBuffer: PChar;
    i, j: Integer;
    Color16: Word;
    LineSize: Integer;
    LineBuffer, AlphaBuffer: PByteArray;
    tmp16: Word;
    ReadLength: Integer;

  procedure GetBAWImageType(IsRLE: Boolean);
    var i, j: Integer;
    begin
    FColorDepth:=cd8bit;
    FIncludeAlphaChannel:=False;
    if IsRLE then FTargaType:=ttRLEBlackAndWhiteImage else FTargaType:=ttBlackAndWhiteImage;
    if IsRLE then RLEBuffer:=AllocMem(LineSize*2);
    for i:=0 to FImageSpec.Height-1 do
      begin
      if not FImageSpec.ImageDescriptor.Top and not FImageSpec.ImageDescriptor.Left then
        LineBuffer:=FBitmap.ScanLine[FImageSpec.Height-(i+1)]
      else LineBuffer:=FBitmap.ScanLine[i];
      if IsRLE then
        begin
        ReadLength:=Stream.Read(RLEBuffer^,LineSize*2);
        Stream.Position:=Stream.Position-ReadLength+RLEDecompress(FImageSpec.Width,RLEBuffer, Buffer);
        end
      else Stream.Read(Buffer^,LineSize);
      for j:=0 to FImageSpec.Width-1 do
        begin
        LineBuffer[(j*4)]:=Ord(Buffer[j]);
        LineBuffer[(j*4)+1]:=Ord(Buffer[j]);
        LineBuffer[(j*4)+2]:=Ord(Buffer[j]);
        end;
      end;
    end;

begin
  Buffer:=AllocMem(18);
  Stream.Read(Buffer^,18);
  FID.Length:=Ord(Buffer[0]);
  FColorMapType:=Ord(Buffer[1]);
  FImageType:=Ord(Buffer[2]);
  FColorMapSpec.FirstEntryIndex:=Ord(Buffer[3])+Ord(Buffer[4])*256;
  FColorMapSpec.ColorMapLength:=Ord(Buffer[5])+Ord(Buffer[6])*256;
  FColorMapSpec.ColorMapEntrySize:=Ord(Buffer[7]);
  FImageSpec.X:=Ord(Buffer[8])+Ord(Buffer[9])*256;
  FImageSpec.Y:=Ord(Buffer[10])+Ord(Buffer[11])*256;
  FImageSpec.Width:=Ord(Buffer[12])+Ord(Buffer[13])*256;
  FImageSpec.Height:=Ord(Buffer[14])+Ord(Buffer[15])*256;
  FImageSpec.PixelDepth:=Ord(Buffer[16]);
  FImageSpec.ImageDescriptor.AlphaChannelBits:=Ord(Buffer[17]) and 15;
  FImageSpec.ImageDescriptor.Top:=(Ord(Buffer[17]) and 32)=32;
  FImageSpec.ImageDescriptor.Left:=(Ord(Buffer[17]) and 16)=16;
  FreeMem(Buffer);
  if FID.Length>0 then
    begin
    Stream.Read(Buffer^,FID.Length);
    FID.Text:=Buffer;
    FreeMem(Buffer);
    end
  else FID.Text:='';
  if FColorMapType=1 then
    begin
    case FColorMapSpec.ColorMapEntrySize of
      15: begin
          Buffer:=AllocMem(FColorMapSpec.ColorMapLength*2);
          Stream.Read(Buffer^,FColorMapSpec.ColorMapLength*2);
          for i:=0 to FColorMapSpec.ColorMapLength-1 do
            begin
            Color16:=Ord(Buffer[(i*2)+0])+Ord(Buffer[(i*2)+1])*256;
            FColorMap[i].Blue:=Color16to24[Color16 and 31];
            FColorMap[i].Green:=Color16to24[(Color16 and 992) shr 5];
            FColorMap[i].Red:=Color16to24[(Color16 and 31744) shr 10];
            FColorMap[i].Alpha:=0;
            end;
          end;
      16: begin
          Buffer:=AllocMem(FColorMapSpec.ColorMapLength*2);
          Stream.Read(Buffer^,FColorMapSpec.ColorMapLength*2);
          for i:=0 to FColorMapSpec.ColorMapLength-1 do
            begin
            Color16:=Ord(Buffer[(i*2)+0])+Ord(Buffer[(i*2)+1])*256;
            FColorMap[i].Blue:=Color16to24[Color16 and 31];
            FColorMap[i].Green:=Color16to24[(Color16 and 992) shr 5];
            FColorMap[i].Red:=Color16to24[(Color16 and 31744) shr 10];
            FColorMap[i].Alpha:=0;
            end;
          end;
      24: begin
          Buffer:=AllocMem(FColorMapSpec.ColorMapLength*3);
          Stream.Read(Buffer^,FColorMapSpec.ColorMapLength*3);
          for i:=0 to FColorMapSpec.ColorMapLength-1 do
            begin
            FColorMap[i].Blue:=Ord(Buffer[(i*3)+0]);
            FColorMap[i].Green:=Ord(Buffer[(i*3)+1]);
            FColorMap[i].Red:=Ord(Buffer[(i*3)+2]);
            FColorMap[i].Alpha:=0;
            end;
          end;
      32: begin
          Buffer:=AllocMem(FColorMapSpec.ColorMapLength*4);
          Stream.Read(Buffer^,FColorMapSpec.ColorMapLength*4);
          for i:=0 to FColorMapSpec.ColorMapLength-1 do
            begin
            FColorMap[i].Blue:=Ord(Buffer[(i*4)+0]);
            FColorMap[i].Green:=Ord(Buffer[(i*4)+1]);
            FColorMap[i].Red:=Ord(Buffer[(i*4)+2]);
            FColorMap[i].Alpha:=Ord(Buffer[(i*4)+3]);
            end;
          end;
      end;
    FreeMem(Buffer);
    end;
  if Assigned(FBitmap) then
    FBitmap.Free;
  FBitmap := NewBitmap(FImageSpec.Width,FImageSpec.Height);
  FBitmap.PixelFormat:=pf32bit;

  if Assigned(FAlphaChannel) then
    FAlphaChannel.Free;
  FAlphaChannel := NewBitmap(FImageSpec.Width,FImageSpec.Height);
  FAlphaChannel.PixelFormat:=pf32bit;
  
  LineSize:=FBitmap.Width*(FImageSpec.PixelDepth div 8);
  Buffer:=AllocMem(LineSize);
  case FImageType of
    NO_IMAGEDATA_INCLUDED:
      begin
      FTargaType:=ttNoImageData;
      end;
    COLORMAPPED_IMAGE:
      begin
      FTargaType:=ttColorMapedImage;
      case FImageSpec.PixelDepth of
        8: begin
           FColorDepth:=cd8bit;
           FIncludeAlphaChannel:=False;
           for i:=0 to FImageSpec.Height-1 do
             begin
             if not FImageSpec.ImageDescriptor.Top and not FImageSpec.ImageDescriptor.Left then
               LineBuffer:=FBitmap.ScanLine[FImageSpec.Height-(i+1)]
             else
               LineBuffer:=FBitmap.ScanLine[i];
             Stream.Read(Buffer^,LineSize);
             for j:=0 to FImageSpec.Width-1 do
               begin
               LineBuffer[(j*4)]:=FColorMap[Ord(Buffer[j])].Blue;
               LineBuffer[(j*4)+1]:=FColorMap[Ord(Buffer[j])].Green;
               LineBuffer[(j*4)+2]:=FColorMap[Ord(Buffer[j])].Red;
               end;
             end;
           end;
        16: begin
            end;
        24: begin
            end;
        32: begin
            end;
        end;
      end;
    TRUECOLOR_IMAGE:
      begin
      FTargaType:=ttTrueColorImage;
      case FImageSpec.PixelDepth of
        16: begin
            FColorDepth:=cd16bit;
            FIncludeAlphaChannel:=False;
            for i:=0 to FImageSpec.Height-1 do
              begin
              if not FImageSpec.ImageDescriptor.Top and not FImageSpec.ImageDescriptor.Left then
                LineBuffer:=FBitmap.ScanLine[FImageSpec.Height-(i+1)]
              else
                LineBuffer:=FBitmap.ScanLine[i];
              Stream.Read(Buffer^,LineSize);
              for j:=0 to FImageSpec.Width-1 do
                begin
                tmp16:=Ord(Buffer[j*2])+Ord(Buffer[j*2+1])*256;
                LineBuffer[(j*4)]:=Color16to24[(tmp16 and 31)];
                LineBuffer[(j*4)+1]:=Color16to24[((tmp16 and 992) shr 5)];
                LineBuffer[(j*4)+2]:=Color16to24[((tmp16 and 31744) shr 10)];
                end;
              end;
            end;
        24: begin
            FColorDepth:=cd24bit;
            FIncludeAlphaChannel:=False;
            for i:=0 to FImageSpec.Height-1 do
              begin
              if not FImageSpec.ImageDescriptor.Top and not FImageSpec.ImageDescriptor.Left then
                LineBuffer:=FBitmap.ScanLine[FImageSpec.Height-(i+1)]
              else
                LineBuffer:=FBitmap.ScanLine[i];
              Stream.Read(Buffer^,LineSize);
              for j:=0 to FImageSpec.Width-1 do
                begin
                LineBuffer[(j*4)]:=Ord(Buffer[j*3]);
                LineBuffer[(j*4)+1]:=Ord(Buffer[j*3+1]);
                LineBuffer[(j*4)+2]:=Ord(Buffer[j*3+2]);
                end;
              end;
            end;
        32: begin
            FColorDepth:=cd32bit;
            FIncludeAlphaChannel:=True;
            for i:=0 to FImageSpec.Height-1 do
              begin
              if not FImageSpec.ImageDescriptor.Top and not FImageSpec.ImageDescriptor.Left then
                begin
                LineBuffer:=FBitmap.ScanLine[FImageSpec.Height-(i+1)];
                AlphaBuffer:=FAlphaChannel.ScanLine[FImageSpec.Height-(i+1)];
                end
              else
                begin
                LineBuffer:=FBitmap.ScanLine[i];

                AlphaBuffer:=FAlphaChannel.ScanLine[i];
                end;
              Stream.Read(Buffer^,LineSize);
              for j:=0 to FImageSpec.Width-1 do
                begin
                LineBuffer[(j*4)]:=Ord(Buffer[j*4]);
                LineBuffer[(j*4)+1]:=Ord(Buffer[j*4+1]);
                LineBuffer[(j*4)+2]:=Ord(Buffer[j*4+2]);
                AlphaBuffer[(j*4)]:=Ord(Buffer[j*4+3]);
                AlphaBuffer[(j*4)+1]:=Ord(Buffer[j*4+3]);
                AlphaBuffer[(j*4)+2]:=Ord(Buffer[j*4+3]);
                end;
              end;
            end;
        end;
      end;
    BLACKANDWHITE_IMAGE: GetBAWImageType(False);
    RLE_COLORMAPPED_IMAGE:
      begin
      FTargaType:=ttRLEColorMapedImage;
      case FImageSpec.PixelDepth of
        8: begin
           FColorDepth:=cd8bit;
           FIncludeAlphaChannel:=False;
           RLEBuffer:=AllocMem(LineSize*2);
           for i:=0 to FImageSpec.Height-1 do
             begin
             if not FImageSpec.ImageDescriptor.Top and not FImageSpec.ImageDescriptor.Left then
               LineBuffer:=FBitmap.ScanLine[FImageSpec.Height-(i+1)]
             else
               LineBuffer:=FBitmap.ScanLine[i];
             ReadLength:=Stream.Read(RLEBuffer^,LineSize*2);
             Stream.Position:=Stream.Position-ReadLength+RLEDecompress(FImageSpec.Width,RLEBuffer, Buffer);
             for j:=0 to FImageSpec.Width-1 do
               begin
               LineBuffer[(j*4)]:=FColorMap[Ord(Buffer[j])].Blue;
               LineBuffer[(j*4)+1]:=FColorMap[Ord(Buffer[j])].Green;
               LineBuffer[(j*4)+2]:=FColorMap[Ord(Buffer[j])].Red;
               end;
             end;
           end;
        16: begin
            end;
        24: begin
            end;
        32: begin
            end;
        end;
      end;
    RLE_TRUECOLOR_IMAGE:
      begin
      FTargaType:=ttRLETrueColorImage;
      case FImageSpec.PixelDepth of
        16: begin
            FColorDepth:=cd16bit;
            FIncludeAlphaChannel:=False;
            RLEBuffer:=AllocMem(LineSize*2);
            for i:=0 to FImageSpec.Height-1 do
              begin
              if not FImageSpec.ImageDescriptor.Top and not FImageSpec.ImageDescriptor.Left then
                LineBuffer:=FBitmap.ScanLine[FImageSpec.Height-(i+1)]
              else
                LineBuffer:=FBitmap.ScanLine[i];
              ReadLength:=Stream.Read(RLEBuffer^,LineSize*2);
              Stream.Position:=Stream.Position-ReadLength+RLEDecompress(FImageSpec.Width*2,RLEBuffer, Buffer);
              for j:=0 to FImageSpec.Width-1 do
                begin
                tmp16:=Ord(Buffer[j*2])+Ord(Buffer[j*2+1])*256;
                LineBuffer[(j*4)]:=Color16to24[(tmp16 and 31)];
                LineBuffer[(j*4)+1]:=Color16to24[((tmp16 and 992) shr 5)];
                LineBuffer[(j*4)+2]:=Color16to24[((tmp16 and 31744) shr 10)];
                end;
              end;
            FreeMem(RLEBuffer);
            end;
        24: begin
            FColorDepth:=cd24bit;
            FIncludeAlphaChannel:=False;
            RLEBuffer:=AllocMem(LineSize*2);
            for i:=0 to FImageSpec.Height-1 do
              begin
              if not FImageSpec.ImageDescriptor.Top and not FImageSpec.ImageDescriptor.Left then
                LineBuffer:=FBitmap.ScanLine[FImageSpec.Height-(i+1)]
              else
                LineBuffer:=FBitmap.ScanLine[i];
              ReadLength:=Stream.Read(RLEBuffer^,LineSize*2);
              Stream.Position:=Stream.Position-ReadLength+RLEDecompress(FImageSpec.Width*3,RLEBuffer, Buffer);
              for j:=0 to FImageSpec.Width-1 do
                begin
                LineBuffer[(j*4)]:=Ord(Buffer[j*3]);
                LineBuffer[(j*4)+1]:=Ord(Buffer[j*3+1]);
                LineBuffer[(j*4)+2]:=Ord(Buffer[j*3+2]);
                end;
              end;
            FreeMem(RLEBuffer);
            end;
        32: begin
            FColorDepth:=cd32bit;
            FIncludeAlphaChannel:=True;
            RLEBuffer:=AllocMem(LineSize*2);
            for i:=0 to FImageSpec.Height-1 do
              begin
              if not FImageSpec.ImageDescriptor.Top and not FImageSpec.ImageDescriptor.Left then
                begin
                LineBuffer:=FBitmap.ScanLine[FImageSpec.Height-(i+1)];
                AlphaBuffer:=FAlphaChannel.ScanLine[FImageSpec.Height-(i+1)];
                end
              else
                begin
                LineBuffer:=FBitmap.ScanLine[i];
                AlphaBuffer:=FAlphaChannel.ScanLine[i];
                end;
              ReadLength:=Stream.Read(RLEBuffer^,LineSize*2);
              Stream.Position:=Stream.Position-ReadLength+RLEDecompress(FImageSpec.Width*4,RLEBuffer, Buffer);
              for j:=0 to FImageSpec.Width-1 do
                begin
                LineBuffer[(j*4)]:=Ord(Buffer[j*4]);
                LineBuffer[(j*4)+1]:=Ord(Buffer[j*4+1]);
                LineBuffer[(j*4)+2]:=Ord(Buffer[j*4+2]);
                AlphaBuffer[(j*4)]:=Ord(Buffer[j*4+3]);
                AlphaBuffer[(j*4)+1]:=Ord(Buffer[j*4+3]);
                AlphaBuffer[(j*4)+2]:=Ord(Buffer[j*4+3]);
                end;
              end;
            FreeMem(RLEBuffer);
            end;
        end;
      end;
    RLE_BLACKANDWHITE_IMAGE: GetBAWImageType(True);
    end;
  FreeMem(Buffer);
end;

procedure TTarga.SaveToStream(Stream: PStream);
type
  TRGBCount = record
    RGBA: TRGBA;
    Count: Integer;
    end;
//  TRGBCountPalete = array[0..MaxInt] of TRGBCount;

var Buffer: PChar;
    RLEBuffer: PChar;
    i, j: Integer;
    Color16: Word;
    LineSize, RLELineSize: Integer;
    LineBuffer, AlphaBuffer: PByteArray;
{    ReadLength: Integer;
    PaletePos: Integer;
    tmpPalete: TRGBA;
    CountPalete: TRGBCountPalete;
    IsInPalete: Boolean;}
    tmpPosition: Integer;
    BytePerPixel: Byte;

begin
  case FTargaType of
    ttRLETrueColorImage:
      begin
      Buffer:=AllocMem(18);
      Buffer[0]:=Chr(0);
      Buffer[1]:=Chr(0);
      Buffer[2]:=Chr(RLE_TRUECOLOR_IMAGE);
      Buffer[3]:=Chr(0);
      Buffer[4]:=Chr(0);
      Buffer[5]:=Chr(0);
      Buffer[6]:=Chr(0);
      Buffer[7]:=Chr(0);
      Buffer[8]:=Chr(0);
      Buffer[9]:=Chr(0);
      Buffer[10]:=Chr(0);
      Buffer[11]:=Chr(0);
      Buffer[12]:=Chr(FBitmap.Width mod 256);
      Buffer[13]:=Chr(FBitmap.Width div 256);
      Buffer[14]:=Chr(FBitmap.Height mod 256);
      Buffer[15]:=Chr(FBitmap.Height div 256);
      Buffer[16]:=Chr(24);
      Buffer[17]:=Chr(0);
      Stream.Write(Buffer^,18);
      FreeMem(Buffer);
      LineSize:=FBitmap.Width*3;
      Buffer:=AllocMem(LineSize);
      RLEBuffer:=AllocMem(LineSize*2);
      for i:=0 to FBitmap.Height-1 do
        begin
        LineBuffer:=FBitmap.ScanLine[FBitmap.Height-(i+1)];
        for j:=0 to FBitmap.Width-1 do
          begin
          Buffer[j*3]:=Chr(LineBuffer[j*4]);
          Buffer[j*3+1]:=Chr(LineBuffer[j*4+1]);
          Buffer[j*3+2]:=Chr(LineBuffer[j*4+2]);
          end;
        RLELineSize:=RLECompress(LineSize,RLEBuffer,Buffer);
        tmpPosition:=Stream.Position;
        Stream.Size:=Stream.Size+RLELineSize;
        Stream.Position:=tmpPosition;
        Stream.Write(RLEBuffer^,RLELineSize);
        end;
      FreeMem(Buffer);
      FreeMem(RLEBuffer);
      end;
    else
      begin
      if (FBitmap.Width<>FAlphaChannel.Width) or (FBitmap.Height<>FAlphaChannel.Height) then
        begin
        FAlphaChannel.Width:=FBitmap.Width;
        FAlphaChannel.Height:=FBitmap.Height;
        end;
      case FColorDepth of
        cd16bit: BytePerPixel:=2;
        cd24bit: BytePerPixel:=3;
        cd32bit: BytePerPixel:=4;
        else BytePerPixel:=3;
        end;
      Buffer:=AllocMem(18);
      Buffer[0]:=Chr(0);
      Buffer[1]:=Chr(0);
      Buffer[2]:=Chr(TRUECOLOR_IMAGE);
      Buffer[3]:=Chr(0);
      Buffer[4]:=Chr(0);
      Buffer[5]:=Chr(0);
      Buffer[6]:=Chr(0);
      Buffer[7]:=Chr(0);
      Buffer[8]:=Chr(0);
      Buffer[9]:=Chr(0);
      Buffer[10]:=Chr(0);
      Buffer[11]:=Chr(0);
      Buffer[12]:=Chr(FBitmap.Width mod 256);
      Buffer[13]:=Chr(FBitmap.Width div 256);
      Buffer[14]:=Chr(FBitmap.Height mod 256);
      Buffer[15]:=Chr(FBitmap.Height div 256);
      Buffer[16]:=Chr(8*BytePerPixel);
      Buffer[17]:=Chr(0);
      Stream.Write(Buffer^,18);
      FreeMem(Buffer);
      LineSize:=FBitmap.Width*BytePerPixel;
      Buffer:=AllocMem(LineSize);
      for i:=0 to FBitmap.Height-1 do
        begin
        LineBuffer:=FBitmap.ScanLine[FBitmap.Height-(i+1)];
        AlphaBuffer:=FAlphaChannel.ScanLine[FBitmap.Height-(i+1)];
        for j:=0 to FBitmap.Width-1 do
          begin
          case FColorDepth of
            cd16bit: begin
                     Color16:=(Word(LineBuffer[j*4]) div 8) or ((Word(LineBuffer[(j*4)+1]) div 8) shl 5) or ((Word(LineBuffer[(j*4)+2]) div 8) shl 10);
                     Buffer[(j*2)]:=Chr(Lo(Color16));
                     Buffer[(j*2)+1]:=Chr(Hi(Color16));
                     end;
            cd24bit: begin
                     Buffer[j*3]:=Chr(LineBuffer[j*4]);
                     Buffer[j*3+1]:=Chr(LineBuffer[j*4+1]);
                     Buffer[j*3+2]:=Chr(LineBuffer[j*4+2]);
                     end;
            cd32bit: begin
                     Buffer[j*4]:=Chr(LineBuffer[j*4]);
                     Buffer[j*4+1]:=Chr(LineBuffer[j*4+1]);
                     Buffer[j*4+2]:=Chr(LineBuffer[j*4+2]);
                     Buffer[j*4+3]:=Chr(AlphaBuffer[j*4]);
                     end;
            end;
          end;
        Stream.Write(Buffer^,LineSize);
        end;
      FreeMem(Buffer);
      end;
{    ttColorMapedImage:
      begin
      PaletePos:=0;
      for i:=0 to Bitmap.Height-1 do
        begin
        LineBuffer:=Bitmap.ScanLine[Bitmap.Height+i];
        for j:=0 to Bitmap.Width-1 do
          begin
          tmpPalete.Red:=Ord(LineBuffer[j*4]);
          tmpPalete.Green:=Ord(LineBuffer[j*4+1]);
          tmpPalete.Blue:=Ord(LineBuffer[j*4+2]);
          tmpPalete.Alpha:=0;
          IsInPalete:=False;
          for k:=0 to PaletePos-1 do if tmpPalete=CountPalete[k].RGBA then
            begin
            IsInPalete:=True;
            Inc(CountPalete[k].Count);
            end;
          if
          end;
        end;
      Buffer:=AllocMem(18);
      Buffer[0]:=Chr(0);
      Buffer[1]:=Chr(0);
      Buffer[2]:=Chr(COLORMAPPED_IMAGE);
      Buffer[3]:=Chr(0);
      Buffer[4]:=Chr(0);
      Buffer[5]:=Chr(0);
      Buffer[6]:=Chr(0);
      Buffer[7]:=Chr(0);
      Buffer[8]:=Chr(0);
      Buffer[9]:=Chr(0);
      Buffer[10]:=Chr(0);
      Buffer[11]:=Chr(0);
      Buffer[12]:=Chr(Bitmap.Width mod 256);
      Buffer[13]:=Chr(Bitmap.Width div 256);
      Buffer[14]:=Chr(Bitmap.Height mod 256);
      Buffer[15]:=Chr(Bitmap.Height div 256);
      Buffer[16]:=Chr(8);
      Buffer[17]:=Chr(0);
      fsOpen.Size:=18+Bitmap.Width*Bitmap.Height*3;
      fsOpen.Position:=0;
      fsOpen.Write(Buffer^,18);
      FreeMem(Buffer);
      LineSize:=Bitmap.Width*3;
      Buffer:=AllocMem(LineSize);
      RLEBuffer:=AllocMem(LineSize*2);
      for i:=0 to Bitmap.Height-1 do
        begin
        LineBuffer:=Bitmap.ScanLine[Bitmap.Height-(i+1)];
        for j:=0 to Bitmap.Width-1 do
          begin
          Buffer[j*3]:=Chr(LineBuffer[j*4]);
          Buffer[j*3+1]:=Chr(LineBuffer[j*4+1]);
          Buffer[j*3+2]:=Chr(LineBuffer[j*4+2]);
          end;
        fsOpen.Write(Buffer^,LineSize);
        end;
      FreeMem(Buffer);
      end;}
  end;
end;    

function TTarga.RLEDecompress(DataLength: Integer; var RLEBuffer: PChar; var Buffer: PChar): Integer;
var RLEPacketType: Boolean;
    RLEPacketLength: Integer;
    RAWDataPosition: Integer;
    RLEPacketPosition: Integer;
    j: Integer;
begin
  RLEPacketPosition:=0;
  RAWDataPosition:=0;
  case FImageSpec.PixelDepth of
    8: begin
       while True do
         begin
         RLEPacketType:=Ord(RLEBuffer[RLEPacketPosition])>127;
         RLEPacketLength:=1+Ord(RLEBuffer[RLEPacketPosition]) and 127;
         if RLEPacketType then
           begin
           for j:=0 to RLEPacketLength-1 do
             begin
             Buffer[RAWDataPosition]:=RLEBuffer[RLEPacketPosition+1];
             Inc(RAWDataPosition);
             end;
           Inc(RLEPacketPosition,2)
           end
         else
           begin
           for j:=0 to RLEPacketLength-1 do
             begin
             Buffer[RAWDataPosition]:=RLEBuffer[RLEPacketPosition+j+1];
             Inc(RAWDataPosition);
             end;
           Inc(RLEPacketPosition,RLEPacketLength+1)
           end;
         if RAWDataPosition>=DataLength then Break;
         end;
       end;
    16: begin
        while True do
          begin
          RLEPacketType:=Ord(RLEBuffer[RLEPacketPosition])>127;
          RLEPacketLength:=1+Ord(RLEBuffer[RLEPacketPosition]) and 127;
          if RLEPacketType then
            begin
            for j:=0 to RLEPacketLength-1 do
              begin
              Buffer[RAWDataPosition]:=RLEBuffer[RLEPacketPosition+1];
              Buffer[RAWDataPosition+1]:=RLEBuffer[RLEPacketPosition+2];
              Inc(RAWDataPosition,2);
              end;
            Inc(RLEPacketPosition,3)
            end
          else
            begin
            for j:=0 to RLEPacketLength-1 do
              begin
              Buffer[RAWDataPosition]:=RLEBuffer[RLEPacketPosition+j*2+1];
              Buffer[RAWDataPosition+1]:=RLEBuffer[RLEPacketPosition+j*2+2];
              Inc(RAWDataPosition,2);
              end;
            Inc(RLEPacketPosition,RLEPacketLength*2+1)
            end;
          if RAWDataPosition>=DataLength then Break;
          end;
        end;
    24: begin
        while True do
          begin
          RLEPacketType:=Ord(RLEBuffer[RLEPacketPosition])>127;
          RLEPacketLength:=(Ord(RLEBuffer[RLEPacketPosition]) and 127)+1;
          if RLEPacketType then
            begin
            for j:=0 to RLEPacketLength-1 do
              begin
              Buffer[RAWDataPosition]:=RLEBuffer[RLEPacketPosition+1];
              Buffer[RAWDataPosition+1]:=RLEBuffer[RLEPacketPosition+2];
              Buffer[RAWDataPosition+2]:=RLEBuffer[RLEPacketPosition+3];
              Inc(RAWDataPosition,3);
              end;
            Inc(RLEPacketPosition,4)
            end
          else
            begin
            for j:=0 to RLEPacketLength-1 do
              begin
              Buffer[RAWDataPosition]:=RLEBuffer[RLEPacketPosition+j*3+1];
              Buffer[RAWDataPosition+1]:=RLEBuffer[RLEPacketPosition+j*3+2];
              Buffer[RAWDataPosition+2]:=RLEBuffer[RLEPacketPosition+j*3+3];
              Inc(RAWDataPosition,3);
              end;
            Inc(RLEPacketPosition,RLEPacketLength*3+1)
            end;
          if RAWDataPosition>=DataLength then Break;
          end;
        end;
    32: begin
        while True do
          begin
          RLEPacketType:=Ord(RLEBuffer[RLEPacketPosition])>127;
          RLEPacketLength:=1+Ord(RLEBuffer[RLEPacketPosition]) and 127;
          if RLEPacketType then
            begin
            for j:=0 to RLEPacketLength-1 do
              begin
              Buffer[RAWDataPosition]:=RLEBuffer[RLEPacketPosition+1];
              Buffer[RAWDataPosition+1]:=RLEBuffer[RLEPacketPosition+2];
              Buffer[RAWDataPosition+2]:=RLEBuffer[RLEPacketPosition+3];
              Buffer[RAWDataPosition+3]:=RLEBuffer[RLEPacketPosition+4];
              Inc(RAWDataPosition,4);
              end;
            Inc(RLEPacketPosition,5)
            end
          else
            begin
            for j:=0 to RLEPacketLength-1 do
              begin
              Buffer[RAWDataPosition]:=RLEBuffer[RLEPacketPosition+j*4+1];
              Buffer[RAWDataPosition+1]:=RLEBuffer[RLEPacketPosition+j*4+2];
              Buffer[RAWDataPosition+2]:=RLEBuffer[RLEPacketPosition+j*4+3];
              Buffer[RAWDataPosition+3]:=RLEBuffer[RLEPacketPosition+j*4+4];
              Inc(RAWDataPosition,4);
              end;
            Inc(RLEPacketPosition,RLEPacketLength*4+1)
            end;
          if RAWDataPosition>=DataLength then Break;
          end;
        end;
    end;
  Result:=RLEPacketPosition;
end;

function TTarga.RLECompress(DataLength: Integer; var RLEBuffer: PChar; var Buffer: PChar): Integer;
var ByteR, ByteG, ByteB: Byte;
    ByteCount: Integer;
    RAWDataPosition: Integer;
    IsRLEPacket: Boolean;
    RLEDataPosition: Integer;
    RAWPacketHeaderPos: Integer;
begin
  IsRLEPacket:=False;
  RAWDataPosition:=0;
  RLEDataPosition:=0;
  RAWPacketHeaderPos:=0;
  ByteCount:=0;
  ByteR:=Ord(Buffer[RAWDataPosition]);
  ByteG:=Ord(Buffer[RAWDataPosition+1]);
  ByteB:=Ord(Buffer[RAWDataPosition+2]);
  Inc(RAWDataPosition,3);
  while True do
    begin
    if (RAWDataPosition>=DataLength) or (ByteCount=127) then
      begin
      if IsRLEPacket then
        begin
        RLEBuffer[RLEDataPosition]:=Chr(128+ByteCount);
        RLEBuffer[RLEDataPosition+1]:=Chr(ByteR);
        RLEBuffer[RLEDataPosition+2]:=Chr(ByteG);
        RLEBuffer[RLEDataPosition+3]:=Chr(ByteB);
        Inc(RLEDataPosition,4);
        Inc(RAWDataPosition,3);
        ByteCount:=0;
        RAWPacketHeaderPos:=RLEDataPosition;
        IsRLEPacket:=False;
        end
      else
        begin
        RLEBuffer[RAWPacketHeaderPos]:=Chr(ByteCount);
        if ByteCount>0 then
          begin
          RLEBuffer[RLEDataPosition]:=Chr(ByteR);
          RLEBuffer[RLEDataPosition+1]:=Chr(ByteG);
          RLEBuffer[RLEDataPosition+2]:=Chr(ByteB);
          Inc(RLEDataPosition,3)
          end
        else
          begin
          RLEBuffer[RLEDataPosition+1]:=Chr(ByteR);
          RLEBuffer[RLEDataPosition+2]:=Chr(ByteG);
          RLEBuffer[RLEDataPosition+3]:=Chr(ByteB);
          Inc(RLEDataPosition,4);
          end;
        Inc(RAWDataPosition,3);
        ByteR:=Ord(Buffer[RAWDataPosition]);
        ByteG:=Ord(Buffer[RAWDataPosition+1]);
        ByteB:=Ord(Buffer[RAWDataPosition+2]);
        ByteCount:=0;
        RAWPacketHeaderPos:=RLEDataPosition;
        end;
      if (RAWDataPosition>=DataLength) then Break;
      end;
    if (ByteR=Ord(Buffer[RAWDataPosition])) and (ByteG=Ord(Buffer[RAWDataPosition+1])) and (ByteB=Ord(Buffer[RAWDataPosition+2])) then
      begin
      if not IsRLEPacket then ByteCount:=0;
      Inc(ByteCount);
      Inc(RAWDataPosition,3);
      IsRLEPacket:=True;
      end
    else
      begin
      if IsRLEPacket then
        begin
        RLEBuffer[RLEDataPosition]:=Chr(128+ByteCount);
        RLEBuffer[RLEDataPosition+1]:=Chr(ByteR);
        RLEBuffer[RLEDataPosition+2]:=Chr(ByteG);
        RLEBuffer[RLEDataPosition+3]:=Chr(ByteB);
        Inc(RLEDataPosition,4);
        ByteR:=Ord(Buffer[RAWDataPosition]);
        ByteG:=Ord(Buffer[RAWDataPosition+1]);
        ByteB:=Ord(Buffer[RAWDataPosition+2]);
        Inc(RAWDataPosition,3);
        ByteCount:=0;
        RAWPacketHeaderPos:=RLEDataPosition;
        IsRLEPacket:=False;
        end
      else
        begin
        RLEBuffer[RAWPacketHeaderPos]:=Chr(ByteCount);
        if ByteCount>0 then
          begin
          RLEBuffer[RLEDataPosition]:=Chr(ByteR);
          RLEBuffer[RLEDataPosition+1]:=Chr(ByteG);
          RLEBuffer[RLEDataPosition+2]:=Chr(ByteB);
          Inc(RLEDataPosition,3)
          end
        else
          begin
          RLEBuffer[RLEDataPosition+1]:=Chr(ByteR);
          RLEBuffer[RLEDataPosition+2]:=Chr(ByteG);
          RLEBuffer[RLEDataPosition+3]:=Chr(ByteB);
          Inc(RLEDataPosition,4);
          end;
        ByteR:=Ord(Buffer[RAWDataPosition]);
        ByteG:=Ord(Buffer[RAWDataPosition+1]);
        ByteB:=Ord(Buffer[RAWDataPosition+2]);
        Inc(RAWDataPosition,3);
        Inc(ByteCount);
        end;
      end;
    end;
  Result:=RLEDataPosition;
end;

end.
