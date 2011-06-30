program KOLCrtTest;
{$APPTYPE CONSOLE}

uses
  KOL,
  CRT4KOL;

var W, W2: PWindow;
    C: Char;

begin
  UseInputOutput;

  // test 1
  foreground( colorCyan or colorLight );
  outch( 'a' );
  background( colorGreen );
  outch( 'b' );
  foreground( colorYellow or colorLight );
  gotoXY( 10, 10 );
  outs( 'qwertyuiop'#1#2#3#4#5#6#7#8#9'A'#10#11#12#13#14#15'10'#16#17#18#19#20#21#22#23#24#25#26#27#28#29#30#31#32#33 );
  background( colorBlack );
  foreground( colorWhite );

  ReadLn;

  //test2
  W := NewWindow( nil, 11, 12, 22, 6, colorBlue );
  W.Title := 'Hello!';
  W.FrameStyle := fsDouble;

  W2 := NewWindow( nil, 22, 7, 44, 15, colorRed );
  W2.Title := 'Another';
  W2.FrameStyle := fsHash1;

  inputmode( Console, imNoEcho );
  C := inputch;

  //ReadLn;

  W.Active := TRUE;
  //ReadLn;
  C := inputch;

  //test3
  cls;
  //ReadLn;
  C := inputch;

end.
