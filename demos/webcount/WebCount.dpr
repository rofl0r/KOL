{  
  Простейший cgi скрипт счетчика,   применяет юнит KEY OBJECTS LIBRARY  и
  JpegObj  (см сайт http://xcl.cjb.net/)

  Скрипт  интересен  тем  что  вывод  картинки  происходит  не  по  заранее
  подготовленных images цифр а генерируется на лету в память применяя любой 
  шрифт установленный в системе. 
  
  И еще интересно то что скомпилированный скрипт весит ~83Кб, 
  если прибегнуть к стандартным библиотекам то такой скрипт займет 
  ~424Кб что делает несомненный плюс в сторону применения KEY OBJECTS LIBRARY

 http://pascal.vov.ru/
 sofandr@mail.ru
 Andrey Ch
}
{$APPTYPE CONSOLE}
uses 
Windows, SysUtils, KOL, JpegObj;


var
//i : integer;
bmp : PBitmap; 
Jpg: PJpeg; 
nHit: Integer;
LogFile: Text;
LogFileName: string;
PicStream:PStream; 
Buffer : DWord;
Count  : DWord;
i : integer;


Begin

  LogFileName := 'WebCont.log';
  System.Assign (LogFile, LogFileName);
  try
    // read if the file exists
    if FileExists (LogFileName) then
    begin
      Reset (LogFile);
      Readln (LogFile, nHit);
      Inc (nHit);
    end
    else
      nHit := 0;
    // saves the new data
    Rewrite (LogFile);
    Writeln (LogFile, nHit);
  finally
    Close (LogFile);
  end;





bmp := NewBitmap( 0, 0);  
//Bmp.Draw( DC, 0, 0 );
//bmp.BkColor :=  clBlack;
bmp.Width   :=  131;
bmp.Height  :=  20;
//bmp.canvas.Brush.Color := clWhite;
//bmp.canvas.FrameRect( MakeRect( 0, 0, 131, 20 ) );
//bmp.canvas.Brush.Color := clWhite;

bmp.canvas.Brush.BrushStyle := bsClear;
//bmp.canvas.Font.Color := clFuchsia;
bmp.canvas.Font.FontStyle := [fsBold];
bmp.canvas.Font.FontName := 'Verdana';
bmp.canvas.Font.FontHeight := 16;
bmp.canvas.Font.Color := clRed;
//bmp.canvas.TextOut( 1, 1, 'Пример работы' );
bmp.canvas.Brush.BrushStyle := bsSolid;
bmp.canvas.TextOut (2, 2, 'Hits: ' + FormatFloat ('###,###,###', Int (nHit)));
 
//bmp.canvas.FillRect( MakeRect( 0, 0, 200, 200 ) );  //®зЁбвЄ  ®Ў« бвЁ
//bmp.canvas.LineTo( 200, 200 ); 
// pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit, pfCustom 
bmp.PixelFormat := pf8bit; // устанавливаем формат пикселя 8 бит
//bmp.SaveToFile('dd.bmp'); 
//bmp.canvas.TextOut( 100, 100, 'te'); 


//JPG := NewBitmap(0,0);

Jpg := NewJpeg;
Jpg.Bitmap := Bmp;
Jpg.CompressionQuality := 100;
Jpg.ProgressiveEncoding := True;
//if Jpg.Corrupted = True Then Writeln('image is corrupted');
//Jpg.SaveToFile('dd.jpg');


PicStream := NewMemoryStream;  // создаем поток
Jpg.SaveToStream(PicStream);   // записываем в поток картинку счетчика


WriteLn('Content-type: image/jpeg');     // cообщаем серверу что высылаем  JPEG
WriteLn('Content-length: ', PicStream.Size);  // длиной  PicStream.Size
WriteLn('Accept-Ranges: bytes');
WriteLn;



PicStream.Position := 0;     // устанавливаем позицию в потоке на 1
Buffer := 1;
Count := 1;
for i:=1 to PicStream.Size do      // выводим JPEG в консоль 
begin
PicStream.Read(Buffer,  Count); 
Write(Char(Buffer));  
end;




Bmp.Free; // освобождаем память от битмапа
Jpg.Free;  // освобождаем память от JPEG'а
PicStream.free; // освобождаем память от потока


  




End.
