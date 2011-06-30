{***************************************
*** Another KOL introductory example ***
*** This little thingy shows how to  ***
*** use bitmap graphics in Kol       ***
*** Note that my code is not always  ***
*** necessaraly the smallest you can ***
*** achieve with Kol!                ***
****************************************
*** Freeware by Thaddy de Koning     ***
****************************************}

program KolBitmapDemo;

uses
Windows,
  Messages,
  Kol;

var
  //Applet,                {A main form or application}
  PaintBox:pControl;       {A simple static paintbox}
  BitMap:pBitmap;          {A bitmap}
  Dialog:pOpenSaveDialog;  {Our FileOpen Dialog}
  Menu:pMenu;              {And a menu}
  //Bitmap2:pBitmap;
{
This handles the OnPaint event from the Paintbox
It draws the bitmap on the PaintBox's Canvas}

procedure paint(dummy:pointer;sender:pcontrol;DC:HDC);
//var Rect:Trect;
begin
  Bitmap.Draw(DC,0,0);
end;

{This handles the Menuclicks}
procedure MenuClick(dummy:pointer;sender:pmenu;Item:integer);
begin
  begin
    case item of
    1:begin
        Dialog.execute;
        Bitmap.Clear;
        if Trim(Dialog.Filename)<> '' then
        begin
          {We have selected a file, Load it}
          Bitmap.LoadFromFile(Dialog.Filename);
          Applet.SimplestatusText:=Pchar(ExtractFileNameWOExt(Dialog.Filename));
          {Do some housekeeping}
          PaintBox.Width:=BitMap.Width;
          PaintBox.Height:=Bitmap.Height;
          Applet.ClientHeight:=Bitmap.Height + Applet.Border * 2;//Resizeparent doesnot work
        end;
      end;
    3:begin
        {Create simplest aboutbox}
        MsgOk('Kol Bitmap Viewer Demo'+
        #13#10+
        #13#10+
        'Does not support all palettes,'+
        #13#10+
        'so it may not always look good'+
        #13#10+
        #13#10+
        '(c)2001, Thaddy de Koning');
      end;
    end;
  end;
end;

begin
  {Create a form and set some defaults}
  Applet:=NewForm(Nil,'Kol Bitmap Viewer Demo').SetSize(400,250);
  Applet.CenterOnParent;
  {Create a statusbar to display filenames}
  Applet.SimplestatusText:='';

  {Create a FileOpen Dialog}
  Dialog:=NewOpenSaveDialog('Image','',[]);
  Dialog.Filename:='';
  Dialog.Filter:='Bitmap files|*.bmp';

  {Create a menu with just one item:File}
  {Menu:=}NewMenu(Applet,0,['&File','(','&Open',')','&Help','(','&About',')',''],TonMenuItem(MakeMethod(nil,@MenuClick)));

  {Create the Paintbox to draw the bitmap on}
  PaintBox:=NewPaintbox(Applet).setalign(caClient);
  PaintBox.OnPaint:=TOnPaint(MakeMethod(nil,@Paint));
  Paintbox.Transparent:=true;

  {Create the bitmap itself}
  BitMap:=NewBitMap(0,0);

  {Show some 'Art' by Thaddy de Koning}
  If FileExists('Kol.bmp')
    then Bitmap.LoadfromFile('Kol.bmp');

  {Run our application}
  Run(Applet);

  {Free the bitmap:it has no parent}
  Bitmap.free;
  {Free the dialog:it has no parent}
  Dialog.free;
end.
