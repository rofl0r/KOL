{
       Unit: tdkfadercontrol
    purpose: part of several controls to construct audio/midi software in KOL
             I am planning to use this as a basis for
             a full Music Software Construction Kit
     Author: Thaddy de Koning
    Version: 0.80 BETA
  Copyright: MPL, Thaddy de Koning, 2003
    Remarks: XP plus Only, needs my GDIPLUS library (KOLGDIPV2.PAS)
             Drawing of the controls is done as cached bitmaps,
             so drawing is only done when a property has changed
             this way you spend the least amount of time in the UI
             and have more time for signalprocessing; I know this eats
             resources however.

             The fact that a fader looses the mousecapture when you leave its
             bounds with left mousebutton down is by design!
             If you don't want this, use OnMouseLeave (KOL) and
             SetCapture (Win32 API), to keep the Mouse captured even if you
             leave its bounds.

             The turning button code in tdkbuttons.pas contains example
             code for the above: that works just the opposite by design.

    *****************************************
    properties specific to the Fader Control:
    *****************************************

    property BtnLeft        sets left position of the Fader button

    property BtnTop         sets or determines the Visual fader position

    property BtnWidh        sets the width of the Fader button

    property BtnHeight      sets the height of the Fader button

    property btnValue       sets or gets the actual value of the Fader position
                            based on its range and the LogScale property

    property btnRange       Sets the maximum range between 0 and MAXINT of the
                            Fader Value.
                            Do not use with negative values, but scale them in
                            code.

                            *****
                            Tips:
                            *****
                            VST format is 0..1 as single, so divide
                            the value by the range to obtain VST compliant values
                            MIDI Short range is 0..127
                            Official MIDI Long range is 0..4096
                            Extended MIDI LONG spec is 0..65535
                            AUDIO DirectX volume range is 0..10000

    property LogScale       If true, the Fader value is calculated as an
                            inverse Log10 value, to accommodate use in Audio
                            Applications.
                            Unity gain is defined at -3Db below maximum or about
                            70% of maximum gain.
                            The recommended value for the Range is 10.000, which
                            corresponds to the resolution of the DirectX API's
                            for soundvolume.

    property Fadercolor1    Faders Main color, for now lighting is always
                            LeftTp to Right Bottom or the reverse.
                            Easy to change; See code in KOLGDIPV2

    property Fadercolor2    Fader Shadow Color, as above

    property OnChange       If assigned, the OnChange event is fired when the
                            Fader changes position,
                            This is the spot you would want to handle all
                            fader processing.

    *************************
    NOT FULLY IMPLEMENTED YET
    *************************
    The code can be even easier to use with ready-to-use simple
    bitmap, jpeg, gif or anything.
    Most of the code is already there. I just need to remove or
    alter the calls to RedrawBitmaps.
    This is very resource hungry if you compile them into the executable,
    so I do not intend to use it myself. But I have tested it with the
    GPImage objects from my KOLGDIPV@.pas library.
    The actual unit compiles smaller without the drawing routine
    if you load the bitmaps from file ;-)
    If you stick to GDIPLUS, wich is XP only-unless you install the
    ms gdiplus.dll (free) under 98,me or NT- you do not need any other KOL image
    libraries to handle almost all popular image file formats.
    See my KOLGDIPLUS packadge on the KOL website.
    ****************************************************************

    property BckImage       The background image of the fader

    property btnimage       The Fader Button

    property usebitmaps:    Not used yet,
                            means set to true to use predefined
                            set to false to use drawing as implemented.




   Controls: tdkFader
             tdkTurnButton
             tdkPressButton
             tdkPeakMeter
             tdkVUMeter
}
unit tdkfadercontrol;

interface
uses windows, Kol,{$IFDEF USE_ERR} kolmath, {$ENDIF} Messages, kolgdipv2;


type

  //Fader object
  ptdkFader = ^TtdkFader;
  TtdkFader = object(TControl)
  private
    function getbmp: boolean;
    procedure setbmp(const Value: boolean);
    function getcolor1: cardinal;
    function hetcolor2: cardinal;
    procedure setfdcolor2(const Value: cardinal);
    procedure setfdcolor1(const value:cardinal);
    function GetparameterDisplay: pcontrol;
    function GetparameterLabel: pcontrol;
    function Getparametername: pcontrol;
    procedure setparameterDisplay(const Value: pcontrol);
    procedure setparameterLabel(const Value: pcontrol);
    procedure setparametername(const Value: pcontrol);
  private
    function getrange: integer;
    procedure setrange(const Value: integer);
    function getlogscale: Boolean;
    procedure setlogscale(const Value: Boolean);
    function getimage: pBitmap;
    procedure setimage(const Value: pBitmap);
    function getbtnimage: pBitmap;
    procedure setbtnimage(const Value: pBitmap);
    procedure PaintFader( Sender: PControl; DC: HDC );
    procedure SetBtnTop(const place:integer);
    function  GetBtnTop:integer;
    procedure SetBtnLeft(const place:integer);
    function  GetBtnLeft:integer;
    procedure SetBtnWidth(const place:integer);
    function  GetBtnWidth:integer;
    procedure SetBtnHeight(const place:integer);
    function  GetBtnHeight:integer;
    procedure SetBtnValue(const value:integer);
    function  GetBtnValue:integer;
    procedure Redrawbitmaps;

    // For future expansion with provided bitmaps
    // instead of the cached but internally drawn bitmaps
    property BckImage:pBitmap read getimage write setimage;
    property btnimage:pBitmap read getbtnimage write setbtnimage;
    property usebitmaps:boolean read getbmp write setbmp;
  public
    destructor destroy;virtual;
    property BtnLeft:integer read getbtnleft write setbtnleft default 0;
    property BtnTop:integer read getbtntop write setbtntop default 15;
    property BtnWidh:integer read getbtnwidth write setbtnwidth;
    property BtnHeight:integer read GetBtnHeight write setbtnheight default 30;
    property btnValue:integer read getbtnvalue write setbtnvalue;
    property btnRange:integer read getrange write setrange;
    property LogScale:Boolean read getlogscale write setlogscale;
    property Fadercolor1:cardinal read getcolor1 write setfdcolor1;
    property Fadercolor2:cardinal read hetcolor2 write setfdcolor2;
    property ParameterName:pcontrol read Getparametername write setparametername;
    property ParameterLabel:pcontrol read GetparameterLabel write setparameterLabel;
    property ParameterDisplay:pcontrol read GetparameterDisplay write setparameterDisplay;
  end;



  function NewFader(aOwner:pControl;Horizontal:Boolean =false;EdgeStyle:TEdgeStyle = esNone):pTdkFader;
  function NewTdkBitmap(aOwner:pControl;width,height:integer;Color1,color2:Cardinal):pBitmap;
  
implementation

type
  //Fader data object;

  PFaderData = ^TFaderData;
  TFaderData = object(Tobj)
  private
    color1,color2:cardinal;
    Image,
    BtnImage:pBitmap;
    BtnTop,
    BtnLeft,
    BtnWidth,
    btnHeight,
    btnValue,
    btnRange:integer;
    btnLog,
    Usebmp:Boolean;
    paraName,
    paraLabel,
    paradisplay:pControl;
  end;

function NewTdkBitmap(aOwner:pControl;width,height:integer;Color1,color2:Cardinal):pBitmap;
begin
  Result:=NewBitmap(width*2,height);
  gdiplus.DeviceContext:=Result.canvas.Handle;
  gdiplus.Brush:=NewgpLinearGradientBrush(makerect(0,0,width,height),color1,color2,lineargradientmodeforwarddiagonal);
  gdiplus.FillRectangle(0,0,width,height);
  //Just inverse the lighting...
  gdiplus.Brush:=NewgpLinearGradientBrush(makerect(width,0,width*2,height),color2,color1,lineargradientmodeforwarddiagonal);
  gdiplus.FillRectangle(width,0,width*2,height);
  gdiplus.DeviceContext:=aOwner.canvas.Handle;
  {???}result.Draw(result.canvas.handle,0,0);{why???}
end;


{$IFNDEF USE_ERR}
//from KOL.PAS, this is the only dependancy from the KOLMATH unit.
function Log10(X: Extended): Extended;
  { Log.10(X) := Log.2(X) * Log.10(2) }
asm
        FLDLG2     { Log base ten of 2 }
        FLD     X
        FYL2X
        FWAIT
end;
{$ENDIF}

  function FaderWndProc( Sender: PControl; var Msg: TMsg; var Rslt: Integer ): Boolean;
  begin
    Result:=False;
    case Msg.message of
      WM_MOUSEMOVE,WM_LBUTTONDOWN:
        begin
          if (msg.wParam and MK_LBUTTON ) > 0 then
          begin
            ptdkFader(sender).BtnTop:=Min(Max(SmallpointToPoint(Tsmallpoint(Msg.LParam)).Y-ptdkFader(sender).btnHeight div 2,0),sender.ClientHeight-ptdkfader(sender).BtnHeight);
            setcapture(sender.Handle);
            sender.Invalidate;
            if assigned(sender.OnChange) then sender.OnChange(sender);
            result:=true;
          end;
        end;
        WM_LBUTTONUP:releaseCapture;
        WM_SIZE:
          // Seems expensive but is received only
          // once per change of a visual property
          // for each individual control
          ptdkfader(sender).redrawbitmaps;
          //
       // WM_ERASEBKGND:
       //   ptdkFader(sender).bckimage.Draw(sender.canvas.Handle,0,0);
      end;
  end;


function NewFader(aOwner:pControl;Horizontal:Boolean = false;EdgeStyle:TEdgeStyle = esNone):pTdkFader;
var
  data:pFaderData;
  btnRect:Trect;
begin
  New(Data,Create);
  if Horizontal then
    Result:=pTdkFader(NewPanel(aOwner,Edgestyle).SetSize(200,40))

  else
    Result:=pTdkFader(NewPanel(aOwner,Edgestyle).SetSize(30,200));
  aOwner.Add2AutoFree(Result);
  with result^do
  begin
    CustomObj:=Data;
    AttachProc(@FaderWndProc);
    DoubleBuffered:=false;
    OnPaint:=PaintFader;
    data.color1:=white;
    data.color2:=black;
    data.btnHeight:=30;
    data.btnTop:=Clientheight-btnheight;
    data.btnrange:=100;
    data.btnlog:=false;

    bckimage:=newbitmap(clientwidth,clientheight);
    Add2AutoFree(bckImage);
    btnimage:=newbitmap(clientwidth-4,btnheight);
    Add2AutoFree(btnImage);
    btnvalue:=0;
    redrawbitmaps;
  end;
end;


{ TtdkFader }


procedure TtdkFader.Redrawbitmaps;
var
 DC:HDC;
 i:integer;
 LineLength:integer;
begin
   if (bckimage=nil) or (btnimage=nil) then exit;
      DC:=parent.canvas.Handle;
      bckimage.Width:=clientwidth;
      bckimage.Height:=clientheight;
      btnimage.Width:=clientwidth-4;
      btnimage.Height:=btnheight;

      //Draw a cached image of the background bitmap
      gdiplus.DeviceContext:=bckimage.canvas.Handle;
      gdiplus.Brush:=NewGPLinearGradientBrush(bckimage.BoundsRect,pfaderdata(customobj).color1,pFaderdata(Customobj).color2,lineargradientmodeforwarddiagonal);
      gdiplus.FillRectangle(bckImage.BoundsRect);
      gdiplus.Pen:=NewGPPen(Black,2);
      gdiplus.Drawline(bckimage.Width div 2 ,btnheight div 2 , bckimage.Width div 2 , bckimage.Height-btnheight div 2);
      LineLength:=bckimage.Height div 20;
      gdiplus.Pen.width:=1;
      for i:=0 to 19 do
       gdiplus.Drawline(bckimage.width div 2 - 5,(btnimage.Height div 2)+linelength *i, bckimage.Width div 2 +5,(btnimage.Height div 2) +linelength *i);

      //The button
      gdiplus.DeviceContext:=btnimage.canvas.Handle;
      Gdiplus.Brush:=NewGPlinearGradientBrush(MakeRect(0,0,clientwidth-4,btnheight)
         ,pfaderdata(customobj).color1,pfaderdata(Customobj).color2,lineargradientmodeforwarddiagonal);
      gdiplus.FillRectangle(MakeRect(0,0,clientwidth-4,btnheight));
      gdiplus.Pen.width:=2;
      gdiplus.Drawline(0,btnheight div 2, clientwidth - 4,btnheight div 2);

      // bug in gdiplus.dll?? Have to switch it back by hand
      gdiplus.DeviceContext:=DC;

      //Force the fader into view
      setbtntop(height-btnheight);
end;

procedure TtdkFader.setbmp(const Value: boolean);
begin
  pFaderdata(customobj).Usebmp:=value;
end;

procedure TtdkFader.SetBtnHeight(const place: integer);
begin
    pFaderdata(CustomObj).BtnHeight:=place;
    redrawbitmaps;
end;

procedure TtdkFader.setbtnimage(const Value: pBitmap);
begin
  pfaderdata(customobj).BtnImage:=value;
end;

procedure TtdkFader.SetBtnLeft(const place: integer);
begin
   pFaderdata(customObj).btnleft:=place;
   redrawbitmaps;
end;

procedure TtdkFader.SetBtnTop(const place: integer);
var
  Value:extended;
begin
  with pFaderData(CustomObj)^ do
  begin
    BtnTop:=place;
    if Logscale=false then
       btnValue:=btnrange -(btntop * btnrange div (clientheight-btnheight))
    else
      begin
        Value:=log10( {1 = fix-up } 1 + btnTop*btnRange / (clientheight-btnheight));
        btnValue:=Round(btnrange- (value * btnRange / log10(btnRange)));
      end;
  end;
end;

procedure TtdkFader.SetBtnValue(const value: integer);
begin
    setbtntop((clientheight-btnheight)-(ClientHeight-btnheight) * Value div btnrange);
    invalidate;
end;

procedure TtdkFader.SetBtnWidth(const place: integer);
begin
  pFaderData(CustomObj).Btnwidth:=place;
  redrawbitmaps;
end;

procedure TtdkFader.setfdcolor1(const value: Cardinal);
begin
 pFaderdata(Customobj).color1:=value;
 redrawbitmaps;
end;

procedure TtdkFader.setfdcolor2(const Value: cardinal);
begin
 pFaderdata(Customobj).color2:=value;
 redrawbitmaps;
end;

procedure TtdkFader.setimage(const Value: pBitmap);
begin
  pFaderdata(CustomObj).Image:=value;
end;

procedure TtdkFader.setlogscale(const Value: Boolean);
begin
  pFaderData(Customobj).btnLog:=value;
end;

procedure TtdkFader.setrange(const Value: integer);
begin
  with pFaderdata(Customobj)^ do
    btnRange:=value;
end;


destructor TtdkFader.destroy;
begin
 CustomObj.free;
 inherited;
end;

function TtdkFader.getbmp: boolean;
begin
  result:=pFaderdata(customobj).Usebmp;
end;

function TtdkFader.GetBtnHeight: integer;
begin
   Result:=pFaderdata(CustomObj).BtnHeight;
end;

function TtdkFader.getbtnimage: pBitmap;
begin
 result:=pfaderdata(customobj).BtnImage;
end;

function TtdkFader.GetBtnLeft: integer;
begin
 Result:=pFaderdata(CustomObj).btnLeft;
end;

function TtdkFader.GetBtnTop: integer;
begin
  Result:=pFaderdata(CustomObj).BtnTop;
end;

function TtdkFader.getbtnvalue: integer;
begin
 Result:=pFaderdata(Customobj).btnValue;
end;


function TtdkFader.GetBtnWidth: integer;
begin
 Result:=pFaderdata(CustomObj).BtnWidth;
end;

function TtdkFader.getcolor1: cardinal;
begin
 Result:=pFaderdata(Customobj).color1;
end;

function TtdkFader.getimage: pBitmap;
begin
 result:=pFaderdata(CustomObj).image;
end;

function TtdkFader.getlogscale: Boolean;
begin
 result:=pFaderData(Customobj).btnLog;
end;

function TtdkFader.getrange: integer;
begin
  result:=pFaderdata(Customobj).btnRange;
end;

function TtdkFader.hetcolor2: cardinal;
begin
   Result:=pFaderdata(Customobj).color2;
end;

procedure TtdkFader.PaintFader(Sender: PControl; DC: HDC);
begin
  bckimage.Draw(dc,0,0);
  btnimage.Draw(dc,btnleft+2,btntop);
end;


function TtdkFader.GetparameterDisplay: pcontrol;
begin
 Result:=pFaderdata(CustomObj).paraDisplay;
end;

function TtdkFader.GetparameterLabel: pcontrol;
begin
  Result:=pFaderdata(CustomObj).paralabel;
end;

function TtdkFader.Getparametername: pcontrol;
begin
  Result:=pFaderdata(CustomObj).paraname;
end;

procedure TtdkFader.setparameterDisplay(const Value: pcontrol);
begin
  pFaderdata(CustomObj).paradisplay:=value;
end;

procedure TtdkFader.setparameterLabel(const Value: pcontrol);
begin
   pFaderdata(CustomObj).paraLabel:=value;
end;

procedure TtdkFader.setparametername(const Value: pcontrol);
begin
    pFaderdata(CustomObj).paraName:=value;
end;

end.
