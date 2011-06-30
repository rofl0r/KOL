unit KOLSoundCtl;

interface

uses windows, messages, KOL, mmsystem;

type
  PSoundCtl = ^TSoundCtl;
  TSoundCtl = object( TControl )
  private
    function GetVal( const Index: Integer ): Integer;
    procedure SetVal(const Index, Value: Integer);
    function GetDrawFade: Boolean;
    procedure SetDrawFade(const Value: Boolean);
    function GetNewOnPaint: TOnPaint;
    procedure SetNewOnPaint(const Value: TOnPaint);
    function GetOnScroll: TOnEvent;
    procedure SetOnScroll(const Value: TOnEvent);
    procedure PaintSoundCtl( Sender: PControl; DC: HDC );
    procedure DoCtlSoundProc( Sender: PObj );
  protected
    procedure NeedMixer;
    procedure DoCloseMixer;
  public
    property Position: Integer index 16 read GetVal write SetVal;
    property MinPos: Integer index 20 read GetVal write SetVal;
    property MaxPos: Integer index 24 read GetVal write SetVal;
    property ThumbWidth: Integer index 28 read GetVal write SetVal;
    property DrawFade: Boolean read GetDrawFade write SetDrawFade;
    property OnPaint: TOnPaint read GetNewOnPaint write SetNewOnPaint;
    property OnScroll: TOnEvent read GetOnScroll write SetOnScroll;
    function ControlSound( DoCtl: Boolean ): PSoundCtl;
    function SaveVolume: DWORD;
    procedure RestoreVolume( Volume: DWORD );
  end;

  TKOLSoundCtl = PSoundCtl;

function NewSoundCtl( AParent: PControl ): PSoundCtl;

function OpenMixer: THandle;
procedure CloseMixer( Mixer: THandle );
function GetVolume( Mixer: THandle ): DWORD;
procedure SetVolume( Mixer: THandle; Volume: DWORD );

implementation

function OpenMixer: THandle;
begin
  MixerOpen( @ Result, 0, 0, 0, 0 );
end;

procedure CloseMixer( Mixer: THandle );
begin
  if Mixer <> 0 then
    MixerClose( Mixer );
end;

function GetVolume( Mixer: THandle ): DWORD;
var ML: TMixerLine;
    CD: tMIXERCONTROLDETAILS;
    DU: TMixerControlDetailsUnsigned;
    Err: Integer;
begin
  Result := $FFFFFFFF;
  if Mixer = 0 then Exit;
  ML.cbStruct := Sizeof( ML );
  ML.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT;
  if mixerGetLineInfo( Mixer, @ ML, MIXER_GETLINEINFOF_COMPONENTTYPE )
     <> MMSYSERR_NOERROR then Exit;
  CD.cbStruct := Sizeof( CD );
  CD.dwControlID := ML.dwSource;
  CD.cChannels := 1; // get for 1st channel
  CD.hwndOwner := 0;
  CD.cbDetails := Sizeof( DU );
  CD.paDetails := @ DU;
  DU.dwValue := 0;
  Err := mixerGetControlDetails( Mixer, @ CD, MIXER_GETCONTROLDETAILSF_VALUE
     or MIXER_OBJECTF_HMIXER );
  if Err <> MMSYSERR_NOERROR then
    Exit;
  Result := DU.dwValue;
end;

procedure SetVolume( Mixer: THandle; Volume: DWORD );
var ML: TMixerLine;
    CD: tMIXERCONTROLDETAILS;
    DU: TMixerControlDetailsUnsigned;
begin
  if Mixer = 0 then Exit;
  ML.cbStruct := Sizeof( ML );
  ML.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT;
  if mixerGetLineInfo( Mixer, @ ML, MIXER_GETLINEINFOF_COMPONENTTYPE )
     <> MMSYSERR_NOERROR then Exit;
  CD.cbStruct := Sizeof( CD );
  CD.dwControlID := ML.dwSource;
  CD.cChannels := 1; // set the same for all channnels
  CD.hwndOwner := 0;
  CD.cbDetails := Sizeof( DU );
  CD.paDetails := @ DU;
  DU.dwValue := Volume;
  mixerSetControlDetails( Mixer, @ CD, MIXER_SETCONTROLDETAILSF_VALUE );
end;


type
  PSoundCtlData = ^TSoundCtlData;
  TSoundCtlData = packed record
    OnPaint: TOnPaint;
    OnScroll: TOnEvent;
    Position: Integer;
    MinPos: Integer;
    MaxPos: Integer;
    ThumbWidth: Integer;
    DrawFade: Boolean;
    LeftPressed: Boolean;
    DoCtlSound: Boolean;
    Reserved: Boolean;
    OnCtlSound: TOnEvent;
    FMixer: THandle;
    FSaveVolume: DWORD;
  end;

function WndProcSndCtl(Ctl: PControl; var Msg: TMsg; var Rslt: Integer) : Boolean;
var D: PSoundCtlData;
  procedure DragThumb;
  var P: TPoint;
      W: Integer;
      I: Integer;
  begin
    GetCursorPos( P );
    P := Ctl.Screen2Client( P );
    W := D.ThumbWidth;
    if W = 0 then
      W := Max( 4, Ctl.Width div 6 );
    I := (P.x - W div 2) * (D.MaxPos - D.MinPos)
                            div (Ctl.Width - W - W div 2);
    if I < D.MinPos then I := D.MinPos;
    if I > D.MaxPos then I := D.MaxPos;
    PSoundCtl(Ctl).Position := I;
    if Assigned( D.OnScroll ) then
      D.OnScroll( Ctl );
    if Assigned( D.OnCtlSound ) then
      D.OnCtlSound( Ctl );
  end;
begin
  D := Ctl.CustomData;
  case Msg.message of
  WM_LBUTTONDOWN:
    begin
      D.LeftPressed := TRUE;
      SetCapture( Ctl.Handle );
      DragThumb;
    end;
  WM_LBUTTONUP:
    begin
      D.LeftPressed := FALSE;
      ReleaseCapture;
    end;
  WM_MOUSEMOVE:
    if D.LeftPressed then
      DragThumb;
  end;
  Result := FALSE;
end;

function NewSoundCtl( AParent: PControl ): PSoundCtl;
var D: PSoundCtlData;
begin
  Result := PSoundCtl( NewPaintBox( AParent ) );
  GetMem( D, Sizeof( TSoundCtlData ) );
  FillChar( D^, Sizeof( D^ ), 0 );
  Result.CustomData := D;
  D.MaxPos := 65535;
  D.DrawFade := TRUE;
  Result.SetOnPaint( Result.PaintSoundCtl );
  Result.Width := 100;
  Result.Height := 40;
  Result.AttachProc( WndProcSndCtl );
end;

{ TSoundCtl }

procedure TSoundCtl.DoCloseMixer;
var D: PSoundCtlData;
begin
  D := CustomData;
  if D = nil then Exit;
  //if D.FMixer = 0 then Exit;
  CloseMixer( D.FMixer );
  D.FMixer := 0;
end;

function TSoundCtl.ControlSound( DoCtl: Boolean ): PSoundCtl;
var D: PSoundCtlData;
begin
  NeedMixer;
  D := CustomData;
  D.DoCtlSound := DoCtl;
  D.OnCtlSound := DoCtlSoundProc;
  Result := @Self;
  D.FSaveVolume := GetVolume( D.FMixer );
  D.Position := Round( (Integer( D.FSaveVolume ) and $FFFF)
                     / (MaxPos - MinPos + 1) * 65535 );
end;

procedure TSoundCtl.DoCtlSoundProc(Sender: PObj);
var D: PSoundCtlData;
    L: Integer;
begin
  D := CustomData;
  if not D.DoCtlSound then Exit;
  L := Round( (D.Position - D.MinPos) / (D.MaxPos - D.MinPos + 1) * 65535 );
  L := L and $FFFF;
  SetVolume( D.FMixer, L )
end;

function TSoundCtl.GetDrawFade: Boolean;
var D: PSoundCtlData;
begin
  D := CustomData;
  Result := D.DrawFade;
end;

function TSoundCtl.GetNewOnPaint: TOnPaint;
var D: PSoundCtlData;
begin
  D := CustomData;
  Result := D.OnPaint;
end;

function TSoundCtl.GetOnScroll: TOnEvent;
var D: PSoundCtlData;
begin
  D := CustomData;
  Result := D.OnScroll;
end;

function TSoundCtl.GetVal( const Index: Integer ): Integer;
var D: PSoundCtlData;
begin
  D := CustomData;
  Result := 0;
  if D <> nil then
    Result := PInteger( Integer( D ) + Index )^;
end;

procedure TSoundCtl.NeedMixer;
var D: PSoundCtlData;
begin
  D := CustomData;
  if D = nil then Exit;
  if D.FMixer <> 0 then Exit; // already opened
  D.FMixer := OpenMixer;
  Add2AutoFreeEx( DoCloseMixer );
end;

procedure TSoundCtl.PaintSoundCtl(Sender: PControl; DC: HDC);
var C: PCanvas;
    X, Y, W: Integer;
    D: PSoundCtlData;
begin
  D := PSoundCtl( Sender ).CustomData;
  C := Sender.Canvas;
  if D.DrawFade then
  begin
    C.Brush.Color := Color;
    Y := Sender.Height * 3 div 4;
    X := Sender.Width - 2;
    C.FillRect( MakeRect( 0, 0, 2, Y ) );
    C.FillRect( MakeRect( 1, 0, X, Y - 1 ) );
    C.FillRect( MakeRect( 0, Y + 2, Sender.Width, Sender.Height ) );
    C.Pen.PenStyle := psClear;
    C.Polygon( [ MakePoint( 0, Y ), MakePoint( X, 0 ),
                 MakePoint( X, Y ) ] );
    C.Pen.PenStyle := psSolid;
    C.Pen.Color := clBtnHighlight;
    C.MoveTo( 0, Y );
    C.LineTo( X, 0 );
    C.Pen.Color := clBtnShadow;
    C.LineTo( X, Y );
    C.LineTo( 0, Y );
    C.Pen.Color := clWindowText;
    C.MoveTo( 0, Y + 1 );
    C.LineTo( X + 1, Y + 1 );
    C.LineTo( X + 1, 0 );
  end;
  W := Sender.Width div 6;
  if W < 4 then W := 4;
  if (D.ThumbWidth > 0) and (D.ThumbWidth < Sender.Width - 2) then
    W := ThumbWidth;
  X := (D.Position - D.MinPos) * (Sender.Width - W + 1) div (D.MaxPos - D.MinPos);
  DrawFrameControl( C.Handle, MakeRect( X, 0, X + W - 1, Sender.Height ),
                    DFC_BUTTON, DFCS_BUTTONPUSH );
  if Assigned( D.OnPaint ) then
    D.OnPaint( Sender, DC );
end;

procedure TSoundCtl.RestoreVolume(Volume: DWORD);
var D: PSoundCtlData;
begin
  NeedMixer;
  D := CustomData;
  if D = nil then Exit;
  D.Position := Round( (Integer( Volume ) and $FFFF)
                     / (MaxPos - MinPos + 1) * 65535 );
  Invalidate;
  SetVolume( D.FMixer, Volume );
end;

function TSoundCtl.SaveVolume: DWORD;
var D: PSoundCtlData;
begin
  D := CustomData;
  NeedMixer;
  Result := GetVolume( D.FMixer );
end;

procedure TSoundCtl.SetDrawFade(const Value: Boolean);
var D: PSoundCtlData;
begin
  D := CustomData;
  D.DrawFade := Value;
  Invalidate;
end;

procedure TSoundCtl.SetNewOnPaint(const Value: TOnPaint);
var D: PSoundCtlData;
begin
  D := CustomData;
  D.OnPaint := Value;
  Invalidate;
end;

procedure TSoundCtl.SetOnScroll(const Value: TOnEvent);
var D: PSoundCtlData;
begin
  D := CustomData;
  D.OnScroll := Value;
end;

procedure TSoundCtl.SetVal(const Index, Value: Integer);
var D: PSoundCtlData;
begin
  D := CustomData;
  PInteger( Integer( D ) + Index )^ := Value;
  Invalidate;
  if Index = 16 then
  begin
    if Assigned( D.OnCtlSound ) then
      D.OnCtlSound( @ Self );
  end;
end;

end.
