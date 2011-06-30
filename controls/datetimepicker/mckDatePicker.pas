unit mckDatePicker;

interface

uses
Windows, Messages, mirror, classes, Controls, Forms, kol,DatePicker, mckCtrls;

type

  TKOLDatePicker = class(TKOLControl)
  private
  fOnChange : TOnEvent;
  fOnDropDown : TOnEvent;
  fOnCloseUp : TOnEvent;
  fPickerOptions : TPickerOptions;
  fFormat : String;
  fOnMessage : TOnMessage;
  fOnPaint : TOnPaint;
  fOnEraseBkgnd : TOnPaint;

  { Fake properties to hide non used in parent class}
  fFakeString : String;
  fFakeBool : Boolean;
  fFakeColor : TColor;

  { Fake events}
  fOnClick,fOnMouseDblClick,fOnMouseDown,fOnMouseEnter,fOnMouseLeave,fOnMouseMove,fOnMouseUp,
  fOnMouseWheel,fOnHide,fOnShow,fOnMove,fOnResize : TOnEvent;
  fOnDropFiles : TOnDropFiles;

  protected
    procedure AssignEvents(SL: TStringList; const AName: String);override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );override;
    function SetupParams(const AName,AParent : String) : String;override;
    function  AdditionalUnits: string; override;
    procedure SetOptions(Value : TPickerOptions);
    procedure SetFormat(Value : String);
    procedure SetOnChange(Value : TOnEvent);
    procedure SetOnDropDown(Value : TOnEvent);
    procedure SetOnCloseUp(Value : TOnEvent);
    procedure SetOnPaint(Value : TOnPaint);
    procedure SetOnErase(Value : TOnPaint);
    procedure SetOnMessage(Value : TOnMessage);
  public
    constructor Create( AOwner: TComponent ); override;
  published
  property Options : TPickerOptions read fPickerOptions
                                    write SetOptions;
  property Format : String read fFormat write SetFormat;
  property OnChange : TOnEvent read fOnChange write SetOnChange;
  property OnCloseUp : TOnEvent read fOnDropDown write SetOnDropDown;
  property OnDropDown : TOnEvent read fOnCloseUp write SetOnCloseUp;
  property OnEraseBkgnd : TOnPaint read fOnEraseBkgnd write SetOnErase;
  property OnPaint : TOnPaint read fOnPaint write SetOnPaint;
  property OnMessage : TOnMessage read fOnMessage write SetOnMessage; 
  { Fake properties}
  property Color : TColor write fFakeColor;
  property Caption : String write fFakeString;
  property DoubleBuffered : Boolean write fFakeBool;
  property EraseBackground : Boolean write fFakeBool;
  property parentColor : Boolean write fFakeBool;
  property parentFont : Boolean write fFakeBool;
  property CenterOnParent : Boolean write fFakeBool;
  property PlaceUnder : Boolean write fFakeBool;
  property PlaceDown : Boolean write fFakeBool;
  property PlaceRight : Boolean write fFakeBool;
  property PlaceLeft : Boolean write fFakeBool;
  { Fake events}
  property OnClick : TOnEvent read fOnClick write fOnClick;
  property OnDropFiles : TOnDropFiles read fOnDropFiles write fOnDropFiles;
  property OnHide : TOnEvent read fOnHide write fOnHide;
  property OnMouseDblClick : TOnEvent read fOnMouseDblClick write fOnMouseDblClick;
  property OnMouseDown : TOnEvent read fOnMouseDown write fOnMouseDown;
  property OnMouseEnter : TOnEvent read fOnMouseEnter write fOnMouseEnter;
  property OnMouseLeave : TOnEvent read fOnMouseLeave write fOnMouseLeave;
  property OnMouseMove : TOnEvent read fOnMouseMove write fOnMouseMove;
  property OnMouseUp : TOnEvent read fOnMouseUp write fOnMouseUp;
  property OnMouseWheel : TOnEvent read fOnMouseWheel write fOnMouseWheel;
  property OnMove : TOnEvent read fOnMove write fOnMove;
  property OnResize : TOnEvent read fOnResize write fOnResize;
  property OnShow : TOnEvent read fOnShow write fOnShow;  
  end;

  procedure Register;

implementation

{$R *.dcr}




constructor TKOLDatePicker.Create( AOwner: TComponent );
begin
inherited;
Width := 150;
Height := 22;
fPickerOptions := [piLongDate];
end;

procedure TKOLDatePicker.SetOptions;
begin
   fPickerOptions := Value;
   Change;
end;

procedure TKOLDatePicker.SetFormat;
begin
  if Value <> fFormat then
    begin
      fFormat := Value;
      Change;
    end;
end;


function TKOLDatePicker.AdditionalUnits;
begin
   Result := ', DatePicker';
end;

procedure TKOLDatePicker.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
  begin
    inherited;
    SL.Add( Prefix + AName + '.Format := ''' + fFormat + ''';');
  end;

function TKOLDatePicker.SetupParams(const AName,AParent : String) : String;
var
  s : String;
begin
    s :='';
    if (piShortDate in fPickerOptions) then s := s + ',piShortDate';
    if (piUpDown in fPickerOptions) then s := s + ',piUpDown';
    if (piCheckBox in fPickerOptions) then s := s + ',piCheckBox';
    if (piLongDate in fPickerOptions) then s := s + ',piLongDate';
    if (piTime in fPickerOptions) then s := s + ',piTime';
    if (piRightAlign in fPickerOptions) then s := s + ',piRightAlign';
    if s <> '' then
    if s[1] = ',' then s[1] := Chr(32);
    Result := AParent + ',' + '[' + s + ']';
end;

procedure TKOLDatePicker.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName,[ 'OnChange','OnDropDown','OnCloseUp','OnMessage', 'OnPaint', 'OnEraseBkgnd'],[ @OnChange, @OnDropDown,@OnCloseUp,@OnMessage,@OnPaint,@OnEraseBkgnd]);
end;

procedure TKOLDatePicker.SetOnDropDown(Value : TOnEvent);
begin
  fOnDropDown := Value;
  Change;
end;

procedure TKOlDatePicker.SetOnCloseUp(Value : TOnEvent);
begin
  fOnCloseUp := Value;
  Change;
end;


procedure TKOLDatePicker.SetOnChange(Value : TOnEvent);
begin
  fOnChange := Value;
  Change();
end;

procedure TKOLDatePicker.SetOnPaint(Value : TOnPaint);
begin
  fOnPaint := Value;
  Change;
end;

procedure TKOLDatePicker.SetOnErase(Value : TOnPaint);
begin
  fOnEraseBkgnd := Value;
  Change;
end;

procedure TKOLDatePicker.SetOnMessage(Value : TOnMessage);
begin
  fOnMessage := Value;
  Change;
end;



procedure Register;
begin
  RegisterComponents('KOLUtil', [TKOLDatePicker]);
end;

end.

