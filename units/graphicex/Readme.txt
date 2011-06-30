//////////////////////////////////////////////////////////////////////////////////
//										//
//	KOLGraphicEx - unit for load and view images				//
//	convert to KOl by Dimaxx (dimaxx@atnet.ru)				//
//										//
//	Based on GraphicEx v9.9 by Mike Lischke					//
//										//
//	GraphicEx for Delph (c) Copyright 1999,2000  Dipl. Ing.			//
//	Mike Lischke (public@lischke-online.de). All rights reserved.		//
//										//
//	Support imeges:								//
//										//
//		Silicon Graphic Images (*.bw, *.rgb, *.rgba, *.sgi)		//
//		Autodesk Images (*.cel, *.pic)					//
//		TIFF Images (*.tif, *.tiff)					//
//		Enhanced PostScript images (*.eps)				//
//		Targa Images (*.tga; *.vst; *.icb; *.vda; *.win)		//
//		ZSoft PCX Images (*.pcx; *.dcx, *.pcc; *.scr)			//
//		Kodak Photo CD Images (*.pcd)					//
//		Portable Map Graphic Images (*.ppm, *.pgm, *.pbm)		//
//		Dr. Halo Images (*.cut + *.pal)					//
//		CompuServe GIF Images (*.gif)					//
//		RLA Images (*.rla, *.rpf)					//
//		Photoshop Images (*.psd, *.pdd)					//
//		Paint Shop Pro Images file version 3 & 4 (*.psp)		//
//		Portable Network Graphic Images (*.png)				//
//										//
//	Compression support:							//
//										//
//		LZW (Lempel-Ziff-Welch)		   TIF/TIFF			//
//		RLE (run length encoding)	   TGA,PCX,SGI,CUT,RLA,PSP	//
//		Packbits			   TIF/TIFF			//
//		CCITT				   TIF/TIFF			//
//			raw G3 (fax T.4)					//
//			modified G3 (CCITT RLE)					//
//			modified G3 w/ word alignment (CCITT RLEW)		//
//		LZ77				   PNG				//
//		Thunderscan			   TIF/TIFF			//
//		PCD Huffmann encoding (photo CD)   PCD				//
//////////////////////////////////////////////////////////////////////////////////

Sample load and view for all images (exclude TCUTGraphic)

...
var F: PStream;
    BMP: PBitmap;
    GE: TTIFFGraphic;
begin
  GE:=TTIFFGraphic.Create;
  F:=NewReadFileStream('test.tif');
  GE.LoadFromStream(F);
  BMP:=NewBitmap(0,0);
  BMP.Assign(GE.Bitmap);
  GE.Free;
  BMP.Draw(Form.Canvas.Handle,0,0);
  BMP.Free;
end;

//////////////////////////////////////////////////////////////////////////////////

Sample for TCUTGraphic

...
var F: PStream;
    BMP: PBitmap;
    GE: TCUTGraphic;
begin
  GE:=TCUTGraphic.Create;
  F:=NewReadFileStream('test.cut');
  GE.PaletteFile:='test.pal';		// Set palette file
  GE.LoadFromStream(F);
  BMP:=NewBitmap(0,0);
  BMP.Assign(GE.Bitmap);
  GE.Free;
  BMP.Draw(Form.Canvas.Handle,0,0);
  BMP.Free;
end;
