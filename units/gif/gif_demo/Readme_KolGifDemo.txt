This is the demo project, which shows advantages of KolGif unit,
provided with KOL ( http://xcl.cjb.net ). It is tested with Delphi5.
To test it with another Delphi version, You should create similar
project using MCK (or by hand, i.e. non-visually, if You can), and
copy needed pieces of code there from demo project sources. Sorry,
but this inconvenience is only because Inprise always supports
incompatibility of dfm file format from version to version.

You should have both KOL and MCK installed. 

To compile project, change KOLProject1: TKOLProject property sourcePath
typing there correct path to a folder where You unpack the demo project.

Also, before running the project, change a constant ImagesPath assigning 
a path to the folder containing some gif files.

You can comment/uncomment three options provided: STRETCHED, NOMASKEDGIF
and GIFDECODERONLY and see how this affects the size of executable file.

Run and enjoy!
------------------------------------------------------------------------
Copyright (C) 2001 by Vladimir Kladov		mailto: bonanzas@xcl.cjb.net
						http://xcl.cjb.net