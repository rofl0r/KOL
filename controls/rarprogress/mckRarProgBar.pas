//////////////////////////////////////////////////////////////////////
//                                                                  //
//      TRarProgressBar version 1.0                                 //
//      Description: TRarProgressBar is a component which           //
//                   displays dual progress bar like a WinRAR       //
//      Author: Dimaxx                                              //
//                                                                  //
//////////////////////////////////////////////////////////////////////

unit mckRarProgBar;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
     ComCtrls, ExtCtrls, Mirror;

const
  Boolean2Str: array [Boolean] of string = ('False','True');

type
  TRarProgressBar = class(TKOLControl)
  private
    { Private declarations }
    FPosition1: integer;
    FPosition2: integer;
    FMin,FMax: integer;

    FPercent1,FPercent2: integer;
    FDouble: boolean;

    FLightColor1,FDarkColor,FLightColor2,FFrameColor1,FFrameColor2,
    FFillColor1,FFillColor2,FBackFrameColor1,FBackFrameColor2,
    FBackFillColor,FShadowColor: TColor;

    TopX,TopY,SizeX,SizeY: integer;

    function  AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName,AParent,Prefix: string); override;
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
    procedure Paint;
    procedure WMPaint(var Msg: TMessage); message WM_PAINT;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
    procedure WMActiv(var Msg: TMessage); message WM_SHOWWINDOW;
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
  published
    { Published declarations }
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

procedure Register;

implementation

{$R mckRarProgBar.dcr}

procedure Register;
begin
  RegisterComponents('KOL', [TRarProgressBar]);
end;

constructor TRarProgressBar.Create;
begin
  inherited;
  Width:=204;
  Height:=18;
  FMin:=0;
  FMax:=100;
  FPosition1:=0;
  FPosition2:=0;
  FDouble:=False;
  FPercent1:=0;
  FPercent2:=0;
  FLightColor1:=clWhite;
  FDarkColor:=$606060;
  FLightColor2:=$C0FFFF;
  FFrameColor1:=$EEE8E8;
  FFrameColor2:=$B4D4E4;
  FFillColor1:=$DCD6D6;
  FFillColor2:=$A0C0D0;
  FBackFrameColor1:=$9494B4;
  FBackFrameColor2:=$80809E;
  FBackFillColor:=$6E6E94;
  FShadowColor:=$464040;
end;

procedure TRarProgressBar.WMPaint;
begin
  inherited;
  Paint;
end;

procedure TRarProgressBar.WMSize;
begin
  inherited;
  Paint;
end;

procedure TRarProgressBar.WMActiv;
begin
  inherited;
  Paint;
end;

function TRarProgressBar.AdditionalUnits;
begin
  Result:=', KOLRarProgBar';
end;

procedure TRarProgressBar.SetupFirst;
begin
  inherited;
  SL.Add(Prefix+AName+'.Position1 := '+IntToStr(FPosition1)+';');
  SL.Add(Prefix+AName+'.Position2 := '+IntToStr(FPosition2)+';');
  SL.Add(Prefix+AName+'.Min := '+IntToStr(FMin)+';');
  SL.Add(Prefix+AName+'.Max := '+IntToStr(FMax)+';');
  SL.Add(Prefix+AName+'.Double := '+Boolean2Str[FDouble]+';');
  SL.Add(Prefix+AName+'.LightColor1 := '+Color2Str(FLightColor1)+';');
  SL.Add(Prefix+AName+'.LightColor2 := '+Color2Str(FLightColor2)+';');
  SL.Add(Prefix+AName+'.DarkColor := '+Color2Str(FDarkColor)+';');
  SL.Add(Prefix+AName+'.FrameColor1 := '+Color2Str(FFrameColor1)+';');
  SL.Add(Prefix+AName+'.FrameColor2 := '+Color2Str(FFrameColor2)+';');
  SL.Add(Prefix+AName+'.FillColor1 := '+Color2Str(FFillColor1)+';');
  SL.Add(Prefix+AName+'.FillColor2 := '+Color2Str(FFillColor2)+';');
  SL.Add(Prefix+AName+'.BackFrameColor1 := '+Color2Str(FBackFrameColor1)+';');
  SL.Add(Prefix+AName+'.BackFrameColor2 := '+Color2Str(FBackFrameColor2)+';');
  SL.Add(Prefix+AName+'.BackFillColor := '+Color2Str(FBackFillColor)+';');
  SL.Add(Prefix+AName+'.ShadowColor := '+Color2Str(FShadowColor)+';');
end;

procedure TRarProgressBar.SetPos1;
begin
  if FDouble then if P<FPosition2 then P:=FPosition2;
  if P>FMax then P:=FMax;
  FPosition1:=P;
  Paint;
end;

procedure TRarProgressBar.SetPos2;
begin
  if FDouble then if P>FPosition1 then P:=FPosition1;
  FPosition2:=P;
  Paint;
end;

procedure TRarProgressBar.SetMin;
begin
  if M>FMax then M:=FMax;
  FMin:=M;
  Paint;
end;

procedure TRarProgressBar.SetMax;
begin
  if M<FMin then M:=FMin;
  FMax:=M;
  Paint;
end;

procedure TRarProgressBar.SetDouble;
begin
  FDouble:=D;
  Paint;
end;

procedure TRarProgressBar.SetLightColor1;
begin
  FLightColor1:=C;
  Paint;
end;

procedure TRarProgressBar.SetLightColor2;
begin
  FLightColor2:=C;
  Paint;
end;

procedure TRarProgressBar.SetDarkColor;
begin
  FDarkColor:=C;
  Paint;
end;

procedure TRarProgressBar.SetFrameColor1;
begin
  FFrameColor1:=C;
  Paint;
end;

procedure TRarProgressBar.SetFrameColor2;
begin
  FFrameColor2:=C;
  Paint;
end;

procedure TRarProgressBar.SetFillColor1;
begin
  FFillColor1:=C;
  Paint;
end;

procedure TRarProgressBar.SetFillColor2;
begin
  FFillColor2:=C;
  Paint;
end;

procedure TRarProgressBar.SetBackFrameColor1;
begin
  FBackFrameColor1:=C;
  Paint;
end;

procedure TRarProgressBar.SetBackFrameColor2;
begin
  FBackFrameColor2:=C;
  Paint;
end;

procedure TRarProgressBar.SetBackFillColor;
begin
  FBackFillColor:=C;
  Paint;
end;

procedure TRarProgressBar.SetShadowColor;
begin
  FShadowColor:=C;
  Paint;
end;

procedure TRarProgressBar.Paint;
var R: real;
    Prog: cardinal;
begin
  TopX:=2;
  TopY:=2;
  SizeX:=Width-TopX-2;
  SizeY:=Height-TopY-4;
  if (SizeX=0) or (SizeY=0) or (FMax-FMin=0) then Exit;

///////////////////////////////////////////////////////////////////////////////
//              Drawing base
///////////////////////////////////////////////////////////////////////////////

  Canvas.Brush.Style:=bsSolid;
  Canvas.Brush.Color:=Color;
  Canvas.FillRect(Bounds(0,0,Width,Height));
  Canvas.Brush.Color:=FShadowColor;
  Canvas.FillRect(Bounds(TopX+1,TopY+2,SizeX,SizeY));
  Canvas.Brush.Color:=FBackFillColor;
  Canvas.FillRect(Bounds(TopX,TopY,SizeX,SizeY+1));
  Canvas.Brush.Color:=FDarkColor;
  Canvas.FrameRect(Bounds(TopX,TopY,SizeX,SizeY+1));
  Canvas.Brush.Color:=FBackFrameColor1;
  Canvas.FrameRect(Bounds(TopX,TopY,SizeX,SizeY));
  Canvas.Brush.Color:=FBackFrameColor2;
  Canvas.FrameRect(Bounds(TopX+1,TopY+1,SizeX-2,SizeY-2));

///////////////////////////////////////////////////////////////////////////////
//              Drawing first bar
///////////////////////////////////////////////////////////////////////////////

  R:=(FPosition1-FMin)/((FMax-FMin)/SizeX);
  Prog:=Round(R);
  FPercent1:=Byte(Round(R/(SizeX/100)));
  if Prog<>0 then
    begin
      Canvas.Brush.Color:=FLightColor1;
      Canvas.FillRect(Bounds(TopX,TopY,TopX+Prog-2,TopY+SizeY-2));
      if Prog>1 then
        begin
          Canvas.Brush.Color:=FFillColor1;
          Canvas.FillRect(Bounds(TopX+1,TopY+1,TopX+Prog-3,TopY+SizeY-3));
          Canvas.Brush.Color:=FFrameColor1;
          Canvas.FrameRect(Bounds(TopX+1,TopY+1,TopX+Prog-3,TopY+SizeY-3));
        end;
      Canvas.Brush.Color:=FDarkColor;
      Canvas.FillRect(Bounds(TopX+Prog,TopY,1,TopY+SizeY-1));
      if Prog<SizeX-1 then
        begin
          Canvas.Brush.Color:=FBackFillColor;
          Canvas.FillRect(Bounds(TopX+Prog+1,TopY,SizeX-Prog-1,SizeY));
          Canvas.Brush.Color:=FBackFrameColor1;
          Canvas.FrameRect(Bounds(TopX+Prog+1,TopY,SizeX-Prog-1,SizeY));
          Canvas.Brush.Color:=FBackFrameColor2;
          Canvas.FrameRect(Bounds(TopX+Prog+1,TopY+1,SizeX-Prog-2,SizeY-2));
        end;
    end;

///////////////////////////////////////////////////////////////////////////////
//              Drawing second bar
///////////////////////////////////////////////////////////////////////////////

  if FDouble then
    begin
      R:=(FPosition2-FMin)/((FMax-FMin)/SizeX);
      Prog:=Round(R);
      FPercent2:=Byte(Round(R/(SizeX/100)));
      if Prog<>0 then
        begin
          Canvas.Brush.Color:=FLightColor2;
          Canvas.FillRect(Bounds(TopX,TopY,TopX+Prog-2,TopY+SizeY-2));
          if Prog>1 then
            begin
              Canvas.Brush.Color:=FFillColor2;
              Canvas.FillRect(Bounds(TopX+1,TopY+1,TopX+Prog-3,TopY+SizeY-3));
              Canvas.Brush.Color:=FFrameColor2;
              Canvas.FrameRect(Bounds(TopX+1,TopY+1,TopX+Prog-3,TopY+SizeY-3));
            end;
        end;
    end;
end;

procedure TRarProgressBar.Add1;
begin
  Inc(FPosition1,D);
  Paint;
end;

procedure TRarProgressBar.Add2;
begin
  Inc(FPosition2,D);
  Paint;
end;

end.

