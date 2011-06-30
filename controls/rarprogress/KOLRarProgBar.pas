//////////////////////////////////////////////////////////////////////
//                                                                  //
//      TRarProgressBar version 1.0                                 //
//      Description: TRarProgressBar is a component which           //
//                   displays dual progress bar like a WinRAR       //
//      Author: Dimaxx                                              //
//                                                                  //
//////////////////////////////////////////////////////////////////////

unit KOLRarProgBar;

interface

uses Windows, Messages, Kol, Objects;

type
  PRarProgBar =^TRarProgBar;
  TRarProgressBar = PRarProgBar;
  TRarProgBar = object(TObj)
  private
    { Private declarations }
    FControl: PControl;
    FPosition1: integer;
    FPosition2: integer;
    FPercent1,FPercent2: integer;
    FDouble: boolean;
    B: PBitmap;

    FLightColor1,FDarkColor,FLightColor2,FFrameColor1,FFrameColor2,
    FFillColor1,FFillColor2,FBackFrameColor1,FBackFrameColor2,
    FBackFillColor,FShadowColor: TColor;

    TopX,TopY,SizeX,SizeY: integer;

    FMin,FMax: integer;
    OldWind,NewWind: integer;
    procedure SetPos1(P: integer);
    procedure SetPos2(P: integer);
    procedure SetMin(M: integer);
    procedure SetMax(M: integer);
    procedure SetDouble(D: boolean);

    procedure SetLightColor1(C: TColor);
    procedure SetLightColor2(C: TColor);
    procedure SetDarkColor(C: TColor);
    procedure SetFrameColor1(C: TColor);
    procedure SetFrameColor2(C: TColor);
    procedure SetFillColor1(C: TColor);
    procedure SetFillColor2(C: TColor);
    procedure SetBackFrameColor1(C: TColor);
    procedure SetBackFrameColor2(C: TColor);
    procedure SetBackFillColor(C: TColor);
    procedure SetShadowColor(C: TColor);
  protected
    { Protected declarations }
    procedure NewWndProc(var Msg: TMessage);
    procedure Paint;
  public
    destructor Destroy; virtual;
    function SetPosition(X,Y: integer): PRarProgBar; overload;
    function SetSize(X,Y: integer): PRarProgBar; overload;
    function SetAlign(A: TControlAlign): PRarProgBar; overload;
    { Public declarations }
    property Position1: integer read FPosition1 write SetPos1;
    property Position2: integer read FPosition2 write SetPos2;
    property Percent1: integer read FPercent1;
    property Percent2: integer read FPercent2;
    property Max: integer read FMax write SetMax;
    property Min: integer read FMin write SetMin;
    property Double: boolean read FDouble write SetDouble;

    property LightColor1: TColor read FLightColor1 write SetLightColor1;
    property LightColor2: TColor read FLightColor2 write SetLightColor2;
    property DarkColor: TColor read FDarkColor write SetDarkColor;
    property FrameColor1: TColor read FFrameColor1 write SetFrameColor1;
    property FrameColor2: TColor read FFrameColor2 write SetFrameColor2;
    property FillColor1: TColor read FFillColor1 write SetFillColor1;
    property FillColor2: TColor read FFillColor2 write SetFillColor2;
    property BackFrameColor1: TColor read FBackFrameColor1 write SetBackFrameColor1;
    property BackFrameColor2: TColor read FBackFrameColor2 write SetBackFrameColor2;
    property BackFillColor: TColor read FBackFillColor write SetBackFillColor;
    property ShadowColor: TColor read FShadowColor write SetShadowColor;

    procedure Add1(D: integer);
    procedure Add2(D: integer);
  end;

function NewTRarProgressBar(AOwner: PControl): PRarProgBar;

implementation

function Bounds(ALeft,ATop,AWidth,AHeight: integer): TRect;
begin
  with Result do
    begin
      Left:=ALeft;
      Top:=ATop;
      Right:=ALeft+AWidth;
      Bottom:=ATop+AHeight;
    end;
end;

function NewTRarProgressBar;
var P: PRarProgBar;
    C: PControl;
begin
  C:=pointer(_NewControl(AOwner,'STATIC',WS_VISIBLE or WS_CHILD or SS_LEFTNOWORDWRAP or SS_NOPREFIX or SS_NOTIFY,False,nil));
  C.CreateWindow;
  New(P,Create);
  AOwner.Add2AutoFree(P);
  AOwner.Add2AutoFree(C);
  P.FControl:=C;
  P.FMin:=0;
  P.FMax:=100;
  P.FPosition1:=0;
  P.FPosition2:=0;
  P.FDouble:=False;
  P.FPercent1:=0;
  P.FPercent2:=0;
  P.FLightColor1:=clWhite;
  P.FDarkColor:=$606060;
  P.FLightColor2:=$C0FFFF;
  P.FFrameColor1:=$EEE8E8;
  P.FFrameColor2:=$B4D4E4;
  P.FFillColor1:=$DCD6D6;
  P.FFillColor2:=$A0C0D0;
  P.FBackFrameColor1:=$9494B4;
  P.FBackFrameColor2:=$80809E;
  P.FBackFillColor:=$6E6E94;
  P.FShadowColor:=$464040;
  C.SetSize(204,18);
  P.B:=NewBitmap(C.Width,C.Height);
  Result:=P;
  P.OldWind:=GetWindowLong(C.Handle,GWL_WNDPROC);
  P.NewWind:=integer(MakeObjectInstance(P.NewWndProc));
  SetWindowLong(C.Handle,GWL_WNDPROC,P.NewWind);
end;

destructor TRarProgBar.Destroy;
begin
  SetWindowLong(FControl.Handle,GWL_WNDPROC,OldWind);
  FreeObjectInstance(Pointer(NewWind));
  B.Free;
  inherited;
end;

function TRarProgBar.SetPosition(X,Y: integer): PRarProgBar;
begin
  FControl.Left:=X;
  FControl.Top:=Y;
  Result:=@Self;
end;

function TRarProgBar.SetSize(X,Y: integer): PRarProgBar;
begin
  FControl.Width:=X;
  FControl.Height:=Y;
  B.Width:=X;
  B.Height:=Y;
  Result:=@Self;
end;

function TRarProgBar.SetAlign(A: TControlAlign): PRarProgBar;
begin
  FControl.Align:=A;
  Result:=@Self;
end;

procedure TRarProgBar.NewWndProc;
begin
  Msg.Result:=CallWindowProc(Pointer(OldWind),FControl.Handle,Msg.Msg,Msg.wParam,Msg.lParam);
  case Msg.Msg of
    WM_PAINT   : Paint;
    WM_SIZE    : Paint;
    WM_ACTIVATE: Paint;
  end;
end;

procedure TRarProgBar.SetMin;
begin
  if M>FMax then M:=FMax;
  FMin:=M;
  Paint;
end;

procedure TRarProgBar.SetMax;
begin
  if M<FMin then M:=FMin;
  FMax:=M;
  Paint;
end;

procedure TRarProgBar.SetPos1;
begin
  if FDouble then if P<FPosition2 then P:=FPosition2;
  if P>FMax then P:=FMax;
  FPosition1:=P;
  Paint;
end;

procedure TRarProgBar.SetPos2;
begin
  if FDouble then if P>FPosition1 then P:=FPosition1;
  FPosition2:=P;
  Paint;
end;

procedure TRarProgBar.SetDouble;
begin
  FDouble:=D;
  Paint;
end;

procedure TRarProgBar.SetLightColor1;
begin
  FLightColor1:=C;
  Paint;
end;

procedure TRarProgBar.SetLightColor2;
begin
  FLightColor2:=C;
  Paint;
end;

procedure TRarProgBar.SetDarkColor;
begin
  FDarkColor:=C;
  Paint;
end;

procedure TRarProgBar.SetFrameColor1;
begin
  FFrameColor1:=C;
  Paint;
end;

procedure TRarProgBar.SetFrameColor2;
begin
  FFrameColor2:=C;
  Paint;
end;

procedure TRarProgBar.SetFillColor1;
begin
  FFillColor1:=C;
  Paint;
end;

procedure TRarProgBar.SetFillColor2;
begin
  FFillColor2:=C;
  Paint;
end;

procedure TRarProgBar.SetBackFrameColor1;
begin
  FBackFrameColor1:=C;
  Paint;
end;

procedure TRarProgBar.SetBackFrameColor2;
begin
  FBackFrameColor2:=C;
  Paint;
end;

procedure TRarProgBar.SetBackFillColor;
begin
  FBackFillColor:=C;
  Paint;
end;

procedure TRarProgBar.SetShadowColor;
begin
  FShadowColor:=C;
  Paint;
end;

procedure TRarProgBar.Paint;
var R: real;
    Prog: cardinal;
begin
  TopX:=2;
  TopY:=2;
  SizeX:=FControl.Width-TopX-2;
  SizeY:=FControl.Height-TopY-4;
  if (SizeX=0) or (SizeY=0) or (FMax-FMin=0) then Exit;

///////////////////////////////////////////////////////////////////////////////
//              Рисуем основу
///////////////////////////////////////////////////////////////////////////////

  B.Canvas.Brush.BrushStyle:=bsSolid;
  B.Canvas.Brush.Color:=FControl.Color;
  B.Canvas.FillRect(Bounds(0,0,B.Width,B.Height));
  B.Canvas.Brush.Color:=FShadowColor;
  B.Canvas.FillRect(Bounds(TopX+1,TopY+2,SizeX,SizeY));
  B.Canvas.Brush.Color:=FBackFillColor;
  B.Canvas.FillRect(Bounds(TopX,TopY,SizeX,SizeY+1));
  B.Canvas.Brush.Color:=FDarkColor;
  B.Canvas.FrameRect(Bounds(TopX,TopY,SizeX,SizeY+1));
  B.Canvas.Brush.Color:=FBackFrameColor1;
  B.Canvas.FrameRect(Bounds(TopX,TopY,SizeX,SizeY));
  B.Canvas.Brush.Color:=FBackFrameColor2;
  B.Canvas.FrameRect(Bounds(TopX+1,TopY+1,SizeX-2,SizeY-2));

///////////////////////////////////////////////////////////////////////////////
//              Рисуем первый индикатор
///////////////////////////////////////////////////////////////////////////////

  R:=(FPosition1-FMin)/((FMax-FMin)/SizeX);
  Prog:=Round(R);
  FPercent1:=Byte(Round(R/(SizeX/100)));
  if Prog<>0 then
    begin
      B.Canvas.Brush.Color:=FLightColor1;
      B.Canvas.FillRect(Bounds(TopX,TopY,TopX+Prog-2,TopY+SizeY-2));
      if Prog>1 then
        begin
          B.Canvas.Brush.Color:=FFillColor1;
          B.Canvas.FillRect(Bounds(TopX+1,TopY+1,TopX+Prog-3,TopY+SizeY-3));
          B.Canvas.Brush.Color:=FFrameColor1;
          B.Canvas.FrameRect(Bounds(TopX+1,TopY+1,TopX+Prog-3,TopY+SizeY-3));
        end;
      B.Canvas.Brush.Color:=FDarkColor;
      B.Canvas.FillRect(Bounds(TopX+Prog,TopY,1,TopY+SizeY-1));
      if Prog<SizeX-1 then
        begin
          B.Canvas.Brush.Color:=FBackFillColor;
          B.Canvas.FillRect(Bounds(TopX+Prog+1,TopY,SizeX-Prog-1,SizeY));
          B.Canvas.Brush.Color:=FBackFrameColor1;
          B.Canvas.FrameRect(Bounds(TopX+Prog+1,TopY,SizeX-Prog-1,SizeY));
          B.Canvas.Brush.Color:=FBackFrameColor2;
          B.Canvas.FrameRect(Bounds(TopX+Prog+1,TopY+1,SizeX-Prog-2,SizeY-2));
        end;
    end;

///////////////////////////////////////////////////////////////////////////////
//              Рисуем второй индикатор
///////////////////////////////////////////////////////////////////////////////

  if FDouble then
    begin
      R:=(FPosition2-FMin)/((FMax-FMin)/SizeX);
      Prog:=Round(R);
      FPercent2:=Byte(Round(R/(SizeX/100)));
      if Prog<>0 then
        begin
          B.Canvas.Brush.Color:=FLightColor2;
          B.Canvas.FillRect(Bounds(TopX,TopY,TopX+Prog-2,TopY+SizeY-2));
          if Prog>1 then
            begin
              B.Canvas.Brush.Color:=FFillColor2;
              B.Canvas.FillRect(Bounds(TopX+1,TopY+1,TopX+Prog-3,TopY+SizeY-3));
              B.Canvas.Brush.Color:=FFrameColor2;
              B.Canvas.FrameRect(Bounds(TopX+1,TopY+1,TopX+Prog-3,TopY+SizeY-3));
            end;
        end;
    end;
  FControl.Canvas.CopyRect(Bounds(0,0,FControl.Width,FControl.Height),B.Canvas,Bounds(0,0,B.Width,B.Height));
end;

procedure TRarProgBar.Add1;
begin
  Inc(FPosition1,D);
  Paint;
end;

procedure TRarProgBar.Add2;
begin
  Inc(FPosition2,D);
  Paint;
end;

end.

