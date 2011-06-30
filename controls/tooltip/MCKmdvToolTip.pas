unit MCKmdvToolTip;

interface
{$I KOLDEF.INC}
{$IFDEF _D7orHigher}
  {$WARN UNSAFE_TYPE OFF} // Too many such warnings in Delphi7
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses mirror, Classes, Dialogs, Controls, SysUtils, KOL, Graphics, KOLmdvToolTip;

type
  TDelayMode = (dmDefault, dmAutomatic, dmCustom);

  TKOLmdvToolTip = class(TKOLObj)
  private
    FDelayAutomatic: Integer;
    FDelayTime: Integer;
    FDelayInit: Integer;
    FDelayReshow: Integer;
    FDelayMode: TDelayMode;
    FFontColor: TColor;
    FColor: TColor;
    FMaxWidth: Integer;
    FMarginLeft: Integer;
    FMarginTop: Integer;
    FMarginBottom: Integer;
    FMarginRight: Integer;
    FAlwaysTip: Boolean;
    FBalloon: Boolean;
    FTitle: String;
    FTitleIcon: TttIconType;
    FHintMode: THintMode;
    procedure SetDelayAutomatic(const Value: Integer);
    procedure SetDelayInit(const Value: Integer);
    procedure SetDelayReshow(const Value: Integer);
    procedure SetDelayTime(const Value: Integer);
    procedure SetDelayMode(const Value: TDelayMode);
    procedure SetColor(const Value: TColor);
    procedure SetFontColor(const Value: TColor);
    procedure SetMaxWidth(const Value: Integer);
    procedure SetMarginBottom(const Value: Integer);
    procedure SetMarginLeft(const Value: Integer);
    procedure SetMarginRight(const Value: Integer);
    procedure SetMarginTop(const Value: Integer);
    procedure SetAlwaysTip(const Value: Boolean);
    procedure SetBalloon(const Value: Boolean);
    procedure SetTitle(const Value: String);
    procedure SetTitleIcon(const Value: TttIconType);
    procedure SetHintMode(const Value: THintMode);
  protected
    function AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property HintMode: THintMode read FHintMode write SetHintMode;

    property DelayMode: TDelayMode read FDelayMode write SetDelayMode;
    property DelayAutomatic: Integer read FDelayAutomatic write SetDelayAutomatic;
    property DelayInit: Integer read FDelayInit write SetDelayInit;
    property DelayTime: Integer read FDelayTime write SetDelayTime;
    property DelayReshow: Integer read FDelayReshow write SetDelayReshow;

    property MaxWidth: Integer read FMaxWidth write SetMaxWidth;

    property MarginLeft: Integer read FMarginLeft write SetMarginLeft;
    property MarginTop: Integer read FMarginTop write SetMarginTop;
    property MarginRight: Integer read FMarginRight write SetMarginRight;
    property MarginBottom: Integer read FMarginBottom write SetMarginBottom;

    property Title: String read FTitle write SetTitle;
    property TitleIcon: TttIconType read FTitleIcon write SetTitleIcon;
    property Balloon: Boolean read FBalloon write SetBalloon;
    property AlwaysTip: Boolean read FAlwaysTip write SetAlwaysTip;

    property Color: TColor read FColor write SetColor;
    property FontColor: TColor read FFontColor write SetFontColor;
  end;

procedure Register;

implementation

{$R *.dcr}

procedure Register;
begin
  RegisterComponents( 'KOL System', [TKOLmdvToolTip]);
end;
{ TKOLThread }

function TKOLmdvToolTip.AdditionalUnits: string;
begin
    Result := ', KOLmdvToolTip';
end;

constructor TKOLmdvToolTip.Create(AOwner: TComponent);
begin
    inherited;
    FDelayAutomatic:= 500;
    FDelayTime:= 500;
    FDelayInit:= 500;
    FDelayReshow:= 500;
    FDelayMode:= dmDefault;
    FColor:= clInfoBk;
    FFontColor:= clInfoText;
    FMaxWidth:= -1;
    FMarginLeft:= 0; FMarginTop:= 0; FMarginBottom:= 0; FMarginRight:= 0;
    FAlwaysTip:= False;
    FBalloon:= False;
    FTitle:= '';
    FTitleIcon:= itNoIcon;
    FHintMode := hmDefault;
end;

destructor TKOLmdvToolTip.Destroy;
begin
    inherited;
end;

procedure TKOLmdvToolTip.SetAlwaysTip(const Value: Boolean);
begin
    FAlwaysTip := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetBalloon(const Value: Boolean);
begin
    FBalloon := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetColor(const Value: TColor);
begin
    FColor := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetDelayAutomatic(const Value: Integer);
begin
    FDelayAutomatic:= Value;
    Change;
end;

procedure TKOLmdvToolTip.SetDelayInit(const Value: Integer);
begin
    FDelayInit:= Value;
    Change;
end;

procedure TKOLmdvToolTip.SetDelayMode(const Value: TDelayMode);
begin
    FDelayMode:= Value;
    Change;
end;

procedure TKOLmdvToolTip.SetDelayReshow(const Value: Integer);
begin
    FDelayReshow:= Value;
    Change;
end;

procedure TKOLmdvToolTip.SetDelayTime(const Value: Integer);
begin
    FDelayTime:= Value;
    Change;
end;

procedure TKOLmdvToolTip.SetFontColor(const Value: TColor);
begin
    FFontColor := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetHintMode(const Value: THintMode);
begin
    FHintMode := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetMarginBottom(const Value: Integer);
begin
    FMarginBottom := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetMarginLeft(const Value: Integer);
begin
    FMarginLeft := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetMarginRight(const Value: Integer);
begin
    FMarginRight := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetMarginTop(const Value: Integer);
begin
    FMarginTop := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetMaxWidth(const Value: Integer);
begin
    FMaxWidth := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetTitle(const Value: String);
begin
    FTitle := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetTitleIcon(const Value: TttIconType);
begin
    FTitleIcon := Value;
    Change;
end;

procedure TKOLmdvToolTip.SetupFirst(SL: TStringList; const AName, AParent, Prefix: String);
const  ttIconType: array[TttIconType] of String = ('itNoIcon', 'itInfoIcon', 'itWarningIcon', 'itErrorIcon');
       hMode: array[THintMode] of String = ('hmDefault', 'hmShowManual', 'hmTracking');

var i, k, C: Integer;
    S, R: String;
    Chn: Boolean;
//    ttCode:
begin
   k:= 0;
   for i:= 0 to ParentForm.ComponentCount-1 do
     if ParentForm.Components[i] is TKOLmdvToolTip then inc(k);

    S:= Prefix + AName + ' := NewmdvToolTip('+AParent+', '+IntToStr(k)+', '+hMode[FHintMode]+', [';
    if FHintMode <> hmTracking then begin
      Chn:= False;
      C:= 0;
      if Trim(ParentForm.Hint) <> '' then begin
        S:= S + '@'+AParent+', ';
        Chn:= True;
        inc(C);
      end;
      k:= 0;
      R:= AName; R:= Parse(R, '.')+'.';

      for i:= 0 to ParentForm.ComponentCount-1 do begin
         if ParentForm.Components[i] is TKOLControl then begin
           if Trim((ParentForm.Components[i] as TKOLControl).Hint) <> '' then begin
             if Length(S + '@' + R+(ParentForm.Components[i] as TKOLControl).Name + ', ')-k*1024 > k*2 then begin
               S:= S + #13#10 + '      ';
               inc(k);
             end;
             S:= S + '@' + R+(ParentForm.Components[i] as TKOLControl).Name + ', ';
             Chn:= True
           end;
         end;
      end;
      if Chn then DeleteTail(S, 2); S:= S + '], [';
      if Trim(ParentForm.Hint) <> '' then S:= S + '''' + ParentForm.Hint + ''', ';
      for i:= 0 to ParentForm.ComponentCount-1 do begin
         if ParentForm.Components[i] is TKOLControl then begin
           if Trim((ParentForm.Components[i] as TKOLControl).Hint) <> '' then begin
             if Length(S + '''' + (ParentForm.Components[i] as TKOLControl).Hint + ''', ')-k*1024 > k*2 then begin
               S:= S + #13#10 + '      ';
               inc(k);
             end;
             S:= S + '''' + (ParentForm.Components[i] as TKOLControl).Hint + ''', ';
             inc(C);
             Chn:= True
           end;
         end;
      end;
      if Chn then DeleteTail(S, 2);

      S:= S + '], '+IntToStr(C)+ ');';
    end
    else S:= S + '], [], 0);';
    SL.Add(S);


    case FDelayMode of
      dmAutomatic: SL.Add(Prefix + AName + '.DelayAutomatic:= ' + Int2Str(FDelayAutomatic)+';');
      dmCustom: SL.Add(Prefix + AName + '.DelayInit:= ' + Int2Str(FDelayInit)+';'#13#10+
                       Prefix + AName + '.DelayTime:= ' + Int2Str(FDelayTime)+';'#13#10+
                       Prefix + AName + '.DelayReshow:= ' + Int2Str(FDelayReshow)+';');
    end;


    if FColor <> clInfoBk then SL.Add(Prefix + AName + '.Color:= ' + Int2Str(FColor)+';');
    if FFontColor <> clInfoText then SL.Add(Prefix + AName + '.FontColor:= ' + Int2Str(FFontColor)+';');
    if FMaxWidth >= 0 then SL.Add(Prefix + AName + '.MaxWidth:= ' + Int2Str(FMaxWidth)+';');
    if (FMarginLeft <> 0) or (FMarginRight <> 0) or (FMarginTop <> 0) or (FMarginBottom <> 0) then
      SL.Add(Prefix + AName + '.Margin:= MakeRect(' + Int2Str(FMarginLeft)+', ' + Int2Str(FMarginTop)+', ' + Int2Str(FMarginRight)+', ' + Int2Str(FMarginBottom)+');');

    if FAlwaysTip then SL.Add(Prefix + AName + '.AlwaysTip:= True;');
    if FBalloon then SL.Add(Prefix + AName + '.Balloon:= True;');
    S:= FTitle; if (FTitleIcon <> itNoIcon)and(S='') then S:= ' ';
    if S <> '' then SL.Add(Prefix + AName + '.SetTitle('''+S+''', '+ ttIconType[FTitleIcon] +');');

end;

end.
