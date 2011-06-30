(****************************************************************)
(*                             HintRA                           *)
(*                                                              *)
(*  Автор: Rabotahoff Alexandr (RA)                             *)
(* e-mail: Holden@bk.ru                                         *)
(* Версия: 1.4                                                  *)
(*   Дата: 11.12.2003                                           *)
(****************************************************************)

unit mckHintRA;

interface

uses
  Windows, Messages, Classes, Controls, mirror, mckCtrls, KOL, Graphics, KOLHintRA;

type
  TKOLHintRA = class(TKOLObj)
  private
    fHintText:TStringList;//String;
    fShowHint:Boolean;
    fKOLControl:TKOLControl;

    fHideHintOnDelay:boolean;

    fMoveHint:Boolean;
    fColor,fBkColor:TColor;
    fDefaultColor,fDefaultBkColor:Boolean;

    //события
    fOnBeforeShowHint: TOnEvent;
    fOnAfterShowHint: TOnEvent;

    procedure SetHintText(const Value: TStringList{String});
    procedure SetShowHint(const Value:boolean);
    procedure SetKOLControl(const Value:TKOLControl);
    procedure SetColor(const Value:TColor);
    procedure SetBkColor(const Value:TColor);

    procedure SetDefaultColor(const Value:boolean);
    procedure SetDefaultBkColor(const Value:boolean);
    procedure SetMoveHint(const Value:boolean);

    procedure SetHideHintOnDelay(const Value:boolean);

    {события}
    procedure SetOnBeforeShowHint(const Value: TOnEvent);
    procedure SetOnAfterShowHint(const Value: TOnEvent);

  protected
    function TypeName: String; override;
    function AdditionalUnits: String; override;
    procedure AssignEvents(SL: TStringList; const AName: String); override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure SetupLast(SL: TStringList; const AName, AParent, Prefix: String); override;

    function BestEventName: String; override;
  public
    constructor Create(Owner: TComponent); override;

  published
    property HintText:TStringList{String} read fHintText write SetHintText;
    property ShowHint:Boolean read fShowHint write SetShowHint;
    property KOLControl:TKOLControl read fKOLControl write SetKOLControl;

    property HideHintOnDelay:boolean read fHideHintOnDelay write SetHideHintOnDelay;

    property MoveHint:boolean read fMoveHint write SetMoveHint;
    property Color:TColor read fColor write SetColor;
    property BkColor:TColor read fBkColor write SetBkColor;
    property DefaultColor:boolean read fDefaultColor write SetDefaultColor;
    property DefaultBkColor:boolean read fDefaultBkColor write SetDefaultBkColor;

    //события
    property OnBeforeShowHint: TOnEvent read fOnBeforeShowHint write SetOnBeforeShowHint;
    property OnAfterShowHint: TOnEvent read fOnAfterShowHint write SetOnAfterShowHint;
  end;

procedure Register;

{$R *.dcr}

implementation

function TKOLHintRA.BestEventName: String;
begin
  Result := 'OnBeforeShowHint';
end;

procedure Register;
begin
  RegisterComponents('KOL System', [TKOLHintRA]);
end;

constructor TKOLHintRA.Create;
begin
  //BEGIN нач установки
  fHintText:=TStringList.Create;
//  fHintText.Clear;

  fShowHint:=True;//False;
  fKOLControl:=nil;

  fDefaultColor:=True;
  fDefaultBkColor:=True;
  fColor:=clBlack;
  fBkColor:=clWhite;

  fMoveHint:=False;
  fHideHintOnDelay:=True;
  //END нач установки
  inherited;
end;

function TKOLHintRA.AdditionalUnits;
begin
  Result := ', KOLHintRA';
end;

function TKOLHintRA.TypeName: String;
begin
  Result := 'HintRA';
end;

procedure TKOLHintRA.AssignEvents;
begin
inherited;
  DoAssignEvents(SL, AName, ['OnBeforeShowHint'], [@OnBeforeShowHint]);
  DoAssignEvents(SL, AName, ['OnAfterShowHint'], [@OnAfterShowHint]);
end;

procedure TKOLHintRA.SetupFirst(SL: TStringList; const AName, AParent, Prefix: String);
var s:string;
    n:integer;
begin
  SL.Add(Prefix + AName + ' := NewHintRA; {RA}');

  if fHintText.text<>''
  then begin
    s:=chr(39)+fHintText.Strings[0]+chr(39);
    for n:=1 to fHintText.Count-1 do
    begin
      s:=s+'+#13#10+'+chr(39)+fHintText.Strings[n]+chr(39);
      //SL.Add(Prefix+AName+'.HintText.Add('''+ fHintText.Strings[n] +'''); {RA}');
    end;
    SL.Add(Prefix+AName+'.HintText:='+ s +'; {RA}');
  end;

  if not(fShowHint)
  then SL.Add(Prefix+AName+'.ShowHint := False; {RA}');

  if not(fDefaultColor)
  then if fColor<>clBlack
    then SL.Add(Prefix+AName+'.Color := '+Color2Str(fColor)+'; {RA}');

  if not(fDefaultBkColor)
  then if fBkColor<>clWhite
    then SL.Add(Prefix+AName+'.BkColor := '+Color2Str(fBkColor)+'; {RA}');

  if fMoveHint
  then SL.Add(Prefix+AName+'.MoveHint := True;'+' {RA}');

  if not(fHideHintOnDelay)
  then SL.Add(Prefix+AName+'.HideHintOnDelay := False;'+' {RA}');
end;

procedure TKOLHintRA.SetupLast(SL: TStringList; const AName, AParent, Prefix: String);
begin
 if fKOLControl<>nil
 then SL.Add(Prefix+AName+'.KOLControl := Result.'+KOLControl.Name+'; {RA}');
end;

{установка свойств}
procedure TKOLHintRA.SetHintText(const Value: TStringList{String});
begin
  if not fHintText.Equals(Value)
  then begin
    fHintText.Clear;
    fHintText.AddStrings(Value);
    Change;
  end;
end;

procedure TKOLHintRA.SetShowHint(const Value:boolean);
begin
  if fShowHint<>Value
  then begin
    fShowHint:=Value;
    Change;
  end;
end;

procedure TKOLHintRA.SetKOLControl(const Value:TKOLControl);
begin
  if fKOLControl<>Value
  then begin
    fKOLControl:=Value;
    Change;
  end;
end;

procedure TKOLHintRA.SetMoveHint(const Value:boolean);
begin
  if fMoveHint<>Value
  then begin
    fMoveHint:=Value;
    Change;
  end;
end;

procedure TKOLHintRA.SetDefaultColor(const Value:boolean);
begin
  if fDefaultColor<>Value
  then begin
    fDefaultColor:=Value;
    Change;
  end;
end;

procedure TKOLHintRA.SetDefaultBkColor(const Value:boolean);
begin
  if fDefaultBkColor<>Value
  then begin
    fDefaultBkColor:=Value;
    Change;
  end;
end;

procedure TKOLHintRA.SetColor(const Value:TColor);
begin
  if fColor<>Value
  then begin
    fDefaultColor:=False;
    fColor:=Value;
    Change;
  end;
end;

procedure TKOLHintRA.SetBkColor(const Value:TColor);
begin
  if fBkColor<>Value
  then begin
    fDefaultBkColor:=False;
    fBkColor:=Value;
    Change;
  end;
end;

procedure TKOLHintRA.SetHideHintOnDelay(const Value:boolean);
begin
  if fHideHintOnDelay<>Value
  then begin
    fHideHintOnDelay:=Value;
    Change;
  end;
end;

{установка событий}
procedure TKOLHintRA.SetOnBeforeShowHint(const Value: TOnEvent);
begin
  if @OnBeforeShowHint <> @Value
  then begin
    fOnBeforeShowHint := Value;
    Change;
  end;
end;

procedure TKOLHintRA.SetOnAfterShowHint(const Value: TOnEvent);
begin
  if @OnAfterShowHint <> @Value
  then begin
    fOnAfterShowHint := Value;
    Change;
  end;
end;

end.
