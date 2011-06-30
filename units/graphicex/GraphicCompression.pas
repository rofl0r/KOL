unit GraphicCompression;

// This file is part of the image library GraphicEx (www.lischke-online.de/Graphics.html).
//
// GraphicCompression contains various encoder/decoder classes used to handle compressed
// data in the various image classes.
//
// Currently supported methods are:
// - LZW (Lempel-Ziff-Welch)
//   + TIF
//   + GIF
// - RLE (run length encoding)
//   + TGA,
//   + PCX,
//   + packbits
//   + SGI
//   + CUT
//   + RLA
//   + PSP
// - CCITT
//   + raw G3 (fax T.4)
//   + modified G3 (CCITT RLE)
//   + modified G3 w/ word alignment (CCITT RLEW)
// - LZ77
// - Thunderscan
// - JPEG
// - PCD Huffmann encoding (photo CD)
//
// (c) Copyright 1999, 2000  Dipl. Ing. Mike Lischke (public@lischke-online.de). All rights reserved.
//
// This package is freeware for non-commercial use only.
// Contact author for licenses (shareware@lischke-online.de) and see License.txt which comes with the package.

interface

uses Windows, Kol, Err, Errors, MZLib; // general inflate/deflate and LZ77 compression support

type
  // abstract decoder class to define the base functionality of an encoder/decoder
  TDecoder = class
  public
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); virtual; abstract;
    procedure DecodeEnd; virtual;
    procedure DecodeInit; virtual;
  end;

  // generally, there should be no need to cover the decoder classes by conditional symbols
  // because the image classes which use the decoder classes are already covered and if they
  // aren't compiled then the decoders are also not compiled (more precisely: not linked)
  TTargaRLEDecoder = class(TDecoder)
  private
    FColorDepth: cardinal;
  public
    constructor Create(ColorDepth: cardinal);
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  // Lempel-Ziff-Welch encoder/decoder class
  // TIFF LZW compression / decompression is a bit different to the common LZW code
  TTIFFLZWDecoder = class(TDecoder)
  public
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  TPackbitsRLEDecoder = class(TDecoder)
  public
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  TPCXRLEDecoder = class(TDecoder)
  public
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  TSGIRLEDecoder = class(TDecoder)
  private
    FSampleSize: byte; // 8 or 16 bits
  public
    constructor Create(SampleSize: byte);
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  TCUTRLEDecoder = class(TDecoder)
  public
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  TPSPRLEDecoder = class(TDecoder)
  public
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  // Note: We need a different LZW decoder class for GIF because the bit order is reversed compared to that
  //       of TIFF and the code size increment is handled slightly different.
  TGIFLZWDecoder = class(TDecoder)
  private
    FInitialCodeSize: byte;
  public
    constructor Create(InitialCodeSize: byte);
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  TRLADecoder = class(TDecoder)
  public
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  TStateEntry = record
    NewState: array[Boolean] of cardinal;
    RunLength: integer;
  end;
  TStateArray = array of TStateEntry;

  TCCITTDecoder = class(TDecoder)
  private
    FOptions: integer;  // determines some options how to proceed
                        // Bit 0: if set then two-dimensional encoding was used, otherwise one-dimensional
                        // Bit 1: if set then data is uncompressed
                        // Bit 2: if set then fill bits are used before EOL codes so that EOL codes always end at
                        //        at a byte boundary (not used in this context)
    FIsWhite,           // alternating flag used while coding
    FSwapBits: boolean; // True if the order of all bits in a byte must be swapped
    FWhiteStates,
    FBlackStates: TStateArray;
    FWidth: cardinal;   // need to know how line length for modified huffman encoding
                        // coding/encoding variables
    FBitsLeft,FMask,FBits: byte;
    FPackedSize,FRestWidth: cardinal;
    FSource,FTarget: PByte;
    FFreeTargetBits: byte;
    FWordAligned: boolean;
    procedure MakeStates;
  protected
    function FillRun(RunLength: cardinal): boolean;
    function FindBlackCode: integer;
    function FindWhiteCode: integer;
    function NextBit: boolean;
  public
    constructor Create(Options: integer; SwapBits,WordAligned: boolean; Width: cardinal);
  end;

  TCCITTFax3Decoder = class(TCCITTDecoder)
  public
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  TCCITTMHDecoder = class(TCCITTDecoder) // modified Huffman RLE
  public
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  TLZ77Decoder = class(TDecoder)
  private
    FStream: TZState;
    FZLibResult,         // contains the return code of the last ZLib operation
    FFlushMode: integer; // one of flush constants declard in ZLib.pas
                         // this is usually Z_FINISH for PSP and Z_PARTIAL_FLUSH for PNG
    FAutoReset: boolean; // TIF, PSP and PNG share this decoder, TIF needs a reset for each
                         // decoder run
    function GetAvailableInput: integer;
    function GetAvailableOutput: integer;
  public
    constructor Create(FlushMode: integer; AutoReset: boolean);
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
    procedure DecodeEnd; override;
    procedure DecodeInit; override;
    property AvailableInput: integer read GetAvailableInput;
    property AvailableOutput: integer read GetAvailableOutput;
    property ZLibResult: integer read FZLibResult;
  end;

  TThunderDecoder = class(TDecoder)
  private
    FWidth: cardinal; // width of a scanline in pixels
  public
    constructor Create(Width: cardinal);
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

  TPCDDecoder = class(TDecoder)
  private
    FStream: PStream;  // decoder must read some data
  public
    constructor Create(Stream: PStream);
    procedure Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer); override;
  end;

//----------------------------------------------------------------------------------------------------------------------

implementation

uses KOLMath, GraphicEx, GraphicColor;

const // LZW encoding and decoding support
  NoLZWCode = 4096;

//----------------------------------------------------------------------------------------------------------------------

procedure CompressionError(Code: integer);
var E: Exception;
begin
  E:=Exception.Create(e_Custom,ErrorMsg[Code]);
  E.ErrorCode:=Code;
  raise E;
end;

//----------------- TDecoder (generic decoder class) -------------------------------------------------------------------

procedure TDecoder.DecodeEnd;
// called after all decompression has been done
begin
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TDecoder.DecodeInit;
// called before any decompression can start
begin
end;

//----------------- TTargaRLEDecoder -----------------------------------------------------------------------------------

constructor TTargaRLEDecoder.Create(ColorDepth: cardinal);
begin
  FColorDepth:=ColorDepth;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTargaRLEDecoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
type
  PCardinalArray = ^TCardinalArray;
  TCardinalArray = array[0..MaxInt div 4-1] of Cardinal;
var I: integer;
    SourcePtr,TargetPtr: PByte;
    RunLength,Sourcecardinal: cardinal;
begin
  TargetPtr:=Dest;
  SourcePtr:=Source;
  // unrolled decoder loop to speed up process
  case FColorDepth of
    8: while UnpackedSize>0 do
         begin
           RunLength:=1+(SourcePtr^ and $7F);
           if SourcePtr^>$7F then
             begin
               Inc(SourcePtr);
               FillChar(TargetPtr^,RunLength,SourcePtr^);
               Inc(TargetPtr,RunLength);
               Inc(SourcePtr);
             end
           else
             begin
               Inc(SourcePtr);
               Move(SourcePtr^,TargetPtr^,RunLength);
               Inc(SourcePtr,RunLength);
               Inc(TargetPtr,RunLength);
             end;
           Dec(UnpackedSize, RunLength);
         end;
    15,
    16: while UnpackedSize>0 do
          begin
            RunLength:=1+(SourcePtr^ and $7F);
            if SourcePtr^>$7F then
              begin
                Inc(SourcePtr);
                for I:=0 to RunLength-1 do
                  begin
                    TargetPtr^:=SourcePtr^;
                    Inc(SourcePtr);
                    Inc(TargetPtr);
                    TargetPtr^:=SourcePtr^;
                    Dec(SourcePtr);
                    Inc(TargetPtr);
                  end;
                Inc(SourcePtr,2);
              end
            else
              begin
                Inc(SourcePtr);
                Move(SourcePtr^,TargetPtr^,2*RunLength);
                Inc(SourcePtr,2*RunLength);
                Inc(TargetPtr,2*RunLength);
              end;
            Dec(UnpackedSize,RunLength);
          end;
    24: while UnpackedSize>0 do
          begin
            RunLength:=1+(SourcePtr^ and $7F);
            if SourcePtr^>$7F then
              begin
                Inc(SourcePtr);
                for I:=0 to RunLength-1 do
                  begin
                    TargetPtr^:=SourcePtr^;
                    Inc(SourcePtr);
                    Inc(TargetPtr);
                    TargetPtr^:=SourcePtr^;
                    Inc(SourcePtr);
                    Inc(TargetPtr);
                    TargetPtr^:=SourcePtr^;
                    Dec(SourcePtr,2);
                    Inc(TargetPtr);
                  end;
                Inc(SourcePtr,3);
              end
            else
              begin
                Inc(SourcePtr);
                Move(SourcePtr^,TargetPtr^,3*RunLength);
                Inc(SourcePtr,3*RunLength);
                Inc(TargetPtr,3*RunLength);
              end;
            Dec(UnpackedSize, RunLength);
          end;
    32: while UnpackedSize>0 do
          begin
            RunLength:=1+(SourcePtr^ and $7F);
            if SourcePtr^>$7F then
              begin
                Inc(SourcePtr);
                SourceCardinal:=PCardinalArray(SourcePtr)[0];
                for I:=0 to RunLength-1 do
                PCardinalArray(TargetPtr)[I]:=SourceCardinal;
                Inc(TargetPtr,4*RunLength);
                Inc(SourcePtr,4);
              end
            else
              begin
                Inc(SourcePtr);
                Move(SourcePtr^,TargetPtr^,4*RunLength);
                Inc(SourcePtr,4*RunLength);
                Inc(TargetPtr,4*RunLength);
              end;
            Dec(UnpackedSize,RunLength);
          end;
  end;
  Source:=SourcePtr;
end;

//----------------- TTIFFLZWDecoder ------------------------------------------------------------------------------------

procedure TTIFFLZWDecoder.Decode(var Source, Dest: pointer; PackedSize, UnpackedSize: integer);
var I: integer;
    Data,                               // current data
    Bits,                               // counter for bit management
    Code: cardinal;                     // current code value
    SourcePtr: PByte;
    InCode: cardinal;                   // Buffer for passed code
    CodeSize,CodeMask,FreeCode,OldCode: cardinal;
    Prefix: array[0..4095] of cardinal; // LZW prefix
    Suffix,                             // LZW suffix
    Stack: array[0..4095] of byte;      // stack
    Stackpointer,Target: PByte;
    FirstChar: byte;                    // Buffer for decoded byte
    ClearCode,EOICode: word;
begin
  Target:=Dest;
  SourcePtr:=Source;
  // initialize parameter
  ClearCode:=1 shl 8;
  EOICode:=ClearCode+1;
  FreeCode:=ClearCode+2;
  OldCode:=NoLZWCode;
  CodeSize:=9;
  CodeMask:=(1 shl CodeSize)-1;
  // init code table
  for I:=0 to ClearCode-1 do
    begin
      Prefix[I]:=NoLZWCode;
      Suffix[I]:=I;
    end;
  // initialize stack
  Stackpointer:=@Stack;
  FirstChar:=0;
  Data:=0;
  Bits:=0;
  while (PackedSize>0) and (UnpackedSize>0) do
    begin
      // read code from bit stream
      Inc(Data,cardinal(SourcePtr^) shl (24-Bits));
      Inc(Bits,8);
      while Bits>=CodeSize do
        begin
          // current code
          Code:=(Data and ($FFFFFFFF-CodeMask)) shr (32-CodeSize);
          // mask it
          Data:=Data shl CodeSize;
          Dec(Bits,CodeSize);
          if Code=EOICode then Exit;
          // handling of clear codes
          if Code=ClearCode then
            begin
              // reset of all variables
              CodeSize:=9;
              CodeMask:=(1 shl CodeSize)-1;
              FreeCode:=ClearCode+2;
              OldCode:=NoLZWCode;
              Continue;
            end;
          // check whether it is a valid, already registered code
          if Code>FreeCode then Break;
          // handling for the first LZW code: print and keep it
          if OldCode=NoLZWCode then
            begin
              FirstChar:=Suffix[Code];
              Target^:=FirstChar;
              Inc(Target);
              Dec(UnpackedSize);
              OldCode:=Code;
              Continue;
            end;
          // keep the passed LZW code
          InCode:=Code;
          // the first LZW code is always smaller than FFirstCode
          if Code=FreeCode then
            begin
              Stackpointer^:=FirstChar;
              Inc(StackPointer);
              Code:=OldCode;
            end;
          // loop to put decoded bytes onto the stack
          while Code>ClearCode do
            begin
              Stackpointer^:=Suffix[Code];
              Inc(StackPointer);
              Code:=Prefix[Code];
            end;
          // place new code into code table
          FirstChar:=Suffix[Code];
          Stackpointer^:=FirstChar;
          Inc(StackPointer);
          Prefix[FreeCode]:=OldCode;
          Suffix[FreeCode]:=FirstChar;
          if FreeCode<4096 then Inc(FreeCode);
          // increase code size if necessary
          if (FreeCode=CodeMask) and (CodeSize<12) then
            begin
              Inc(CodeSize);
              CodeMask:=(1 shl CodeSize)-1;
            end;
          // put decoded bytes (from the stack) into the target Buffer
          OldCode:=InCode;
          repeat
            Dec(StackPointer);
            Target^:=StackPointer^;
            Inc(Target);
            Dec(UnpackedSize);
          until cardinal(Stackpointer)<=cardinal(@Stack);
        end;
    Inc(SourcePtr);
    Dec(PackedSize);
  end;
end;

//----------------- TPackbitsRLEDecoder --------------------------------------------------------------------------------

procedure TPackbitsRLEDecoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
// decodes a simple run-length encoded strip of size PackedSize
var SourcePtr,TargetPtr: PByte;
    N: integer;
begin
  TargetPtr:=Dest;
  SourcePtr:=Source;
  while (UnpackedSize>0) and (PackedSize>0) do
    begin
      N:=ShortInt(SourcePtr^);
      Inc(SourcePtr);
      Dec(PackedSize);
      if N<0 then // replicate next Byte -N+1 times
        begin
          if N=-128 then Continue; // nop
          N:=-N+1;
          if N>UnpackedSize then N:=UnpackedSize;
          FillChar(TargetPtr^,N,SourcePtr^);
          Inc(SourcePtr);
          Dec(PackedSize);
          Inc(TargetPtr,N);
          Dec(UnpackedSize,N);
        end
      else
        begin // copy next N+1 bytes literally
          Inc(N);
          if N>UnpackedSize then N:=UnpackedSize;
          if N>PackedSize then N:=PackedSize;
          Move(SourcePtr^,TargetPtr^,N);
          Inc(TargetPtr,N);
          Inc(SourcePtr,N);
          Dec(PackedSize,N);
          Dec(UnpackedSize,N);
        end;
    end;
end;

//----------------- TPCXRLEDecoder -------------------------------------------------------------------------------------

procedure TPCXRLEDecoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
var Count: integer;
    SourcePtr,TargetPtr: PByte;
begin
  SourcePtr:=Source;
  TargetPtr:=Dest;
  while UnpackedSize>0 do
    begin
      if (SourcePtr^ and $C0)=$C0 then
        begin
          // RLE-Code
          Count:=SourcePtr^ and $3F;
          Inc(SourcePtr);
          if UnpackedSize<Count then Count:=UnpackedSize;
          FillChar(TargetPtr^,Count,SourcePtr^);
          Inc(SourcePtr);
          Inc(TargetPtr,Count);
          Dec(UnpackedSize,Count);
        end
      else
        begin
          // not compressed
          TargetPtr^:=SourcePtr^;
          Inc(SourcePtr);
          Inc(TargetPtr);
          Dec(UnpackedSize);
        end;
    end;
end;

//----------------- TSGIRLEDecoder -------------------------------------------------------------------------------------

constructor TSGIRLEDecoder.Create(SampleSize: byte);
begin
  FSampleSize:=SampleSize;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TSGIRLEDecoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
var Source8,Target8: PByte;
    Source16,Target16: PWord;
    Pixel: byte;
    Pixel16: word;
    RunLength: cardinal;
begin
  if FSampleSize=8 then
    begin
      Source8:=Source;
      Target8:=Dest;
      while True do
        begin
          Pixel:=Source8^;
          Inc(Source8);
          RunLength:=Pixel and $7F;
          if RunLength=0 then Break;
          if (Pixel and $80)<>0 then
            begin
              Move(Source8^,Target8^,RunLength);
              Inc(Target8,RunLength);
              Inc(Source8,RunLength);
            end
          else
            begin
              Pixel:=Source8^;
              Inc(Source8);
              FillChar(Target8^,RunLength,Pixel);
              Inc(Target8,RunLength);
            end;
        end;
    end
  else
    begin
      // 16 bits per sample
      Source16:=Source;
      Target16:=Dest;
      while True do
        begin
          // SGI images are stored in big endian style, swap this one repeater value for it
          Pixel16:=System.Swap(Source16^);
          Inc(Source16);
          RunLength:=Pixel16 and $7F;
          if RunLength=0 then Break;
          if (Pixel16 and $80)<>0 then
            begin
              Move(Source16^,Target16^,2*RunLength);
              Inc(Source16^,RunLength);
              Inc(Target16^,RunLength);
            end
          else
            begin
              Pixel16:=Source16^;
              Inc(Source16);
              while RunLength>0 do
                begin
                  Target16^:=Pixel16;
                  Inc(Target16);
                  Dec(RunLength);
                end;
            end;
        end;
    end;
end;

//----------------- TCUTRLE --------------------------------------------------------------------------------------------

procedure TCUTRLEDecoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
var TargetPtr: PByte;
    Pixel: byte;
    RunLength: cardinal;
begin
  TargetPtr:=Dest;
  // skip first two bytes per row (I don't know their meaning)
  Inc(PByte(Source),2);
  while True do
    begin
      Pixel:=PByte(Source)^;
      Inc(PByte(Source));
      if Pixel=0 then Break;
      RunLength:=Pixel and $7F;
      if (Pixel and $80)=0 then
        begin
          Move(Source^,TargetPtr^,RunLength);
          Inc(TargetPtr,RunLength);
          Inc(PByte(Source),RunLength);
        end
      else
        begin
          Pixel:=PByte(Source)^;
          Inc(PByte(Source));
          FillChar(TargetPtr^,RunLength,Pixel);
          Inc(TargetPtr,RunLength);
        end;
    end;
end;

//----------------- TPSPRLEDecoder -------------------------------------------------------------------------------------

procedure TPSPRLEDecoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
var SourcePtr,TargetPtr: PByte;
    RunLength: cardinal;
begin
  SourcePtr:=Source;
  TargetPtr:=Dest;
  while PackedSize>0 do
    begin
      RunLength:=SourcePtr^;
      Inc(SourcePtr);
      Dec(PackedSize);
      if RunLength<128 then
        begin
          Move(SourcePtr^,TargetPtr^,RunLength);
          Inc(TargetPtr,RunLength);
          Inc(SourcePtr,RunLength);
          Dec(PackedSize,RunLength);
        end
      else
        begin
          Dec(RunLength,128);
          FillChar(TargetPtr^,RunLength,SourcePtr^);
          Inc(SourcePtr);
          Inc(TargetPtr,RunLength);
          Dec(PackedSize);
        end;
    end;
end;

//----------------- TGIFLZWDecoder -------------------------------------------------------------------------------------

constructor TGIFLZWDecoder.Create(InitialCodeSize: byte);
begin
  FInitialCodeSize:=InitialCodeSize;
end;
//----------------------------------------------------------------------------------------------------------------------

procedure TGIFLZWDecoder.Decode(var Source, Dest: pointer; PackedSize,UnpackedSize: integer);
var I: integer;
    Data,                               // current data
    Bits,                               // counter for bit management
    Code: cardinal;                     // current code value
    SourcePtr: PByte;
    InCode: cardinal;                   // Buffer for passed code
    CodeSize,CodeMask,FreeCode,OldCode: cardinal;
    Prefix: array[0..4095] of cardinal; // LZW prefix
    Suffix,                             // LZW suffix
    Stack: array[0..4095] of byte;      // stack
    StackPointer,Target: PByte;
    FirstChar: byte;                    // Buffer for decoded byte
    ClearCode,EOICode: word;
begin
  Target:=Dest;
  SourcePtr:=Source;
  // initialize parameter
  CodeSize:=FInitialCodeSize+1;
  ClearCode:=1 shl FInitialCodeSize;
  EOICode:=ClearCode+1;
  FreeCode:=ClearCode+2;
  OldCode:=NoLZWCode;
  CodeMask:=(1 shl CodeSize)-1;
  // init code table
  for I:=0 to ClearCode-1 do
    begin
      Prefix[I]:=NoLZWCode;
      Suffix[I]:=I;
    end;
  // initialize stack
  StackPointer:=@Stack;
  FirstChar:=0;
  Data:=0;
  Bits:=0;
  while (UnpackedSize>0) and (PackedSize>0) do
    begin
      // read code from bit stream
      Inc(Data,SourcePtr^ shl Bits);
      Inc(Bits,8);
      while Bits>=CodeSize do
        begin
          // current code
          Code:=Data and CodeMask;
          // prepare next run
          Data:=Data shr CodeSize;
          Dec(Bits,CodeSize);
          // decoding finished?
          if Code=EOICode then Break;
          // handling of clear codes
          if Code=ClearCode then
            begin
              // reset of all variables
              CodeSize:=FInitialCodeSize+1;
              CodeMask:=(1 shl CodeSize)-1;
              FreeCode:=ClearCode+2;
              OldCode:=NoLZWCode;
              Continue;
            end;
          // check whether it is a valid, already registered code
          if Code>FreeCode then Break;
          // handling for the first LZW code: print and keep it
          if OldCode=NoLZWCode then
            begin
              FirstChar:=Suffix[Code];
              Target^:=FirstChar;
              Inc(Target);
              Dec(UnpackedSize);
              OldCode:=Code;
              Continue;
            end;
          // keep the passed LZW code
          InCode:=Code;
          // the first LZW code is always smaller than FFirstCode
          if Code=FreeCode then
            begin
              StackPointer^:=FirstChar;
              Inc(StackPointer);
              Code:=OldCode;
            end;
          // loop to put decoded bytes onto the stack
          while Code>ClearCode do
            begin
              StackPointer^:=Suffix[Code];
              Inc(StackPointer);
              Code:=Prefix[Code];
            end;
          // place new code into code table
          FirstChar:=Suffix[Code];
          Stackpointer^:=FirstChar;
          Inc(Stackpointer);
          Prefix[FreeCode]:=OldCode;
          Suffix[FreeCode]:=FirstChar;
          // increase code size if necessary
          if (FreeCode=CodeMask) and (CodeSize<12) then
            begin
              Inc(CodeSize);
              CodeMask:=(1 shl CodeSize)-1;
            end;
          if FreeCode<4095 then Inc(FreeCode);
          // put decoded bytes (from the stack) into the target Buffer
          OldCode:=InCode;
          repeat
            Dec(StackPointer);
            Target^:=StackPointer^;
            Inc(Target);
            Dec(UnpackedSize);
          until StackPointer=@Stack;
        end;
      Inc(SourcePtr);
      Dec(PackedSize);
    end;
end;

//----------------- TRLADecoder ----------------------------------------------------------------------------------------

procedure TRLADecoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
// decodes a simple run-length encoded strip of size PackedSize
// this is very similar to TPackbitsRLEDecoder
var SourcePtr,TargetPtr: PByte;
    N: smallint;
begin
  TargetPtr:=Dest;
  SourcePtr:=Source;
  while PackedSize>0 do
    begin
      N:=ShortInt(SourcePtr^);
      Inc(SourcePtr);
      Dec(PackedSize);
      if N>=0 then // replicate next Byte N+1 times
        begin
          FillChar(TargetPtr^,N+1,SourcePtr^);
          Inc(TargetPtr,N+1);
          Inc(SourcePtr);
          Dec(PackedSize);
        end
      else
        begin // copy next -N bytes literally
          Move(SourcePtr^,TargetPtr^,-N);
          Inc(TargetPtr,-N);
          Inc(SourcePtr,-N);
          Inc(PackedSize,N);
        end;
      end;
end;

//----------------- TCCITTDecoder --------------------------------------------------------------------------------------

constructor TCCITTDecoder.Create(Options: integer; SwapBits,WordAligned: boolean; Width: cardinal);
begin
  FOptions:=Options;
  FSwapBits:=SwapBits;
  FWidth:=Width;
  FWordAligned:=WordAligned;
  MakeStates;
end;

//----------------------------------------------------------------------------------------------------------------------

const
  // 256 bytes to make bit reversing easy,
  // this is actually not much more than writing bit manipulation code, but much faster
  ReverseTable: array[0..255] of byte = (
    $00,$80,$40,$C0,$20,$A0,$60,$E0,$10,$90,$50,$D0,$30,$B0,$70,$F0,
    $08,$88,$48,$C8,$28,$A8,$68,$E8,$18,$98,$58,$D8,$38,$B8,$78,$F8,
    $04,$84,$44,$C4,$24,$A4,$64,$E4,$14,$94,$54,$D4,$34,$B4,$74,$F4,
    $0C,$8C,$4C,$CC,$2C,$AC,$6C,$EC,$1C,$9C,$5C,$DC,$3C,$BC,$7C,$FC,
    $02,$82,$42,$C2,$22,$A2,$62,$E2,$12,$92,$52,$D2,$32,$B2,$72,$F2,
    $0A,$8A,$4A,$CA,$2A,$AA,$6A,$EA,$1A,$9A,$5A,$DA,$3A,$BA,$7A,$FA,
    $06,$86,$46,$C6,$26,$A6,$66,$E6,$16,$96,$56,$D6,$36,$B6,$76,$F6,
    $0E,$8E,$4E,$CE,$2E,$AE,$6E,$EE,$1E,$9E,$5E,$DE,$3E,$BE,$7E,$FE,
    $01,$81,$41,$C1,$21,$A1,$61,$E1,$11,$91,$51,$D1,$31,$B1,$71,$F1,
    $09,$89,$49,$C9,$29,$A9,$69,$E9,$19,$99,$59,$D9,$39,$B9,$79,$F9,
    $05,$85,$45,$C5,$25,$A5,$65,$E5,$15,$95,$55,$D5,$35,$B5,$75,$F5,
    $0D,$8D,$4D,$CD,$2D,$AD,$6D,$ED,$1D,$9D,$5D,$DD,$3D,$BD,$7D,$FD,
    $03,$83,$43,$C3,$23,$A3,$63,$E3,$13,$93,$53,$D3,$33,$B3,$73,$F3,
    $0B,$8B,$4B,$CB,$2B,$AB,$6B,$EB,$1B,$9B,$5B,$DB,$3B,$BB,$7B,$FB,
    $07,$87,$47,$C7,$27,$A7,$67,$E7,$17,$97,$57,$D7,$37,$B7,$77,$F7,
    $0F,$8F,$4F,$CF,$2F,$AF,$6F,$EF,$1F,$9F,$5F,$DF,$3F,$BF,$7F,$FF);

  G3_EOL = -1;
  G3_INVALID = -2;

//----------------------------------------------------------------------------------------------------------------------

function TCCITTDecoder.FillRun(RunLength: cardinal): boolean;
// fills a number of bits with 1s (for black, white only increments pointers),
// returns True if the line has been filled entirely, otherwise False
var Run: cardinal;
begin
  Run:=MinMin(FFreeTargetBits,RunLength);
  // fill remaining bits in the current byte
  if Run in [1..7] then
    begin
      Dec(FFreeTargetBits,Run);
      if not FIsWhite then FTarget^:=FTarget^ or (((1 shl Run)-1) shl FFreeTargetBits);
      if FFreeTargetBits=0 then
        begin
          Inc(FTarget);
          FFreeTargetBits:=8;
        end;
      Run:=RunLength-Run;
    end
  else Run:=RunLength;
  // fill entire bytes whenever possible
  if Run>0 then
    begin
      if not FIsWhite then FillChar(FTarget^,Run div 8,$FF);
      Inc(FTarget,Run div 8);
      Run:=Run mod 8;
    end;
  // finally fill remaining bits
  if Run>0 then
    begin
      FFreeTargetBits:=8-Run;
      if not FIsWhite then FTarget^:=((1 shl Run)-1) shl FFreeTargetBits;
    end;
  // this will throw an exception if the sum of the run lengths for a row is not
  // exactly the row size (the documentation speaks of an unrecoverable error)
  if cardinal(RunLength)>FRestWidth then RunLength:=FRestWidth;
  Dec(FRestWidth,RunLength);
  Result:=FRestWidth=0;
end;

//----------------------------------------------------------------------------------------------------------------------

function TCCITTDecoder.FindBlackCode: integer;
// Executes the state machine to find the run length for the next bit combination.
// Returns the run length of the found code.
var State,NewState: cardinal;
    Bit: boolean;
begin
  State:=0;
  Result:=0;
  repeat
    // advance to next byte in the input Buffer if necessary
    if FBitsLeft=0 then
      begin
        if FPackedSize=0 then Break;
        FBits:=FSource^;
        Inc(FSource);
        Dec(FPackedSize);
        FMask:=$80;
        FBitsLeft:=8;
      end;
    Bit:=(FBits and FMask)<>0;
    // advance the state machine
    NewState:=FBlackStates[State].NewState[Bit];
    if NewState=0 then
      begin
        Inc(Result,FBlackStates[State].RunLength);
        if FBlackStates[State].RunLength<64 then Break else NewState:=FBlackStates[0].NewState[Bit];
      end;
    State:=NewState;
    // address next bit
    FMask:=FMask shr 1;
    if FBitsLeft>0 then Dec(FBitsLeft);
  until False;
end;

//----------------------------------------------------------------------------------------------------------------------

function TCCITTDecoder.FindWhiteCode: integer;
// Executes the state machine to find the run length for the next bit combination.
// Returns the run length of the found code.
var State,NewState: cardinal;
    Bit: boolean;
begin
  State:=0;
  Result:=0;
  repeat
    // advance to next byte in the input Buffer if necessary
    if FBitsLeft=0 then
      begin
        if FPackedSize=0 then Break;
        FBits:=FSource^;
        Inc(FSource);
        Dec(FPackedSize);
        FMask:=$80;
        FBitsLeft:=8;
      end;
    Bit:=(FBits and FMask)<>0;
    // advance the state machine
    NewState:=FWhiteStates[State].NewState[Bit];
    if NewState=0 then
      begin
        // a code has been found
        Inc(Result,FWhiteStates[State].RunLength);
        // if we found a terminating code then exit loop, otherwise continue
        if FWhiteStates[State].RunLength<64 then Break else
          begin
            // found a make up code, continue state machine with current bit (rather than reading the next one)
            NewState:=FWhiteStates[0].NewState[Bit];
          end;
      end;
    State:=NewState;
    // address next bit
    FMask:=FMask shr 1;
    if FBitsLeft>0 then Dec(FBitsLeft);
  until False;
end;

//----------------------------------------------------------------------------------------------------------------------

function TCCITTDecoder.NextBit: boolean;
// Reads the current bit and returns True if it is set, otherwise False.
// This method is only used in the process to synchronize the bit stream in descentants.
begin
  // advance to next byte in the input Buffer if necessary
  if (FBitsLeft=0) and (FPackedSize>0) then
    begin
      FBits:=FSource^;
      Inc(FSource);
      Dec(FPackedSize);
      FMask:=$80;
      FBitsLeft:=8;
    end;
  Result:=(FBits and FMask)<>0;
  // address next bit
  FMask:=FMask shr 1;
  if FBitsLeft>0 then Dec(FBitsLeft);
end;

//----------------------------------------------------------------------------------------------------------------------

type
  TCodeEntry = record
    Code,Len: cardinal;
  end;

const // CCITT code tables
  WhiteCodes: array[0..103] of TCodeEntry = (
    (Code: $0035; Len: 8),(Code: $0007; Len: 6),(Code: $0007; Len: 4),
    (Code: $0008; Len: 4),(Code: $000B; Len: 4),(Code: $000C; Len: 4),
    (Code: $000E; Len: 4),(Code: $000F; Len: 4),(Code: $0013; Len: 5),
    (Code: $0014; Len: 5),(Code: $0007; Len: 5),(Code: $0008; Len: 5),
    (Code: $0008; Len: 6),(Code: $0003; Len: 6),(Code: $0034; Len: 6),
    (Code: $0035; Len: 6),(Code: $002A; Len: 6),(Code: $002B; Len: 6),
    (Code: $0027; Len: 7),(Code: $000C; Len: 7),(Code: $0008; Len: 7),
    (Code: $0017; Len: 7),(Code: $0003; Len: 7),(Code: $0004; Len: 7),
    (Code: $0028; Len: 7),(Code: $002B; Len: 7),(Code: $0013; Len: 7),
    (Code: $0024; Len: 7),(Code: $0018; Len: 7),(Code: $0002; Len: 8),
    (Code: $0003; Len: 8),(Code: $001A; Len: 8),(Code: $001B; Len: 8),
    (Code: $0012; Len: 8),(Code: $0013; Len: 8),(Code: $0014; Len: 8),
    (Code: $0015; Len: 8),(Code: $0016; Len: 8),(Code: $0017; Len: 8),
    (Code: $0028; Len: 8),(Code: $0029; Len: 8),(Code: $002A; Len: 8),
    (Code: $002B; Len: 8),(Code: $002C; Len: 8),(Code: $002D; Len: 8),
    (Code: $0004; Len: 8),(Code: $0005; Len: 8),(Code: $000A; Len: 8),
    (Code: $000B; Len: 8),(Code: $0052; Len: 8),(Code: $0053; Len: 8),
    (Code: $0054; Len: 8),(Code: $0055; Len: 8),(Code: $0024; Len: 8),
    (Code: $0025; Len: 8),(Code: $0058; Len: 8),(Code: $0059; Len: 8),
    (Code: $005A; Len: 8),(Code: $005B; Len: 8),(Code: $004A; Len: 8),
    (Code: $004B; Len: 8),(Code: $0032; Len: 8),(Code: $0033; Len: 8),
    (Code: $0034; Len: 8),(Code: $001B; Len: 5),(Code: $0012; Len: 5),
    (Code: $0017; Len: 6),(Code: $0037; Len: 7),(Code: $0036; Len: 8),
    (Code: $0037; Len: 8),(Code: $0064; Len: 8),(Code: $0065; Len: 8),
    (Code: $0068; Len: 8),(Code: $0067; Len: 8),(Code: $00CC; Len: 9),
    (Code: $00CD; Len: 9),(Code: $00D2; Len: 9),(Code: $00D3; Len: 9),
    (Code: $00D4; Len: 9),(Code: $00D5; Len: 9),(Code: $00D6; Len: 9),
    (Code: $00D7; Len: 9),(Code: $00D8; Len: 9),(Code: $00D9; Len: 9),
    (Code: $00DA; Len: 9),(Code: $00DB; Len: 9),(Code: $0098; Len: 9),
    (Code: $0099; Len: 9),(Code: $009A; Len: 9),(Code: $0018; Len: 6),
    (Code: $009B; Len: 9),(Code: $0008; Len: 11),(Code: $000C; Len: 11),
    (Code: $000D; Len: 11),(Code: $0012; Len: 12),(Code: $0013; Len: 12),
    (Code: $0014; Len: 12),(Code: $0015; Len: 12),(Code: $0016; Len: 12),
    (Code: $0017; Len: 12),(Code: $001C; Len: 12),(Code: $001D; Len: 12),
    (Code: $001E; Len: 12),(Code: $001F; Len: 12));
    // EOL codes are added "manually"

  BlackCodes: array[0..103] of TCodeEntry = (
    (Code: $0037; Len: 10),(Code: $0002; Len: 3),(Code: $0003; Len: 2),
    (Code: $0002; Len: 2),(Code: $0003; Len: 3),(Code: $0003; Len: 4),
    (Code: $0002; Len: 4),(Code: $0003; Len: 5),(Code: $0005; Len: 6),
    (Code: $0004; Len: 6),(Code: $0004; Len: 7),(Code: $0005; Len: 7),
    (Code: $0007; Len: 7),(Code: $0004; Len: 8),(Code: $0007; Len: 8),
    (Code: $0018; Len: 9),(Code: $0017; Len: 10),(Code: $0018; Len: 10),
    (Code: $0008; Len: 10),(Code: $0067; Len: 11),(Code: $0068; Len: 11),
    (Code: $006C; Len: 11),(Code: $0037; Len: 11),(Code: $0028; Len: 11),
    (Code: $0017; Len: 11),(Code: $0018; Len: 11),(Code: $00CA; Len: 12),
    (Code: $00CB; Len: 12),(Code: $00CC; Len: 12),(Code: $00CD; Len: 12),
    (Code: $0068; Len: 12),(Code: $0069; Len: 12),(Code: $006A; Len: 12),
    (Code: $006B; Len: 12),(Code: $00D2; Len: 12),(Code: $00D3; Len: 12),
    (Code: $00D4; Len: 12),(Code: $00D5; Len: 12),(Code: $00D6; Len: 12),
    (Code: $00D7; Len: 12),(Code: $006C; Len: 12),(Code: $006D; Len: 12),
    (Code: $00DA; Len: 12),(Code: $00DB; Len: 12),(Code: $0054; Len: 12),
    (Code: $0055; Len: 12),(Code: $0056; Len: 12),(Code: $0057; Len: 12),
    (Code: $0064; Len: 12),(Code: $0065; Len: 12),(Code: $0052; Len: 12),
    (Code: $0053; Len: 12),(Code: $0024; Len: 12),(Code: $0037; Len: 12),
    (Code: $0038; Len: 12),(Code: $0027; Len: 12),(Code: $0028; Len: 12),
    (Code: $0058; Len: 12),(Code: $0059; Len: 12),(Code: $002B; Len: 12),
    (Code: $002C; Len: 12),(Code: $005A; Len: 12),(Code: $0066; Len: 12),
    (Code: $0067; Len: 12),(Code: $000F; Len: 10),(Code: $00C8; Len: 12),
    (Code: $00C9; Len: 12),(Code: $005B; Len: 12),(Code: $0033; Len: 12),
    (Code: $0034; Len: 12),(Code: $0035; Len: 12),(Code: $006C; Len: 13),
    (Code: $006D; Len: 13),(Code: $004A; Len: 13),(Code: $004B; Len: 13),
    (Code: $004C; Len: 13),(Code: $004D; Len: 13),(Code: $0072; Len: 13),
    (Code: $0073; Len: 13),(Code: $0074; Len: 13),(Code: $0075; Len: 13),
    (Code: $0076; Len: 13),(Code: $0077; Len: 13),(Code: $0052; Len: 13),
    (Code: $0053; Len: 13),(Code: $0054; Len: 13),(Code: $0055; Len: 13),
    (Code: $005A; Len: 13),(Code: $005B; Len: 13),(Code: $0064; Len: 13),
    (Code: $0065; Len: 13),(Code: $0008; Len: 11),(Code: $000C; Len: 11),
    (Code: $000D; Len: 11),(Code: $0012; Len: 12),(Code: $0013; Len: 12),
    (Code: $0014; Len: 12),(Code: $0015; Len: 12),(Code: $0016; Len: 12),
    (Code: $0017; Len: 12),(Code: $001C; Len: 12),(Code: $001D; Len: 12),
    (Code: $001E; Len: 12),(Code: $001F; Len: 12));
    // EOL codes are added "manually"

procedure TCCITTDecoder.MakeStates;
// creates state arrays for white and black codes
// These state arrays are so designed that they have at each state (starting with state 0) a new state index
// into the same array according to the bit for which the state is current.

  //--------------- local functions -------------------------------------------
  procedure AddCode(var Target: TStateArray; Bits: cardinal; BitLen,RL: integer);
  // interprets the given string as a sequence of bits and makes a state chain from it
  var State,NewState: integer;
      Bit: boolean;
  begin
    // start state
    State:=0;
    // prepare bit combination (bits are given right align, but must be scanned from left)
    Bits:=Bits shl (32-BitLen);
    while BitLen>0 do
      begin
        // determine next state according to the bit string
        asm
          SHL  [Bits],1
          SETC [Bit]
        end;
        NewState:=Target[State].NewState[Bit];
        // Is it a not yet assigned state?
        if NewState=0 then
          begin
            // if yes then create a new state at the end of the array
            NewState:=Length(Target);
            Target[State].NewState[Bit]:=NewState;
            SetLength(Target,Length(Target)+1);
          end;
        State:=NewState;
        Dec(BitLen);
      end;
    // at this point State indicates the final state where we must store the run length for the
    // particular bit combination
    Target[State].RunLength:=RL;
  end;
  //--------------- end local functions ---------------------------------------
var I: integer;
begin
  // set an initial entry in each state array
  SetLength(FWhiteStates,1);
  SetLength(FBlackStates,1);
  // with codes
  for I:=0 to 63 do with WhiteCodes[I] do AddCode(FWhiteStates,Code,Len,I);
  for I:=64 to 103 do with WhiteCodes[I] do AddCode(FWhiteStates,Code,Len,(I-63)*64);
  AddCode(FWhiteStates,1,12,G3_EOL);
  AddCode(FWhiteStates,1,9,G3_INVALID);
  AddCode(FWhiteStates,1,10,G3_INVALID);
  AddCode(FWhiteStates,1,11,G3_INVALID);
  AddCode(FWhiteStates,0,12,G3_INVALID);
  // black codes
  for I:=0 to 63 do with BlackCodes[I] do AddCode(FBlackStates,Code,Len,I);
  for I:=64 to 103 do with BlackCodes[I] do AddCode(FBlackStates,Code,Len,(I-63)*64);
  AddCode(FBlackStates,1,12,G3_EOL);
  AddCode(FBlackStates,1,9,G3_INVALID);
  AddCode(FBlackStates,1,10,G3_INVALID);
  AddCode(FBlackStates,1,11,G3_INVALID);
  AddCode(FBlackStates,0,12,G3_INVALID);
end;

//----------------- TCCITTFax3Decoder ----------------------------------------------------------------------------------

procedure TCCITTFax3Decoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
var
  RunLength: integer;
  EOLCount: integer;
  //--------------- local functions -------------------------------------------
  procedure SynchBOL;
  // synch bit stream to next line start
  var Count: integer;
  begin
    // if no EOL codes have been read so far then do it now
    if EOLCount=0 then
      begin
        // advance until 11 consecutive 0 bits have been found
        Count:=0;
        while (Count<11) and (FPackedSize>0) do
          begin
            if NextBit then Count:=0 else Inc(Count);
          end;
      end;
    // read 8 bit until at least one set bit is found
    repeat
      Count:=0;
      while (Count<8) and (FPackedSize>0) do
        begin
          if NextBit then Count:=9 else Inc(Count);
        end;
    until (Count>8) or (FPackedSize=0);
    // here we are already beyond the set bit and can restart scanning
    EOLCount:=0;
  end;
  //---------------------------------------------------------------------------
  procedure AdjustEOL;
  begin
    FIsWhite:=False;
    if FFreeTargetBits in [1..7] then Inc(FTarget);
    FFreeTargetBits:=8;
    FRestWidth:=FWidth;
  end;
  //--------------- end local functions ---------------------------------------
begin
  // make all bits white
  FillChar(Dest^,UnpackedSize,0);
  // swap all bits here, in order to avoid frequent tests in the main loop
  if FSwapBits then
    asm
           PUSH EBX
           LEA  EBX,ReverseTable
           MOV  ECX,[PackedSize]
           MOV  EDX,[Source]
           MOV  EDX,[EDX]
      @@1:
           MOV  AL,[EDX]
           XLAT
           MOV  [EDX],AL
           INC  EDX
           DEC  ECX
           JNZ  @@1
           POP  EBX
    end;
  // setup initial states
  // a row always starts with a (possibly zero-length) white run
  FSource:=Source;
  FBitsLeft:=0;
  FPackedSize:=PackedSize;
  // target preparation
  FTarget:=Dest;
  FRestWidth:=FWidth;
  FFreeTargetBits:=8;
  EOLCount:=0;
  // main loop
  repeat
    // synchronize to start of next line
    SynchBOL;
    // a line always starts with a white run
    FIsWhite:=True;
    // decode one line
    repeat
      if FIsWhite then RunLength:=FindWhiteCode else RunLength:=FindBlackCode;
      if RunLength>=0 then
        begin
          if FillRun(RunLength) then Break;
          FIsWhite:=not FIsWhite;
        end
      else
        if RunLength=G3_EOL then Inc(EOLCount) else Break;
    until (RunLength=G3_EOL) or (FPackedSize=0);
    AdjustEOL;
  until (FPackedSize=0) or (FTarget-PChar(Dest)>=UnpackedSize);
end;

//----------------- TCCITTMHDecoder ------------------------------------------------------------------------------------

procedure TCCITTMHDecoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
var RunLength: integer;
  //--------------- local functions -------------------------------------------
  procedure AdjustEOL;
  begin
    FIsWhite:=False;
    if FFreeTargetBits in [1..7] then Inc(FTarget);
    FFreeTargetBits:=8;
    FRestWidth:=FWidth;
    if FBitsLeft<8 then FBitsLeft:=0; // discard remaining bits
    if FWordAligned and Odd(cardinal(FTarget)) then Inc(FTarget);
  end;
  //--------------- end local functions ---------------------------------------
begin
  // make all bits white
  FillChar(Dest^, UnpackedSize,0);
  // swap all bits here, in order to avoid frequent tests in the main loop
  if FSwapBits then
    asm
           PUSH EBX
           LEA  EBX,ReverseTable
           MOV  ECX,[PackedSize]
           MOV  EDX,[Source]
           MOV  EDX,[EDX]
      @@1:
           MOV  AL,[EDX]
           XLAT
           MOV  [EDX],AL
           INC  EDX
           DEC  ECX
           JNZ  @@1
           POP  EBX
    end;

  // setup initial states
  // a row always starts with a (possibly zero-length) white run
  FIsWhite:=True;
  FSource:=Source;
  FBitsLeft:=0;
  FPackedSize:=PackedSize;
  // target preparation
  FTarget:=Dest;
  FRestWidth:=FWidth;
  FFreeTargetBits:=8;
  // main loop
  repeat
    if FIsWhite then RunLength:=FindWhiteCode else RunLength:=FindBlackCode;
    if RunLength>0 then
      if FillRun(RunLength) then AdjustEOL;
    FIsWhite:=not FIsWhite;
  until FPackedSize=0;
end;

//----------------- TLZ77Decoder ---------------------------------------------------------------------------------------

constructor TLZ77Decoder.Create(FlushMode: integer; AutoReset: boolean);
begin
  FillChar(FStream,sizeof(FStream),0);
  FFlushMode:=FlushMode;
  FAutoReset:=AutoReset;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TLZ77Decoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
begin
  FStream.NextInput:=Source;
  FStream.AvailableInput:=PackedSize;
  if FAutoReset then FZLibResult:=InflateReset(FStream);
  if FZLibResult=Z_OK then
    begin
      FStream.NextOutput:=Dest;
      FStream.AvailableOutput:=UnpackedSize;
      FZLibResult:=Inflate(FStream,FFlushMode);
      // advance pointers so used input can be calculated
      Source:=FStream.NextInput;
      Dest:=FStream.NextOutput;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TLZ77Decoder.DecodeEnd;
begin
  if InflateEnd(FStream)<0 then CompressionError(20{gesLZ77Error});
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TLZ77Decoder.DecodeInit;
begin
  if InflateInit(FStream)<0 then CompressionError(20{gesLZ77Error});
end;

//----------------------------------------------------------------------------------------------------------------------

function TLZ77Decoder.GetAvailableInput: integer;
begin
  Result:=FStream.AvailableInput;
end;

//----------------------------------------------------------------------------------------------------------------------

function TLZ77Decoder.GetAvailableOutput: integer;
begin
  Result:=FStream.AvailableOutput;
end;

//----------------- TThunderDecoder ------------------------------------------------------------------------------------

// ThunderScan uses an encoding scheme designed for 4-bit pixel values.  Data is encoded in bytes, with
// each byte split into a 2-bit code word and a 6-bit data value.  The encoding gives raw data, runs of
// pixels, or pixel values encoded as a delta from the previous pixel value.  For the latter, either 2-bit
// or 3-bit delta values are used, with the deltas packed into a single byte.

const
  THUNDER_DATA       = $3F;   // mask for 6-bit data
  THUNDER_CODE       = $C0;   // mask for 2-bit code word
  // code values
  THUNDER_RUN        = 0;     // run of pixels w/ encoded count
  THUNDER_2BITDELTAS = $40;   // 3 pixels w/ encoded 2-bit deltas
  DELTA2_SKIP        = 2;     // skip code for 2-bit deltas
  THUNDER_3BITDELTAS = $80;   // 2 pixels w/ encoded 3-bit deltas
  DELTA3_SKIP        = 4;     // skip code for 3-bit deltas
  THUNDER_RAW        = $C0;   // raw data encoded

  TwoBitDeltas: array[0..3] of integer = (0,1,0,-1);
  ThreeBitDeltas: array[0..7] of integer = (0,1,2,3,0,-3,-2,-1);

constructor TThunderDecoder.Create(Width: cardinal);
begin
  FWidth:=Width;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TThunderDecoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
var SourcePtr,TargetPtr: PByte;
    LastPixel,N,Delta: integer;
    NPixels: cardinal;
    //--------------- local function --------------------------------------------
    procedure SetPixel(Delta: integer);
    begin
      Lastpixel:=Delta and $0F;
      if Odd(NPixels) then
        begin
          TargetPtr^:=TargetPtr^ or LastPixel;
          Inc(TargetPtr);
        end
      else TargetPtr^:=LastPixel shl 4;
      Inc(NPixels);
    end;
    //--------------- end local function ----------------------------------------
begin
  SourcePtr:=Source;
  TargetPtr:=Dest;
  while UnpackedSize>0 do
    begin
      LastPixel:=0;
      NPixels:=0;
      // Usually Width represents the byte number of a strip, but the thunder
      // algo is only defined for 4 bits per pixel formats where 2 pixels take up
      // one byte.
      while (PackedSize>0) and (NPixels<2*FWidth) do
        begin
          N:=SourcePtr^;
          Inc(SourcePtr);
          Dec(PackedSize);
          case N and THUNDER_CODE of
            THUNDER_RUN:
              // pixel run, replicate the last pixel n times, where n is the lower-order 6 bits
              begin
                if Odd(NPixels) then
                  begin
                    TargetPtr^:=TargetPtr^ or Lastpixel;
                    Lastpixel:=TargetPtr^;
                    Inc(TargetPtr);
                    Inc(NPixels);
                    Dec(N);
                  end
                else LastPixel:=LastPixel or LastPixel shl 4;
                Inc(NPixels, N);
                while N>0 do
                  begin
                    TargetPtr^:=LastPixel;
                    Inc(TargetPtr);
                    Dec(N, 2);
                  end;
                if N = -1 then
                  begin
                    Dec(TargetPtr);
                    TargetPtr^:=TargetPtr^ and $F0;
                  end;
                LastPixel:=LastPixel and $0F;
              end;
            THUNDER_2BITDELTAS: // 2-bit deltas
              begin
                Delta:=(N shr 4) and 3;
                if Delta<>DELTA2_SKIP then SetPixel(LastPixel+TwoBitDeltas[Delta]);
                Delta:=(N shr 2) and 3;
                if Delta<>DELTA2_SKIP then SetPixel(LastPixel+TwoBitDeltas[Delta]);
                Delta:=N and 3;
                if Delta<>DELTA2_SKIP then SetPixel(LastPixel+TwoBitDeltas[Delta]);
              end;
            THUNDER_3BITDELTAS: // 3-bit deltas
              begin
                Delta:=(N shr 3) and 7;
                if Delta<>DELTA3_SKIP then SetPixel(LastPixel+ThreeBitDeltas[Delta]);
                Delta:=N and 7;
                if Delta<>DELTA3_SKIP then SetPixel(LastPixel+ThreeBitDeltas[Delta]);
              end;
            THUNDER_RAW: // raw data
              SetPixel(N);
          end;
        end;
      Dec(UnpackedSize,FWidth);
    end;
end;

//----------------- TPCDDecoder ----------------------------------------------------------------------------------------

constructor TPCDDecoder.Create(Stream: PStream);
begin
  FStream:=Stream;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPCDDecoder.Decode(var Source,Dest: pointer; PackedSize,UnpackedSize: integer);
// recovers the Huffman encoded luminance and chrominance deltas
// Note: This decoder leaves a bit the way like the other decoders work.
//       Source points to an array of 3 pointers, one for luminance (Y, Luma), one for blue
//       chrominance (Cb, Chroma1) and one for red chrominance (Cr, Chroma2). These pointers
//       point to source and target at the same time (in place decoding).
//       PackedSize contains the width of the current subimage and UnpackedSize its height.
//       Dest is not used and can be nil.
type
  PPointerArray = ^TPointerArray;
  TPointerArray = array[0..2] of pointer;
  PPCDTable = ^TPCDTable;
  TPCDTable = record
    Length: byte;
    Sequence: cardinal;
    Key: byte;
    Mask: integer;
  end;
  PQuantumArray = ^TQuantumArray;
  TQuantumArray = array[0..3*256-1] of byte;
var
  Luma,Chroma1,Chroma2: PChar; // hold the actual pointers, PChar to easy pointer maths
  Width,Height: cardinal;
  PCDTable: array[0..2] of PPCDTable;
  I,J,K: cardinal;
  R: PPCDTable;
  RangeLimit: PQuantumArray;
  P,Q,Buffer: PChar;
  Accumulator,Bits,Length,Plane,Row: cardinal;
  PCDLength: array[0..2] of cardinal;

  //--------------- local function --------------------------------------------
  procedure PCDGetBits(N: cardinal);
  begin
    Accumulator:=Accumulator shl N;
    Dec(Bits,N);
    while Bits<=24 do
      begin
        if P>=(Buffer+$800) then
          begin
            FStream.Read(Buffer^,$800);
            P:=Buffer;
          end;
        Accumulator:=Accumulator or (cardinal(P^) shl (24-Bits));
        Inc(Bits,8);
        Inc(P);
      end;
  end;
  //--------------- end local function ----------------------------------------
var Limit: cardinal;
begin
  // place the used source values into local variables with proper names to make
  // their usage clearer
  Luma:=PPointerArray(Source)[0];
  Chroma1:=PPointerArray(Source)[1];
  Chroma2:=PPointerArray(Source)[2];
  Width:=PackedSize;
  Height:=UnpackedSize;
  // initialize Huffman tables
  ZeroMemory(@PCDTable,sizeof(PCDTable));
  GetMem(Buffer,$800);
  try
    Accumulator:=0;
    Bits:=32;
    P:=Buffer+$800;
    Limit:=1;
    if Width>1536 then Limit:=3;
    for I:=0 to Limit-1 do
      begin
        PCDGetBits(8);
        Length:=(Accumulator and $FF)+1;
        GetMem(PCDTable[I],Length*sizeof(TPCDTable));
        R:=PCDTable[I];
        for J:=0 to Length-1 do
          begin
            PCDGetBits(8);
            R.Length:=(Accumulator and $FF)+1;
            if R.Length>16 then
              begin
                if Assigned(Buffer) then FreeMem(Buffer);
                for K:=0 to 2 do
                if Assigned(PCDTable[K]) then FreeMem(PCDTable[K]);
                Exit;
              end;
            PCDGetBits(16);
            R.Sequence:=(Accumulator and $FFFF) shl 16;
            PCDGetBits(8);
            R.Key:=Accumulator and $FF;
            asm
              // R.Mask:=not ((1 shl (32-R.Length))-1);
              // asm implementation to avoid overflow errors and for faster execution
              MOV EDX,[R]
              MOV CL,32
              SUB CL,[EDX].TPCDTable.Length
              MOV EAX,1
              SHL EAX,CL
              DEC EAX
              NOT EAX
              MOV [EDX].TPCDTable.Mask,EAX
            end;
            Inc(R);
          end;
        PCDLength[I]:=Length;
      end;
    // initialize range limits
    GetMem(RangeLimit,3*256);
    try
      for I:=0 to 255 do
        begin
          RangeLimit[I]:=0;
          RangeLimit[I+256]:=I;
          RangeLimit[I+2*256]:=255;
        end;
      Inc(PByte(RangeLimit),255);
      // search for sync byte
      PCDGetBits(16);
      PCDGetBits(16);
      while (Accumulator and $00FFF000)<>$00FFF000 do PCDGetBits(8);
      while (Accumulator and $FFFFFF00)<>$FFFFFE00 do PCDGetBits(1);
      // recover the Huffman encoded luminance and chrominance deltas
      Length:=0;
      Plane:=0;
      Q:=Luma;
      repeat
        if (Accumulator and $FFFFFF00)=$FFFFFE00 then
          begin
            // determine plane and row number
            PCDGetBits(16);
            Row:=(Accumulator shr 9) and $1FFF;
            if Row=Height then Break;
            PCDGetBits(8);
            Plane:=Accumulator shr 30;
            PCDGetBits(16);
            case Plane of
              0: Q:=Luma+Row*Width;
              2: begin
                   Q:=Chroma1+(Row shr 1)*Width;
                   Dec(Plane);
                 end;
              3: begin
                   Q:=Chroma2+(Row shr 1)*Width;
                   Dec(Plane);
                 end;
            else Abort; // invalid/corrupt image
            end;
            Length:=PCDLength[Plane];
            Continue;
          end;
        // decode luminance or chrominance deltas
        R:=PCDTable[Plane];
        I:=0;
        while (I<Length) and ((Accumulator and R.Mask)<>R.Sequence) do
          begin
            Inc(I);
            Inc(R);
          end;
        if R=nil then
          begin
            // corrupt PCD image, skipping to sync byte
            while (Accumulator and $00FFF000)<>$00FFF000 do PCDGetBits(8);
            while (Accumulator and $FFFFFF00)<>$FFFFFE00 do PCDGetBits(1);
            Continue;
          end;
        if R.Key<128 then Q^:=Char(RangeLimit[ClampByte(Byte(Q^)+R.Key)]) else Q^:=Char(RangeLimit[ClampByte(Byte(Q^)+R.Key-256)]);
        Inc(Q);
        PCDGetBits(R.Length);
      until False;
    finally
      for I:=0 to 2 do if Assigned(PCDTable[I]) then FreeMem(PCDTable[I]);
      Dec(PByte(RangeLimit), 255);
      if Assigned(RangeLimit) then FreeMem(RangeLimit);
    end;
  finally
    if Assigned(Buffer) then FreeMem(Buffer);
  end;
end;

end.

