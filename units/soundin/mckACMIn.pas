unit mckACMIn;

interface

uses
  Windows, Messages,Classes,  mirror, mckCtrls, KOL, KOLACMIn, MMSystem;

type

  TKOLACMIn = class(TKOLObj)
  private
    FActive                   : Boolean;
    FHandle                   : HWND;
    FOnBufferFull             : TBufferFullEvent;
    FTotalWaveSize : DWORD;                    // Number of samples recorded
    FByteDataSize  : DWORD;                    // Accumulative size of recorded data
    FWaveBufSize   : DWORD;
    FUseTempFile     : boolean;

  protected
    function TypeName: String; override;
    function AdditionalUnits: String; override;
    procedure AssignEvents(SL: TStringList; const AName: String); override;
     procedure SetupFirst(SL: TStringList; const AName,AParent, Prefix: String);  override;
//     function SetupParams(const AName, AParent: String): String;
    procedure SetupLast(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure SetBufferSize(const Value: DWord);
    procedure SetUseTempFile(const Value: boolean);

  public
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
  published
      property UseTempFile     : boolean
        read FUseTempFile
        write SetUseTempFile;
      property BufferSize     : DWord
        read FWaveBufSize
        write SetBufferSize;

    property OnBufferFull   : TBufferFullEvent read FOnBufferFull write FOnBufferFull;


    // property OnMyEvent: TOnMyEvent read fOnMyEvent write SetOnMyEvent;

  end;

procedure Register;

{$R *.dcr}

implementation

procedure Register;
begin
RegisterComponents('KOL Sound', [TKOLACMIn]);
end;

{ ƒŒ¡¿¬À≈Õ»≈ ÃŒƒ”Àﬂ }
function TKOLACMIn.AdditionalUnits;
begin
Result := ', KOLACMIn';
end;

function TKOLACMIn.TypeName: String;
begin
Result := 'TKOLACMIn';
end;
////////////////////////////////////////////////////////////////////////////////

{--------------------------}
{ –≈√»—“–¿÷»ﬂ Œ¡–¿¡Œ“◊» Œ¬ }
{--------------------------}
procedure TKOLACMIn.AssignEvents;
begin
inherited;
 DoAssignEvents(SL, AName, ['OnBufferFull'], [@OnBufferFull]);

end;

{--------------------------}
{ ƒŒ¡¿¬À≈Õ»≈ ¬ unitX_X.inc }
{--------------------------}
procedure TKOLACMIn.SetupFirst;
begin
 SL.Add(Prefix + AName + ' := NewACMIn;');
end;

{--------------------------}
{ ƒŒ¡¿¬À≈Õ»≈ ¬ unitX_X.inc }
{--------------------------}
procedure TKOLACMIn.SetupLast;
const BoolToStr: array [Boolean] of String = ('FALSE', 'TRUE');
begin
// SL.Add(Prefix + AName + '.myInt := ' + Int2Str(myInt) + ';');
 SL.Add(Prefix + AName + '.BufferSize:=2048;');
 SL.Add(Prefix + AName + '.UseTempFile:='+ BoolToStr[UseTempFile]+';');

end;
////////////////////////////////////////////////////////////////////////////////

{-------------}
{  ŒÕ—“–” “Œ– }
{-------------}
constructor TKOLACMIn.Create;
begin
 inherited;


end;
destructor TKOLACMIn.Destroy;
begin
 inherited;
end;

procedure TKOLACMIn.SetBufferSize(const Value: DWord);
begin
  if FActive then exit;
  FWaveBufSize:= Value;
  Change;
end;


procedure TKOLACMIn.SetUseTempFile(const Value: boolean);
begin
  if FActive then exit;
  FUseTempFile:= Value;
  Change;
end;


{ procedure TKOLACMIn.SetOnMyEvent;
begin
fOnMyEvent := Value;
Change;
end; }


end.
