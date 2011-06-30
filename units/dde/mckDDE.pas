unit mckDDE;

{$R-,T-,H+,X+}

interface

uses
  Windows, Classes, Graphics, Forms, Controls, DDEML, StdCtrls,
  mirror, KOL;

type
  TDataMode = (ddeAutomatic, ddeManual);
  TKOLDDEServerConv = class;

  TMacroEvent = procedure(Sender: TObject; Msg: TStrings) of object;

{ TKOLDDEClientConv }

  TKOLDDEClientConv = class(TKOLObj)
  private
    FDdeService: string;
    FDdeTopic: string;
    FDdeFmt: Integer;
    FOnClose: TOnEvent;
    FOnOpen: TOnEvent;
    FAppName: string;
    FDataMode: TDataMode;
    FConnectMode: TDataMode;
    FWaitStat: Boolean;
    FFormatChars: Boolean;
    procedure SetService(const Value: string);
    procedure SetTopic(const Value: string);
    procedure SetConnectMode(NewMode: TDataMode);
    procedure SetFormatChars(NewFmt: Boolean);
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
  public
    property DdeFmt: Integer read FDdeFmt;
    property WaitStat: Boolean read FWaitStat;
    property DataMode: TDataMode read FDataMode write FDataMode;
  published
    property ServiceApplication: string read FAppName write FAppName;
    property DdeService: string read FDdeService write SetService;
    property DdeTopic: string read FDdeTopic write SetTopic;
    property ConnectMode: TDataMode read FConnectMode write SetConnectMode default ddeManual;
    property FormatChars: Boolean read FFormatChars write SetFormatChars default False;
    property OnClose: TOnEvent read FOnClose write FOnClose;
    property OnOpen: TOnEvent read FOnOpen write FOnOpen;
  end;

{ TKOLDDEClientItem }

  TKOLDDEClientItem = class(TKOLObj)
  private
    FDdeClientConv: TKOLDDEClientConv;
    FDdeClientItem: string;
    FOnChange: TOnEvent;
    procedure SetClientItem(const Val: string);
    procedure SetClientConv(Val: TKOLDDEClientConv);
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
  published
    property DdeConv: TKOLDDEClientConv read FDdeClientConv write SetClientConv;
    property DdeItem: string read FDdeClientItem write SetClientItem;
    property OnChange: TOnEvent read FOnChange write FOnChange;
  end;

{ TKOLDDEServerConv }

  TKOLDDEServerConv = class(TKOLObj)
  private
    FOnOpen: TOnEvent;
    FOnClose: TOnEvent;
    FOnExecuteMacro: TMacroEvent;
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
  published
    property OnOpen: TOnEvent read FOnOpen write FOnOpen;
    property OnClose: TOnEvent read FOnClose write FOnClose;
    property OnExecuteMacro: TMacroEvent read FOnExecuteMacro write FOnExecuteMacro;
  end;

{ TKOLDDEServerItem }

  TKOLDDEServerItem = class(TKOLObj)
  private
    FServerConv: TKOLDDEServerConv;
    FOnChange: TOnEvent;
    FOnPokeData: TOnEvent;
    FFmt: Integer;
  protected
    procedure SetServerConv(SConv: TKOLDDEServerConv);
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
  public
    constructor Create(AOwner: TKOLObj); virtual;
    property Fmt: Integer read FFmt;
  published
    property ServerConv: TKOLDDEServerConv read FServerConv write SetServerConv;
    property OnChange: TOnEvent read FOnChange write FOnChange;
    property OnPokeData: TOnEvent read FOnPokeData write FOnPokeData;
  end;

procedure Register;

implementation

{$R *.dcr}

uses SysUtils, Dialogs, Consts, Clipbrd;

type
  EDdeError = class(Exception);

procedure TKOLDDEClientConv.SetConnectMode(NewMode: TDataMode);
begin
  if FConnectMode <> NewMode then
  begin
    FConnectMode := NewMode;
    Change;
  end;
end;

procedure TKOLDDEClientConv.SetFormatChars(NewFmt: Boolean);
begin
  if FFormatChars <> NewFmt then
  begin
    FFormatChars := NewFmt;
    Change;
  end;
end;

procedure TKOLDDEClientConv.SetService(const Value: string);
begin
  FDdeService := Value;
  Change;
end;

procedure TKOLDDEClientConv.SetTopic(const Value: string);
begin
  FDdeTopic := Value;
  Change;
end;

procedure TKOLDDEClientItem.SetClientConv(Val: TKOLDDEClientConv);
begin
  if Val <> FDdeClientConv then
  begin
    FDdeClientConv := Val;
    Change;
  end;
end;

procedure TKOLDDEClientItem.SetClientItem(const Val: string);
begin
  if Val <> FDdeClientItem then
  begin
    FDdeClientItem := Val;
    Change;
  end;
end;

constructor TKOLDDEServerItem.Create(AOwner: TKOLObj);
begin
  inherited Create(AOwner);
  FFmt := CF_TEXT;
end;

procedure TKOLDDEServerItem.SetServerConv(SConv: TKOLDDEServerConv);
begin
   FServerConv := SConv;
   Change;
end;

procedure Register;
begin
   RegisterComponents('KOLUtil',
                     [TKOLDDEClientConv,
                      TKOLDDEClientItem,
                      TKOLDDEServerConv,
                      TKOLDDEServerItem]);
end;

function TKOLDDEClientConv.AdditionalUnits;
begin
   result := ', KOLDDE';
end;

procedure TKOLDDEClientConv.SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
var s: string;
begin
  SL.Add( Prefix + AName + ' := NewDDEClientConv( Result.Form );' );
  case ConnectMode of
  ddeAutomatic: s:= 'ddeAutomatic';
  ddeManual: s:= 'ddeManual';
  end;
  SL.Add( Prefix + AName + '.ConnectMode := ' + s + ';');
  SL.Add( Prefix + AName + '.DdeService  := ''' + DdeService + ''';');
  SL.Add( Prefix + AName + '.DdeTopic    := ''' + DdeTopic + ''';');
  if FormatChars then s := 'True' else s := 'False';
  SL.Add( Prefix + AName + '.FormatChars := ' + s + ';');
  if ServiceApplication <> '' then
  SL.Add( Prefix + AName + '.ServiceApplication := ''' + ServiceApplication + ''';');
end;

procedure TKOLDDEClientConv.SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
begin
  if ConnectMode = ddeAutomatic then
  SL.Add( Prefix + AName + '.OpenLink;'); 
end;

procedure TKOLDDEClientConv.AssignEvents( SL: TStringList; const AName: String );
begin
  inherited;
  DoAssignEvents( SL, AName,
  [ 'OnClose', 'OnOpen' ],
  [ @OnClose , @OnOpen  ]);
end;

function TKOLDDEClientItem.AdditionalUnits;
begin
   result := ', KOLDDE';
end;

procedure TKOLDDEClientItem.SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
begin
  SL.Add( Prefix + AName + ' := NewDDEClientItem( Result.Form );' );
  SL.Add( Prefix + AName + '.DdeConv := Result.' + DdeConv.Name + ';');
  SL.Add( Prefix + AName + '.DdeItem := ''' + DdeItem + ''';');
end;

procedure TKOLDDEClientItem.SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
begin
end;

procedure TKOLDDEClientItem.AssignEvents( SL: TStringList; const AName: String );
begin
  inherited;
  DoAssignEvents( SL, AName,
  [ 'OnChange' ],
  [ @OnChange  ]);
end;

function TKOLDDEServerConv.AdditionalUnits;
begin
   result := ', KOLDDE';
end;

procedure TKOLDDEServerConv.SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
begin
  SL.Add( Prefix + AName + ' := NewDDEServerConv( Result.Form );' );
  SL.Add( Prefix + AName + '.Name := ''' + Name + ''';');
end;

procedure TKOLDDEServerConv.SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
begin
end;

procedure TKOLDDEServerConv.AssignEvents( SL: TStringList; const AName: String );
begin
  inherited;
  DoAssignEvents( SL, AName,
  [ 'OnClose', 'OnOpen', 'OnExecuteMacro' ],
  [ @OnClose , @OnOpen , @OnExecuteMacro  ]);
end;

function TKOLDDEServerItem.AdditionalUnits;
begin
   result := ', KOLDDE';
end;

procedure TKOLDDEServerItem.SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
begin
  SL.Add( Prefix + AName + ' := NewDDEServerItem( Result.Form );' );
  SL.Add( Prefix + AName + '.Name := ''' + Name + ''';');
  SL.Add( Prefix + AName + '.Conv := Result.' + ServerConv.Name + ';');
end;

procedure TKOLDDEServerItem.SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
begin
end;

procedure TKOLDDEServerItem.AssignEvents( SL: TStringList; const AName: String );
begin
  inherited;
  DoAssignEvents( SL, AName,
  [ 'OnChange', 'OnPokeData' ],
  [ @OnChange , @OnPokeData  ]);
end;

end.

