unit democtrl;
//
// purpose: How to write a simple KOL control part 1
//  author: © 2004, Thaddy de Koning
// Remarks: This a simple trackbar like control for audio
//          It is derived from a simple panel, but could have been derived
//          from a paintbox too. The panel has some extra possibilities, like
//          borders and some extra built in message processing that is helpfull.
//          We employ a simple technique that has two drawing routines.
//          One draws a background on a bitmap that stays buffered.
//          One draws the ticker or indicator and uses simple xor painting
//          The colors of the tracker are stored in the color, color1 and color2
//          properties of the panel. The tracker position is returned in the
//          panel's tag.
//          All other information needed is stored in a data object that is
//          attached to the panel's CustomObj property.
//          The Min and Max values are set at creation time in the constructor
//          function.
//          All tracker specific messahges will be handled in a special wndproc
//          that we attach to the panel.
//          What we have is a clean KOL control.

interface
uses
  windows, messages, kol;

type
  PTrackerData = ^TTrackerData;
  TTrackerData = object(TObj)
    FMaxValue:integer;  //FMinValue assumed 0 by design. this is a demo after all.
    FXpos:Integer;
    Fowner:Pcontrol;    // to reference ourselves if needed.
    FBkGnd:PBitmap;     // bitmap to draw the background on. Note you can also load
                        // this with a physical bitmap from file or resource.
    procedure PaintBackGround; // Draws the bitmap. Must be redrawn after resize
                               // but you have to do this yourself :-) easy enough!
    procedure PaintTracker(sender:PControl;DC:HDC);
    destructor Destroy;virtual;
  end;

  // constructor;
  function NewTracker(aOwner:Pcontrol;EdgeStyle:TEdgeStyle;ThumbColor,FieldColor:Tcolor;MaxValue:integer = 100):PControl;

implementation
  // handles mousemove. Could also handle paint here and resize (for the bitmap).
  function WndProcTracker( Sender: PControl; var Msg: TMsg; var Rslt: Integer ): Boolean;
  begin
    Result:=false;             // default
    case msg.message of
    WM_SIZE:
        begin
          PTrackerdata(sender.CustomObj).FBkGnd.Width:=sender.Clientwidth;
          PTrackerdata(sender.CustomObj).FBkGnd.Height:=sender.ClientHeight;
          PTrackerdata(sender.CustomObj).PaintBackground;
          sender.Invalidate;
        end;
    WM_MOUSEMOVE:
         // If the left mousebutton is down
         if Boolean (msg.wparam and MK_LBUTTON) and
         // Allow a margin to grab the "thumb"
         (Abs(Loword(Msg.lparam) - PTrackerdata(sender.CustomObj).FXPos) < 5) then
         begin
           PTrackerdata(sender.CustomObj).FXpos:=Min(Max(LOWORD(msg.lParam),5),sender.Clientwidth-5);
           sender.Invalidate;
           if Assigned(sender.OnChange) then
             sender.OnChange(sender);
           result:=true;
         end;
    else
      Result:=False;
    end;
  end;

  function NewTracker(aOwner:Pcontrol;EdgeStyle:TEdgeStyle;ThumbColor,FieldColor:Tcolor;MaxValue:integer = 100):PControl;
  var
    data:PTrackerData;
  begin
    Result:=NewPanel(aOwner,EdgeStyle).setsize(100,20);
    New(Data,Create);
    Result.CustomObj:=Data;            // create the trackerdata object
    Data.Fowner:=Result;
    Result.Color1:=ThumbColor;         // whatever, it's an example
    Result.Color2:=FieldColor;         // idem, but we need to set them
                                       // otherwise they're both black.
    Data.FMaxValue:=MaxValue;          // maximum value, min is assumed to be 0;
    Data.FBkGnd:=NewBitmap(Result.clientwidth,Result.clientHeight);
    Data.FXpos:=data.Fowner.clientwidth div 2;
    Data.PaintBackGround;
    Result.tag:=0;        // set tag to minimum.
    Result.AttachProc(WndprocTracker);
    Result.OnPaint:=data.PaintTracker;
  end;
{ TTrackerData }

destructor TTrackerData.Destroy;
begin
  if Assigned(FOwner) and FOwner.IsprocAttached(WndProcTracker) then
  Fowner.DetachProc(WndProcTracker);
  FBkGnd.Free;
  inherited;
end;

procedure TTrackerData.PaintBackGround;
begin
  // something very simple
  if assigned(FBkGnd) then
  begin
    FBkGnd.Canvas.Brush.Color:=FOwner.Color;
    FBkGnd.canvas.fillrect(FBkGnd.Boundsrect);
    FBkGnd.canvas.Pen.Color:=Fowner.Color1;
    FBkGnd.Canvas.RoundRect(3,3,FBkGnd.width-3,FBkGnd.Height-3,3,3);
  end;
end;

procedure TTrackerData.PaintTracker(sender: PControl; DC: HDC);
var
  T:integer;
begin
  FBkGnd.Draw(dc,0,0);            // Draws the background
  with PTrackerdata(sender.CustomObj)^ do
  begin
    sender.canvas.Pen.Penwidth:=3;
    sender.canvas.Pen.color:=Fowner.color2;
    sender.canvas.moveto(FXpos,3);
    sender.canvas.LineTo(FXPos,sender.Clientheight-3);
    // Now calculate the actual value.
    // Scale first. we have a margin of 5 pixels on both sides,
    // see how FXpos is calculated. Subtract this from the clientwidth
    // to obtain the relative maximum value then scale it to FMaxValue
    // and store it in the tag.
    T:=(FXpos - 5) * FMaxValue div (sender.clientwidth - 10);
    sender.tag:=T;

  end;
end;

end.
