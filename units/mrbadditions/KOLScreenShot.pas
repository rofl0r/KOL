unit KOLScreenShot;

interface

uses Windows, KOL;

function FullScreenShot(PixelFormat: TPixelFormat): PBitmap; //PixelFormat: pf32bit, pf24bit...

implementation

function FullScreenShot(PixelFormat: TPixelFormat): PBitmap;
var
  DC : HDC;
begin
 DC := GetDC (GetDesktopWindow);
 try
  Result:=NewDIBBitmap(
  GetDeviceCaps (DC, HORZRES),
  GetDeviceCaps (DC, VERTRES),
  PixelFormat);
  BitBlt(Result.Canvas.Handle,
         0,
         0,
         Result.Width,
         Result.Height,
         DC,
         0,
         0,
         SRCCOPY);
 finally
  ReleaseDC (GetDesktopWindow, DC);
 end;
end;

end.
