unit KOLPcx;
{* PCX - PC Paintbrush format (ZSoft) support for KOL.
 (C) by Kladov Vladimir 30-Sep-2002
 ( bonanzas@xcl.cjb.net, http://xcl.cjb.net )
 v1.0 - reading PCX only (it is converted to DIB bitmap when loaded)
}

interface

{$RANGECHECKS OFF}

uses
 Windows, KOL;


type
  TRGBPixel = packed record
    R, G, B: Byte;
  end;

  PPCXHeader = ^TPCXHeader;
  TPCXHeader = packed record
    Manufacturer      : Byte; //Постоянный флаг 10 = ZSoft .PCX
    Version           : Byte; //0 = Версия 2.5
                              //2 = Версия 2.8 с информацией о палитре
                              //3 = Версия 2.8 без информации о палитре
                              //5 = Версия 3.0
    Encoding          : Byte; //1 = .PCX кодирование длинными сериями
    BitsPerPixel      : Byte; //Число бит на пиксел в слое
    Xmin              : Word; //Размеры изображения (Xmin, Ymin) - (Xmax, Ymax) в пикселах включительно
    Ymin              : Word;
    Xmax              : Word;
    Ymax              : Word;
    Hres              : Word; //Горизонтальное разрешение создающего устройства
    Vres              : Word; //Вертикальное разрешение создающего устройства
    ColorMap          : array[ 0..15 ] of TRGBPixel;
    Reserved          : Byte;
    NPlanes           : Byte; //Число цветовых слоев
    BytesPerLine      : Word; //Число байт на строку в цветовом слое
                              //(для PCX-файлов всегда должно быть четным)
    PaletteInfo       : Byte; //Как интерпретировать палитру:
                              //1 = цветная/черно-белая,
                              //2 = градации серого
    Filler            : array[ 0..58 ] of Byte; // нули
  end;

  PPCX = ^TPCX;
  TPCX = object( TObj )
  {* PCX implementation object}
  protected
    //FError: TPCXError;
    FBitmap: PBitmap;
  protected
    {Returns image width and height}
    function GetWidth: Integer;
    function GetHeight: Integer;
    {Returns if the image is empty}
    function GetEmpty: Boolean;
  public
    procedure Clear;
    {Draws the image into a canvas}
    procedure Draw(DC: HDC; X, Y: Integer);
    procedure StretchDraw( DC: HDC; const Rect: TRect );
    {Width and height properties}
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    {Property to return if the image is empty or not}
    property Empty: Boolean read GetEmpty;
    {Object being created and destroyed}
    destructor Destroy; virtual;
    function LoadFromFile(const Filename: String): Boolean;
    //procedure SaveToFile(const Filename: String);
    function LoadFromStream(Stream: PStream): Boolean;
    //procedure SaveToStream(Stream: PStream);
    {Loading the image from resources}
    function LoadFromResourceName(Instance: HInst; const Name: String): Boolean;
    function LoadFromResourceID(Instance: HInst; ResID: Integer): Boolean;
    {}
    property Bitmap: PBitmap read FBitmap;
  end;

function NewPCX: PPCX;

implementation

function NewPCX: PPCX;
begin
  new( Result, Create );
end;

{ TPCX }

procedure TPCX.Clear;
begin
  Free_And_Nil( FBitmap );
end;

destructor TPCX.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TPCX.Draw(DC: HDC; X, Y: Integer);
begin
  if Empty then Exit;
  FBitmap.Draw( DC, X, Y );
end;

function TPCX.GetEmpty: Boolean;
begin
  Result := (FBitmap=nil) or FBitmap.Empty;
end;

function TPCX.GetHeight: Integer;
begin
  if Empty then
    Result := 0
  else
    Result := FBitmap.Height;
end;

function TPCX.GetWidth: Integer;
begin
  if Empty then
    Result := 0
  else
    Result := FBitmap.Width;
end;

function TPCX.LoadFromFile(const Filename: String): Boolean;
var Strm: PStream;
begin
  Strm := NewReadFileStream( Filename );
  Result := LoadFromStream( Strm );
  Strm.Free;
end;

function TPCX.LoadFromResourceID(Instance: HInst; ResID: Integer): Boolean;
var Strm: PStream;
begin
  Strm := NewMemoryStream;
  Resource2Stream( Strm, Instance, PChar( ResID ), RT_RCDATA );
  Strm.Position := 0;
  Result := LoadFromStream( Strm );
  Strm.Free;
end;

function TPCX.LoadFromResourceName(Instance: HInst; const Name: String): Boolean;
var Strm: PStream;
begin
  Strm := NewMemoryStream;
  Resource2Stream( Strm, Instance, PChar( Name ), RT_RCDATA );
  Strm.Position := 0;
  Result := LoadFromStream( Strm );
  Strm.Free;
end;

function TPCX.LoadFromStream(Stream: PStream): Boolean;
type
  TRGBPixelExt = packed record
    Pixel: TRGBPixel;
    Dummy: Byte;
  end;
var
  StartPos: DWORD;

    procedure Decode;
    var Header: TPCXHeader;
        Format: TPixelFormat;
        Buffer, Dest, Src, SrcBuf: PByte;
        W, H, ImgSize, I, BitIdx, X, SrcSize: Integer;
        B, B1, B2, B3, B4: Byte;
        RGBPixelExt: TRGBPixelExt;
    begin
      Result := FALSE;
      Clear;
      if Stream.Read( Header, Sizeof( Header ) ) < Sizeof( Header ) then Exit;
      if Header.Manufacturer <> 10 then Exit;
      if (Header.BitsPerPixel = 1) and (Header.NPlanes = 1) then
        Format := pf1bit
      else
      if (Header.BitsPerPixel = 1) and (Header.NPlanes = 4) or
         (Header.BitsPerPixel = 4) and (Header.NPlanes = 1) then
        Format := pf4bit
      else
      if (Header.BitsPerPixel = 8) and (Header.NPlanes = 1) then
        Format := pf8bit
      else
      if (Header.BitsPerPixel = 8) and (Header.NPlanes = 3) then
        Format := pf24bit
      else
        Exit;

      W := Header.Xmax - Header.Xmin + 1;
      H := Header.Ymax - Header.Ymin + 1;
      ImgSize := Header.NPlanes * Header.BytesPerLine * H;
      GetMem( Buffer, ImgSize );
      if Buffer = nil then Exit;

      //-------------------- декодирование ----------------------
      SrcSize := Stream.Size - Stream.Position;
      if SrcSize > ImgSize * 2 then
        SrcSize := ImgSize * 2;
      GetMem( SrcBuf, SrcSize );
      SrcSize := Stream.Read( SrcBuf^, SrcSize );
      Src := SrcBuf;
      Dest := Buffer;
      while (DWORD( Dest ) < DWORD( Buffer ) + DWORD( ImgSize ) ) and
            (DWORD( Src ) < DWORD( SrcBuf ) + DWORD( SrcSize ) ) do
      begin
        //Stream.Read( B, 1 );
        B := Src^; Inc( Src );
        if B >= $C0 then
        begin
          I := B and $3F;
          //Stream.Read( B, 1 );
          B := Src^; Inc( Src );
          for I := I-1 downto 0 do
          begin
            Dest^ := B; Inc( Dest );
          end;
        end
          else
        begin
          Dest^ := B; Inc( Dest );
        end;
      end;
      //Stream.Position := StartPos + Sizeof( Header ) + DWORD( Src ) - DWORD( SrcBuf );
      FreeMem( SrcBuf );

      FBitmap := NewDIBBitmap( W, H, Format );
      //-------------------- формирование изображения ------------------------
      if (Format = pf4bit) and (Header.NPlanes = 4) then
      begin
        for I := 0 to H-1 do
        begin
          Dest := FBitmap.ScanLine[ I ];
          BitIdx := 8;
          B1 := 0; B2 := 0; B3 := 0; B4 := 0;
          Src := Pointer( Integer( Buffer ) + Header.BytesPerLine * 4 * I );
          for X := 0 to W div 2 - 1 do
          begin
            if BitIdx >= 8 then
            begin
              BitIdx := 0;
              B1 := Src^;
              B2 := PByte( Integer( Src ) + Header.BytesPerLine )^;
              B3 := PByte( Integer( Src ) + Header.BytesPerLine * 2 )^;
              B4 := PByte( Integer( Src ) + Header.BytesPerLine * 3 )^;
              Inc( Src );
            end;
            B := ((B1 and $80) shr 3) or ((B2 and $80) shr 2) or ((B3 and $80) shr 1) or (B4 and $80)
              or ((B1 and $40) shr 6) or ((B2 and $40) shr 5) or ((B3 and $40) shr 4) or ((B4 and $40) shr 3);
            B1 := B1 shl 2;
            B2 := B2 shl 2;
            B3 := B3 shl 2;
            B4 := B4 shl 2;
            Dest^ := B;
            Inc( Dest );
            Inc( BitIdx, 2 );
          end;
        end; // конец загрузки 16-цветного изображения по слоям
      end
        else
      if Format = pf24bit then
      begin
        for I := 0 to H-1 do
        begin
          Dest := FBitmap.ScanLine[ I ];
          Src := PByte( Integer( Buffer ) + Header.BytesPerLine * 3 * I );
          for X := 0 to W-1 do
          begin
            B1 := Src^;
            B2 := PByte( Integer( Src ) + Header.BytesPerLine )^;
            B3 := PByte( Integer( Src ) + Header.BytesPerLine*2 )^;
            Dest^ := B3; Inc( Dest );
            Dest^ := B2; Inc( Dest );
            Dest^ := B1; Inc( Dest );
            Inc( Src );
          end;
        end; // конец загрузки монохромного, 256-цветного изображения
      end
        else
      //if (Format in [pf8bit,pf1bit]) or ((Format = pf4bit) and (Header.NPlanes = 1)) then
      begin
        Src := Buffer;
        for I := 0 to H-1 do
        begin
          Dest := FBitmap.ScanLine[ I ];
          Move( Src^, Dest^, Header.BytesPerLine );
          if Format = pf4bit then
          begin
            for X := 0 to W div 2 - 1 do
            begin
              B := Dest^;
              B := ((B and $11) shl 2) or ((B and $44) shr 2) or
                   (B and $AA);
              Dest^ := B;
              Inc( Dest );
            end;
          end;
          Inc( Src, Header.BytesPerLine );
        end; // конец загрузки монохромного, 256-цветного изображения или 16-цветного в одном слое
      end;
      //----------- загрузка палитры ------------------
      if Format = pf8bit then
      begin
        B := 0;
        if Stream.Size > 768 then
        begin
          Stream.Position := Stream.Size - 769;
          Stream.Read( B, 1 );
        end;
        if (Header.Version in [2,5]) and (B in [10,12]) then
        begin // есть своя палитра, прочитаем
          RGBPixelExt.Dummy := 0;
          GetMem( SrcBuf, 768 );
          Stream.Read( SrcBuf^, 768 );
          Src := SrcBuf;
          for I := 0 to 255 do
          begin
            RGBPixelExt.Pixel.B := Src^; Inc( Src );
            RGBPixelExt.Pixel.G := Src^; Inc( Src );
            RGBPixelExt.Pixel.R := Src^; Inc( Src );
            if B = 10 then
            begin
              RGBPixelExt.Pixel.R := RGBPixelExt.Pixel.R shl 2;
              RGBPixelExt.Pixel.G := RGBPixelExt.Pixel.G shl 2;
              RGBPixelExt.Pixel.B := RGBPixelExt.Pixel.B shl 2;
            end;
            FBitmap.DIBPalEntries[ I ] := Integer( RGBPixelExt );
          end;
          FreeMem( SrcBuf );
        end;
      end
        else
      if Format in [pf1bit, pf4bit] then
      begin  // загрузка палитры для 16-цветных или монохромных изображений
        RGBPixelExt.Dummy := 0;
        for I := 0 to FBitmap.DIBPalEntryCount-1 do
        begin
          RGBPixelExt.Pixel := Header.ColorMap[ I ];
          B := RGBPixelExt.Pixel.R;
          RGBPixelExt.Pixel.R := RGBPixelExt.Pixel.B;
          RGBPixelExt.Pixel.B := B;
          FBitmap.DIBPalEntries[ I ] := Integer( RGBPixelExt );
        end;
      end;
      FreeMem( Buffer );
      Result := TRUE;
    end;
begin
  StartPos := Stream.Position;
  Decode;
  if not Result then
    Stream.Position := StartPos;
end;

{procedure TPCX.SaveToFile(const Filename: String);
var Strm: PStream;
begin
  if Empty then Exit;
  Strm := NewWriteFileStream( Filename );
  SaveToStream( Strm );
  Strm.Free;
end;

procedure TPCX.SaveToStream(Stream: PStream);
begin

end;}

procedure TPCX.StretchDraw(DC: HDC; const Rect: TRect);
begin
  if Empty then Exit;
  FBitmap.StretchDraw( DC, Rect );
end;

end.
